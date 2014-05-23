module Rubygoal
  class FastPlayer < Player
    def initialize(*args)
      super
      @error = 0.10 + Random.rand(0.05)
      @speed = 4
    end

    protected

    def image_filename(side)
      case side
      when :home
        Config.player.fast_home_image_file
      when :away
        Config.player.fast_away_image_file
      end
    end
  end
end
