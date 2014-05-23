require 'gosu'

require 'rubygoal/config'

module Rubygoal
  class Goal
    def initialize(game_window)
      @goal_image = Gosu::Image.new(game_window, Config.goal.image_file, true)

      @celebration_time = 0
    end

    def celebration_done?
      !celebrating?
    end

    def draw
      position = Config.game.goal_image_position
      goal_image.draw(position.x, position.y, 1)
    end

    def update(elapsed_time)
      start_celebration unless celebrating?
      self.celebration_time -= elapsed_time
    end

    protected

    attr_accessor :celebration_time

    private

    attr_reader :goal_image

    def start_celebration
      self.celebration_time = 3
    end

    def celebrating?
      celebration_time > 0
    end
  end
end
