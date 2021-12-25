#!/usr/bin/ruby
# frozen_string_literal: true

module ExerciseThree
  class BinaryDiagnostic
    attr_reader :gamma_rate, :epsilon_rate, :oxygen_generator_rating, :scrubber_rating

    def initialize(file_string_path)
      file = File.open(file_string_path)
      @diagnostic_report = file.readlines.map(&:chomp)
      file.close
    end

    def power_consumption
      gamma_rate = []
      epsilon_rate = []

      number_distribution.each do |line|
        gamma_rate << line.max_by { |_k, v| v }[0]
        epsilon_rate << line.min_by { |_k, v| v }[0]
      end

      @gamma_rate = gamma_rate.join('').to_i(2)
      @epsilon_rate = epsilon_rate.join('').to_i(2)

      @gamma_rate * @epsilon_rate
    end

    def life_support_rating
      input_line_length = @diagnostic_report.first.size
      oxygen_rate = []
      scrubber_rating = []

      oxygen_rate_report = @diagnostic_report.dup
      scrubber_rating_report = @diagnostic_report.dup

      (0...input_line_length).each do |i|
        oxygen_rate_distribution = number_distribution(oxygen_rate_report)
        if oxygen_rate_distribution[i].count > 1
          maximum = oxygen_rate_distribution[i].max_by { |_k, v| v }
          minimum = oxygen_rate_distribution[i].min_by { |_k, v| v }

          oxygen_rate << if maximum[1] == minimum[1]
                           '1'
                         else
                           maximum[0]
                         end
        else
          oxygen_rate << oxygen_rate_distribution[i].keys.first.to_s
        end

        oxygen_rate_report.select! { |line| line[i] == oxygen_rate.last }

        next unless oxygen_rate_report.count == 1

        oxygen_rate = oxygen_rate_report.pop.split('')
        break
      end

      (0...input_line_length).each do |i|
        scrubber_rating_distribution = number_distribution(scrubber_rating_report)
        if scrubber_rating_distribution[i].count > 1
          maximum = scrubber_rating_distribution[i].max_by { |_k, v| v }
          minimum = scrubber_rating_distribution[i].min_by { |_k, v| v }

          scrubber_rating << if maximum[1] == minimum[1]
                               '0'
                             else
                               minimum[0]
                             end
        else
          scrubber_rating << scrubber_rating_distribution[i].keys.first.to_s
        end

        scrubber_rating_report.select! { |line| line[i] == scrubber_rating.last }

        next unless scrubber_rating_report.count == 1

        scrubber_rating = scrubber_rating_report.pop.split('')
        break
      end

      @oxygen_generator_rating = oxygen_rate.join('').to_i(2)
      @scrubber_rating = scrubber_rating.join('').to_i(2)

      @oxygen_generator_rating * @scrubber_rating
    end

    private

    def number_distribution(input_array = nil)
      distribution = []
      report = input_array || @diagnostic_report

      report.each do |line|
        index = 0
        line.each_char do |char|
          if distribution[index]
            distribution[index][char] = 0 if distribution[index][char].nil?
            distribution[index][char] += 1
          else
            count = {}
            count[char] = 1
            distribution << count
          end
          index += 1
        end
      end
      distribution
    end
  end
end

binary_diagnostic = ExerciseThree::BinaryDiagnostic.new('./exercise_3_input.txt')
puts binary_diagnostic.power_consumption
puts binary_diagnostic.life_support_rating
