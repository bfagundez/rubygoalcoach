# -*- encoding: utf-8 -*-

require 'timecop'

require 'rubygoal/game'

module Rubygoal
  class GameTest < Game
    def recorded_lines
      lines = [
        "Ball #{field.ball.position}",
        "Score #{score_home} - #{score_away}",
      ]
      field.team_home.players.each_with_index do |p, i|
        lines << "Team home: player #{i} #{p.position}"
      end
      field.team_away.players.each_with_index do |p, i|
        lines << "Team away: player #{i} #{p.position}"
      end
      lines
    end

    def record
      File.open(File.dirname(__FILE__) + '/record.txt', 'w') do |record_file|
        init_time = Time.now
        (60 * 300).times do |i|
          Timecop.freeze(init_time + i/60) { update }
          recorded_lines.each { |l| record_file.puts(l) }
        end
      end
    end

    def test
      @success = true

      File.open(File.dirname(__FILE__) + '/record.txt', 'r') do |record_file|
        init_time = Time.now
        (60 * 300).times do |i|
          Timecop.freeze(init_time + i/60) { update }
          recorded_lines.each do |line|
            data = record_file.gets
            @success &&= assert(data, line)
          end
          break unless @success
        end
      end

      p "Caso de éxito!" if @success
    end

    private

    def assert(expected, actual)
      if actual == expected.chomp
        true
      else
        p "ERROR: Expected \"#{expected}\" - Actual \"#{actual}\""
        false
      end
    end
  end

  if ENV['mode'] == 'record'
    class Random
      def self.clear_random_list
        @random_list = []
      end

      def self.rand(*args)
        result = super(*args)
        @random_list << result
        result
      end

      def self.record
        File.open(File.dirname(__FILE__) + '/random.txt', 'w') do |random_file|
          @random_list.each { |n| random_file.puts n }
        end
      end
    end

    Random.clear_random_list
    GameTest.new.record
    Random.record
  else
    class Random
      def self.load_random_list
        @random_list = []
        File.open(File.dirname(__FILE__) + '/random.txt', 'r') do |random_file|
          while number = random_file.gets
            @random_list << number.to_f
          end
        end
      end

      def self.rand(*args)
        @random_list.shift
      end
    end

    Random.load_random_list
    GameTest.new.test
  end
end
