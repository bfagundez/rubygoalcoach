require 'gosu'
require 'forwardable'

require 'rubygoal/coordinate'
require 'rubygoal/field'
require 'rubygoal/field_metrics'
require 'rubygoal/goal'

module Rubygoal
  class Game < Gosu::Window
    attr_reader :field, :time, :score_home, :score_away

    extend Forwardable
    def_delegators :field, :ball, :close_to_goal?

    def initialize
      super(1920, 1080, true)
      self.caption = "Ruby Goal"

      @field = Field.new(self)
      @goal = Goal.new(self)

      @state = :playing

      @time = Config.game.time
      @score_home = 0
      @score_away = 0

      @font = Gosu::Font.new(
        self,
        Gosu.default_font_name,
        Config.game.default_font_size
      )

      @home_team_label = create_label_image(name_home)
      @away_team_label = create_label_image(name_away)
    end

    def update
      return if state == :ended

      update_elapsed_time

      if field.goal?
        update_goal
      else
        update_remaining_time
        field.update
      end

      end_match! if time <= 0
    end

    def draw
      field.draw
      draw_scoreboard
      draw_team_labels
      goal.draw if field.goal?
    end

    def button_down(id)
      if id == Gosu::KbEscape
        close
      end
    end

    protected

    attr_writer :time, :score_home, :score_away
    attr_accessor :state, :last_time, :elapsed_time

    private

    attr_reader :font, :goal, :home_team_label, :away_team_label

    def create_label_image(name)
      name = truncate_label(name, Config.game.max_name_length)
      Gosu::Image.from_text(
        self,
        name,
        Gosu.default_font_name,
        Config.game.team_label_font_size,
        1,
        Config.game.team_label_width,
        :center
      )
    end

    def truncate_label(name, limit)
      words = name.split

      left = limit
      truncated = []
      words.each do |word|
        break unless left > 0

        truncated << word
        left -= word.length + 1
      end

      truncated.join(' ')[0..limit]
    end

    def update_elapsed_time
      self.last_time ||= Time.now

      self.elapsed_time = Time.now - last_time
      self.last_time = Time.now
    end

    def update_remaining_time
      self.time -= elapsed_time
    end

    def update_goal
      goal.update(elapsed_time)
      reinitialize_match if goal.celebration_done?
    end

    def reinitialize_match
      if FieldMetrics.position_side(ball.position) == :home
        self.score_away += 1
      else
        self.score_home += 1
      end

      field.reinitialize
    end

    def draw_scoreboard
      draw_text(time_text, Config.game.time_label_position, :gray)
      draw_text(score_home.to_s, Config.game.score_home_label_position, :white)
      draw_text(score_away.to_s, Config.game.score_away_label_position, :white)
    end

    def draw_team_labels
      pos = Config.game.home_team_label_position
      home_team_label.draw_rot(pos.x, pos.y, 1, -90)
      pos = Config.game.away_team_label_position
      away_team_label.draw_rot(pos.x, pos.y, 1, 90)
    end

    def draw_text(text, position, color, size = 1)
      font.draw_rel(text, position.x, position.y, 0.5, 0.5, 1, size, size, color_to_hex(color))
    end

    def time_text
      minutes = Integer(time) / 60
      seconds = Integer(time) % 60
      "%d:%02d" % [minutes, seconds]
    end

    def color_to_hex(color)
      case color
      when :white
        0xffffffff
      when :gray
        0xff6d6e70
      end
    end

    def end_match!
      self.state = :ended
      write_score
    end

    def write_score
      puts "#{name_home} #{score_home} - #{score_away} #{name_away}"
    end

    def name_home
      field.team_names[:home]
    end

    def name_away
      field.team_names[:away]
    end
  end
end
