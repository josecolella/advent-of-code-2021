#!/usr/bin/ruby
# frozen_string_literal: true

diagnostic_report = []
index = 0

# O(n) -> n is the number of lines
IO.foreach('./exercise_3_input.txt') do |line|
  index = 0
  # O(m) -> number of char in a line
  line.chomp.each_char do |char|
    if diagnostic_report[index]
      diagnostic_report[index][char] = 0 if diagnostic_report[index][char].nil?
      diagnostic_report[index][char] += 1
    else
      count = {}
      count[char] = 1
      diagnostic_report << count
    end
    index += 1
  end
end

gamma_rate = []
epsilon_rate = []

# O(n)-> length of the array
diagnostic_report.each do |line|
  # O(k) -> size of the hash
  gamma_rate << line.max_by { |_k, v| v }[0]
  epsilon_rate << line.min_by { |_k, v| v }[0]
end

decimal_gamma_rate = gamma_rate.join('').to_i(2)
decimal_epsilon_rate = epsilon_rate.join('').to_i(2)

puts decimal_gamma_rate * decimal_epsilon_rate
