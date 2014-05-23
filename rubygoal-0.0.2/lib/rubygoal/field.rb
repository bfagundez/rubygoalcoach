require 'forwardable'
require 'gosu'

require 'rubygoal/ball'
require 'rubygoal/coach_loader'
require 'rubygoal/team'
require 'rubygoal/field_metrics'
require 'rubygoal/match'
require 'rubygoal/coaches/coach_home'
require 'rubygoal/coaches/coach_away'

module Rubygoal
  class Field
    attr_reader :ball, :team_home, :team_away

    extend Forwardable
    def_delegators :ball, :goal?

    def initialize(game_window)
      @game_window = game_window
      @background_image = Gosu::Image.new(game_window, Config.field.background_image_file, true)

      @ball = Ball.new(game_window, FieldMetrics.center_position)

      coach_home = CoachLoader.get(CoachHome)
      coach_away = CoachLoader.get(CoachAway)

      puts "Home coach: #{coach_home.class.name}"
      puts "Away coach: #{coach_away.class.name}"

      @team_home = Team.new(game_window, :home, coach_home)
      @team_away = Team.new(game_window, :away, coach_away)
    end

    def reinitialize
      team_home.players_to_initial_position
      team_away.players_to_initial_position
      ball.position = FieldMetrics.center_position
    end

    def team_names
      {
        home: team_home.name,
        away: team_away.name
      }
    end

    def update
      team_home.update(game_data(:home))
      team_away.update(game_data(:away))
      ball.update
    end

    def draw
      background_image.draw(0, 0, 0);
      ball.draw
      team_home.draw
      team_away.draw
    end

    private

    def game_data(side)
      case side
      when :home
        Match.new(
          game_window.score_home,
          game_window.score_away,
          game_window.time,
          team_away.formation
        )
      when :away
        Match.new(
          game_window.score_away,
          game_window.score_home,
          game_window.time,
          team_home.formation
        )
      end
    end

    attr_reader :background_image, :game_window
  end
end
