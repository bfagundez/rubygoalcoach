require 'forwardable'

require 'rubygoal/config'
require 'rubygoal/formation'
require 'rubygoal/field_metrics'
require 'rubygoal/player'

module Rubygoal
  class Team
    attr_reader :game, :players, :side, :coach, :formation
    attr_accessor :goalkeeper, :positions

    INFINITE = 100_000

    extend Forwardable
    def_delegators :coach, :name

    def initialize(game_window, side, coach)
      @game = game_window
      @players = []
      @side = side
      @coach = coach

      initialize_formation
      initialize_players(game_window)
    end

    def players_to_initial_position
      positions = FieldMetrics.initial_player_positions(side)
      players.each_with_index do |player, index|
        player.position = positions[index]
      end
    end

    def update(match)
      self.formation = coach.formation(match)
      unless formation.valid?
        puts formation.errors
        raise "Invalid formation: #{coach.name}"
      end
      update_positions(formation.lineup)

      player_to_move = nil
      min_distance_to_ball = INFINITE
      players.each do |player|
        pass_or_shoot(player) if player.can_kick?(game.ball)

        distance_to_ball = player.distance(game.ball.position)
        if min_distance_to_ball > distance_to_ball
          min_distance_to_ball = distance_to_ball
          player_to_move = player
        end
      end

      player_to_move.move_to(game.ball.position)

      average_players = []
      fast_players = []
      captain_player = nil

      players.each do |player|
        if player.is_a? AveragePlayer
          average_players << player
        elsif player.is_a? FastPlayer
          fast_players << player
        else
          captain_player = player
        end
      end

      if captain_player != player_to_move
        captain_player.move_to(positions[:captain])
      end
      captain_player.update

      average_players.each_with_index do |player, index|
        if player != player_to_move
          player.move_to(positions[:average][index])
        end

        player.update
      end

      fast_players.each_with_index do |player, index|
        if player != player_to_move
          player.move_to(positions[:fast][index])
        end

        player.update
      end
    end

    def draw
      players.each(&:draw)
    end

    private

    attr_writer :formation

    def initialize_formation
      @formation = Formation.new
      @formation.lineup = [
        [:average, :none, :average, :none, :none   ],
        [:average, :none, :fast,    :none, :captain],
        [:none,    :none, :none,    :none, :none   ],
        [:average, :none, :fast,    :none, :fast   ],
        [:average, :none, :average, :none, :none   ]
      ]
    end

    def initialize_players(game_window)
      Config.team.average_players_count.times do
        players << AveragePlayer.new(game_window, side)
      end
      Config.team.fast_players_count.times do
        players << FastPlayer.new(game_window, side)
      end
      Config.team.captain_players_count.times do
        players << CaptainPlayer.new(game_window, side)
      end

      players_to_initial_position
    end

    def pass_or_shoot(player)
      # Kick straight to the goal whether the distance is short (200)
      # or we don't have a better option
      target = shoot_target

      unless FieldMetrics.close_to_goal?(player.position, opponent_side)
        if teammate = nearest_forward_teammate(player)
          target = teammate.position
        end
      end

      player.kick(game.ball, target)
    end

    def nearest_forward_teammate(player)
      min_dist = INFINITE
      nearest_teammate = nil

      (players - [player]).each do |teammate|
        if side == :home
          is_forward = teammate.position.x > player.position.x + 40
        else
          is_forward = teammate.position.x < player.position.x - 40
        end

        if is_forward
          dist = player.distance(teammate.position)
          if min_dist > dist
            nearest_teammate = teammate
            min_dist = dist
          end
        end
      end

      nearest_teammate
    end

    def opponent_side
      if side == :home
        :away
      else
        :home
      end
    end

    def shoot_target
      # Do not kick always to the center, look for the sides of the goal
      limit = Config.field.goal_height / 2
      offset = Random.rand(-limit..limit)

      target = FieldMetrics.goal_position(opponent_side)
      target.y += offset
      target
    end

    def update_positions(lineup)
      self.positions = {
        average: [FieldMetrics.goalkeeper_position(side)],
        fast: []
      }

      lineup.each_with_index do |row, i|
        row.each_with_index do |player, j|
          if player == :average
            positions[:average] << matrix_to_position(i, j)
          elsif player == :captain
            positions[:captain] = matrix_to_position(i, j)
          elsif player == :fast
            positions[:fast] << matrix_to_position(i, j)
          end
        end
      end
    end

    def matrix_to_position(i, j)
      step_x = Config.field.width / 6
      step_y = Config.field.height / 6
      if side == :home
        Config.field.offset.add(
          Position.new((j+1) * step_x - 30, (i+1) * step_y)
        )
      else
        Config.field.offset.add(
          Position.new(
            Config.field.width - (j+1) * step_x + 30,
            Config.field.height - (i+1) * step_y
          )
        )
      end
    end
  end
end
