require 'rubygoal/config'
require 'rubygoal/coordinate'
require 'rubygoal/field_metrics'

module Rubygoal
  module FieldMetrics
    class << self
      def center_position
        center = Position.new(
          Config.field.width / 2,
          Config.field.height / 2
        )
        Config.field.offset.add(center)
      end

      def goal_position(side)
        position = center_position
        case side
        when :home
          position.x = Config.field.offset.x
        when :away
          position.x = Config.field.offset.x + Config.field.width
        end
        position
      end

      def initial_player_positions(side)
        Config.team.initial_player_positions.map do |pos|
          case side
          when :home
            Position.new(
              Config.field.offset.x + pos[0],
              Config.field.offset.y + pos[1]
            )
          when :away
            Position.new(
              Config.field.offset.x + Config.field.width - pos[0],
              Config.field.offset.y + Config.field.height - pos[1]
            )
          end
        end
      end

      def goalkeeper_position(side)
        initial_player_positions(side).first
      end

      def position_side(position)
        if position.x < FieldMetrics.center_position.x
          :home
        else
          :away
        end
      end

      def out_of_bounds_width?(position)
        lower_limit = Config.field.offset.x
        upper_limit = Config.field.offset.x + Config.field.width
        !(lower_limit..upper_limit).include?(position.x)
      end

      def out_of_bounds_height?(position)
        lower_limit = Config.field.offset.y
        upper_limit = Config.field.offset.y + Config.field.height
        !(lower_limit..upper_limit).include?(position.y)
      end

      def goal?(position)
        if out_of_bounds_width?(position)
          lower_limit = center_position.y - Config.field.goal_height / 2
          upper_limit = center_position.y + Config.field.goal_height / 2

          (lower_limit..upper_limit).include?(position.y)
        else
          false
        end
      end

      def close_to_goal?(position, side)
        goal_position = FieldMetrics.goal_position(side)
        goal_position.distance(position) < Config.field.close_to_goal_distance
      end
    end
  end
end
