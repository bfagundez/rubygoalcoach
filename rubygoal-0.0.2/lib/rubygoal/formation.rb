module Rubygoal
  class Formation
    attr_accessor :lineup

    def initialize
      @lineup = [
        [:none, :none, :none, :none, :none],
        [:none, :none, :none, :none, :none],
        [:none, :none, :none, :none, :none],
        [:none, :none, :none, :none, :none],
        [:none, :none, :none, :none, :none],
      ]
    end

    def defenders
      column(0)
    end

    def midfielders
      column(2)
    end

    def attackers
      column(4)
    end

    def column(i)
      lineup.map { |row| row[i] }
    end

    def defenders=(f)
      assign_column(0, f)
    end

    def midfielders=(f)
      assign_column(2, f)
    end

    def attackers=(f)
      assign_column(4, f)
    end

    def assign_column(index, column)
      column.each_with_index do |player, row_index|
        lineup[row_index][index] = player
      end
    end

    def errors
      errors = {}

      unified  = lineup.flatten
      captains = unified.count(:captain)
      fast     = unified.count(:fast)
      average  = unified.count(:average)
      total    = captains + fast + average

      errors[:captains] = "La cantidad de capitanes es #{captains}" if captains != 1
      errors[:fast] = "La cantidad de rapidos es #{fast}" if fast != 3
      errors[:total] = "La cantidad total de jugadores es #{total}" if total != 10

      errors
    end

    def valid?
      errors.empty?
    end
  end
end
