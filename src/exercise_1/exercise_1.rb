#!/usr/bin/ruby
# frozen_string_literal: true

module ExerciseOne
  def read_file_into_array(file_path)
    if File.exist? file_path
      file = File.open(file_path)
      file.readlines.map { |x| x.chomp.to_i }

    else
      raise StandardError, "#{file_path} is not a valid File path"
    end
  end

  def count_increments(input_file_path)
    increments = 0

    input = read_file_into_array(input_file_path)

    (1...input.size).each do |i|
      increments += 1 if input[i] > input[i - 1]
    end

    increments
  end
end

puts ExerciseOne.count_increments('./exercise_1_input.txt')
