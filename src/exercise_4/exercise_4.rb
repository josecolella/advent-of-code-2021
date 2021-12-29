#!/usr/bin/ruby
# frozen_string_literal: true

require 'set'

module GiantSquid
  class Solution
    attr_reader :winning_board_index, :winning_number, :unmarked_numbers, :draw_numbers, :row_boards, :column_boards

    def initialize(file_path_string)
      file = File.open(file_path_string)
      draw_numbers_string, *boards_string = file.readlines.map(&:chomp)
      @draw_numbers = initialize_draw_numbers(draw_numbers_string)
      @row_boards = []
      board = []
      boards_string.each do |line|
        if line != ''
          board << line.split(' ').map(&:to_i)
        else
          @row_boards << board if board.count > 1
          board = []
        end
      end
      @column_boards = @row_boards.map(&:transpose)
      file.close
    end

    def part_one
      @draw_numbers.each do |draw_number|
        break unless @winning_board_index.nil?

        @row_boards.each_with_index do |board, index|
          board.each do |row|
            row.delete(draw_number)
            next unless row.empty?

            @winning_board_index = index
            @winning_number = draw_number
            break
          end
        end

        @column_boards.each_with_index do |board, index|
          board.each do |row|
            row.delete(draw_number)
            next unless row.empty?

            @winning_board_index = index
            @winning_number = draw_number
            break
          end
        end
      end

      @unmarked_numbers = @row_boards[winning_board_index].flatten.sum

      @unmarked_numbers * @winning_number
    end

    def part_two
      winning_boards = Set.new
      last_to_win_number = -1
      last_to_win_index = -1

      @draw_numbers.each do |draw_number|
        break unless last_to_win_number == -1

        @row_boards.each_with_index do |board, index|
          board.each do |row|
            row.delete(draw_number)
            next unless row.empty? && last_to_win_index == -1

            winning_boards.add(index)
            if winning_boards.count == @row_boards.count
              last_to_win_number = draw_number
              last_to_win_index = index
            end

            break
          end
        end

        break unless last_to_win_number == -1

        @column_boards.each_with_index do |board, index|
          board.each do |row|
            row.delete(draw_number)
            next unless row.empty? && last_to_win_index == -1

            winning_boards.add(index)
            if winning_boards.count == @column_boards.count
              last_to_win_number = draw_number
              last_to_win_index = index
            end
            break
          end
        end
      end

      @unmarked_numbers = @row_boards[last_to_win_index].flatten.sum

      puts @row_boards[last_to_win_index].inspect
     
      last_to_win_number * @unmarked_numbers
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
puts solution.part_two
