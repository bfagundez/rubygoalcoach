require 'gosu'

require 'rubygoal/field_metrics'
require 'rubygoal/moveable'

module Rubygoal
  class Ball
    include Moveable

    def initialize(window, position)
      super()
      @position = position
      @image = Gosu::Image.new(window, Config.ball.image_file, false)
    end

    def goal?
      FieldMetrics.goal?(position)
    end

    def draw
      image.draw(position.x - Config.ball.width / 2, position.y - Config.ball.height / 2, 1)
    end

    def update
      super
      if FieldMetrics.out_of_bounds_width?(position)
        velocity.x *= -1
      end
      if FieldMetrics.out_of_bounds_height?(position)
        velocity.y *= -1
      end

      velocity.x *= 0.95
      velocity.y *= 0.95
    end

    private

    attr_reader :image
  end
end
