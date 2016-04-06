require_relative 'movements/application'

puts Movements::Application.calculate_end_positions(ARGF.readlines)
