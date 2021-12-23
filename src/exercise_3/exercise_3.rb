#!/usr/bin/ruby
# frozen_string_literal: true

diagnostic_report = []
index = 0
lines = []
# O(n) -> n is the number of lines
IO.foreach('./exercise_3_input.txt') do |line|
  index = 0
  clean_line = line.chomp

  lines << clean_line
  # O(m) -> number of char in a line
  clean_line.each_char do |char|
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

def get_diagnostic_report(lines)
  d = []

  lines.each do |line|
    # O(m) -> number of char in a line
    index = 0
    line.each_char do |char|
      if d[index]
        d[index][char] = 0 if d[index][char].nil?
        d[index][char] += 1
      else
        count = {}
        count[char] = 1
        d << count
      end
      index += 1
    end
  end

  d
end
# O(n)-> length of the array
diagnostic_report.each do |line|
  # O(k) -> size of the hash
  gamma_rate << line.max_by { |_k, v| v }[0]
  epsilon_rate << line.min_by { |_k, v| v }[0]
end

first_most_common = gamma_rate[0]

input_line_length = gamma_rate.join('').size
oxygen_rate = []
other_one = []

lines_one = lines.dup
lines_two = lines.dup

(0...input_line_length).each do |i|
  t = get_diagnostic_report(lines_one)
  maximum = t[i].max_by { |_k, v| v }
  minimum = t[i].min_by { |_k, v| v }

  oxygen_rate << if maximum[1] == minimum[1]
                   '1'
                 else
                   maximum[0]
                 end
  lines_one.select! { |line| line[i] == oxygen_rate.last }
end

(0...input_line_length).each do |i|
  t = get_diagnostic_report(lines_two)

  maximum = t[i].max_by { |_k, v| v }
  minimum = t[i].min_by { |_k, v| v }

  other_one << if maximum[1] == minimum[1]
                 '0'
               else
                 minimum[0]
               end
  lines_two.select! { |line| line[i] == other_one.last }
end

# decimal_other_rate = other_one.join('').to_i(2)
decimal_oxygen_rate = oxygen_rate.join('').to_i(2)

puts decimal_oxygen_rate
decimal_gamma_rate = gamma_rate.join('').to_i(2)
decimal_epsilon_rate = epsilon_rate.join('').to_i(2)

puts decimal_gamma_rate * decimal_epsilon_rate
# puts decimal_oxygen_rate * decimal_other_rate
