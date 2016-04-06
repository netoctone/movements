require_relative 'movements/application'

def assert_equal(o1, o2)
  raise "Expected '#{o1}' to == '#{o2}'" if o1 != o2
end

def test_rover_rotations
  rover = Movements::Rover.new(0, 0, 'N')

  ['W', 'S', 'E', 'N', 'W'].each do |expected_direction|
    rover.rotate_left
    assert_equal rover.direction, expected_direction
    assert_equal rover.x, 0
    assert_equal rover.y, 0
  end

  ['N', 'E', 'S', 'W'].each do |expected_direction|
    rover.rotate_right
    assert_equal rover.direction, expected_direction
    assert_equal rover.x, 0
    assert_equal rover.y, 0
  end
end
test_rover_rotations

def test_rover_movements
  rover = Movements::Rover.new(0, 0, 'N')

  rover.move
  rover.move
  assert_equal rover.x, 0
  assert_equal rover.y, 2
  assert_equal rover.direction, 'N'

  rover.rotate_right
  assert_equal rover.direction, 'E'

  rover.move
  rover.move
  rover.move
  assert_equal rover.x, 3
  assert_equal rover.y, 2
  assert_equal rover.direction, 'E'

  rover.rotate_right
  assert_equal rover.direction, 'S'

  rover.move
  assert_equal rover.x, 3
  assert_equal rover.y, 1
  assert_equal rover.direction, 'S'

  rover.rotate_right
  assert_equal rover.direction, 'W'

  rover.move
  rover.move
  assert_equal rover.x, 1
  assert_equal rover.y, 1
  assert_equal rover.direction, 'W'
end
test_rover_movements

def test_application
  out1 = Movements::Application.calculate_end_positions([
    "10 10",
    "0 0 N",
    "MMM"
  ])
  assert_equal out1, ["0 3 N"]

  raised2 = false
  begin
    out2 = Movements::Application.calculate_end_positions([
      "2 2",
      "0 0 N",
      "MMM"
    ])
  rescue
    raised2 = true
  ensure
    assert_equal raised2, true
  end

  out3 = Movements::Application.calculate_end_positions([
    "10 10",
    "1 1 N",
    "MLMLMLMLMRMRMRMR" * 10 # ten 8-shaped cycles
  ])
  assert_equal out3, ["1 1 N"]

  out4 = Movements::Application.calculate_end_positions([
    "10 10",
    "10 10 S",
    "M" * 5 + "R" + "M" * 5,
    "0 0 E",
    "M" * 5 + "L" + "M" * 5
  ])

  assert_equal out4, ["5 5 W", "5 5 N"]
end
test_application

puts "Build successful"
