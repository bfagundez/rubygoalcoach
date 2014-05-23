module Rubygoal
  module Config
    class Field  < Struct.new(:width,
                              :height,
                              :offset,
                              :goal_height,
                              :close_to_goal_distance,
                              :background_image_file)
    end

    class Team   < Struct.new(:initial_player_positions,
                             :average_players_count,
                             :fast_players_count,
                             :captain_players_count)
    end

    class Ball   < Struct.new(:width,
                              :height,
                              :image_file)
    end

    class Player < Struct.new(:time_to_kick_again,
                              :distance_control_ball,
                              :kick_strength,
                              :average_home_image_file,
                              :average_away_image_file,
                              :fast_home_image_file,
                              :fast_away_image_file,
                              :captain_home_image_file,
                              :captain_away_image_file)
    end

    class Goal   < Struct.new(:image_file,
                              :sound_file)
    end

    class Game   < Struct.new(:time,
                              :goal_image_position,
                              :time_label_position,
                              :score_home_label_position,
                              :score_away_label_position,
                              :max_name_length,
                              :default_font_size,
                              :team_label_font_size,
                              :team_label_width,
                              :home_team_label_position,
                              :away_team_label_position,
                              :background_sound_file)
    end

    class << self
      def field
        @field ||= Field.new
      end

      def team
        @team ||= Team.new
      end

      def ball
        @ball ||= Ball.new
      end

      def player
        @player ||= Player.new
      end

      def goal
        @goal ||= Goal.new
      end

      def game
        @game ||= Game.new
      end
    end
  end
end
