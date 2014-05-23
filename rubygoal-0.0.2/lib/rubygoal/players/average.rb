module Rubygoal
  class AveragePlayer < Player
    def initialize(*args)
      super
      @error = 0.10 + Random.rand(0.05)
      @speed = 3.5
    end

    protected

    def image_filename(side)
      case side
      when :home
        Config.player.average_home_image_file
      when :away
        Config.player.average_away_image_file
      end
    end
  end
end
