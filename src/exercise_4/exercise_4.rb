#!/usr/bin/ruby
# frozen_string_literal: true

require 'set'

module GiantSquid
  class Solution
    attr_reader :winning_board_index, :winning_number, :unmarked_numbers, :draw_numbers, :boards

    def initialize(file_path_string)
      file = File.open(file_path_string)
      draw_numbers_string, *boards_string = file.readlines.map(&:chomp)
      @draw_numbers = initialize_draw_numbers(draw_numbers_string)
      @boards = []
      b = []
      boards_string.each do |line|
        if line != ''
          b << line.split(' ').map(&:to_i)
        else
          @boards << b if b.count > 1
          b = []
        end
      end
      file.close
    end

    def part_one
      @draw_numbers.each do |draw_number|
        break unless @winning_board_index.nil?

        @boards.each_with_index do |board, index|
          board.each do |row|
            row.delete(draw_number)
            next unless row.empty?

            @winning_board_index = index
            @winning_number = draw_number
            break
          end
        end
      end

      @unmarked_numbers = @boards[winning_board_index].flatten.sum

      @unmarked_numbers * @winning_number
    end

    private

    def initialize_draw_numbers(draw_numbers_string)
      draw_numbers_string.split(',').map(&:to_i)
    end

    def initialize_boards(boards_string)
      boards = []
      board = []
      boards_string.each do |line|
        if line != ''
          boards << line.split(' ').map(&:to_i)
        else
          boards << board if board.count > 1
          board = []
        end
      end
      boards
    end
  end
end

solution = GiantSquid::Solution.new('./exercise_4_input.txt')
puts solution.part_one
