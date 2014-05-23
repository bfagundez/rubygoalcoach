module Rubygoal
  class CaptainPlayer < Player
    def initialize(*args)
      super
      @error = 0.05
      @speed = 4.5
    end

    protected

    def image_filename(side)
      case side
      when :home
        Config.player.captain_home_image_file
      when :away
        Config.player.captain_away_image_file
      end
    end
  end
end
