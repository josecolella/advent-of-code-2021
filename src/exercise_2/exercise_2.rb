#!/usr/bin/ruby
# frozen_string_literal: true

module ExerciseTwo
  class Solver
    attr_reader :forward_count, :depth, :result

    def initialize(file_path)
      @file = File.open(file_path)
      @forward_count = 0
      @depth = 0
      @result = 0
    end

    def solve
      @file.each_line do |line|
        last_digit_str = line.chomp[-1]
        @forward_count += Integer(last_digit_str, 10) if line.start_with? 'forward'
        @depth += Integer(last_digit_str, 10) if line.start_with? 'down'
        @depth -= Integer(last_digit_str, 10) if line.start_with? 'up'
      end

      @result = @forward_count * @depth
    end
  end
end

current_working_directory = File.expand_path(File.dirname(File.dirname(__FILE__))) 
solver = ExerciseTwo::Solver.new(current_working_directory+ '/exercise_2_input.txt')
solver.solve

puts "Forward: #{solver.forward_count}"
puts "Depth: #{solver.depth}"
puts "Total: #{solver.result}"
