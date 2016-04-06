module Movements

  class Rover

    DIRECTION_TO_DELTA = {
      'N' => { dx:  0, dy:  1 },
      'W' => { dx: -1, dy:  0 },
      'S' => { dx:  0, dy: -1 },
      'E' => { dx:  1, dy:  0 }
    }

    ROTATE_LEFT = {
      'N' => 'W',
      'W' => 'S',
      'S' => 'E',
      'E' => 'N'
    }

    ROTATE_RIGHT = ROTATE_LEFT.invert

    attr_accessor :x, :y, :direction

    def initialize(x, y, direction)
      @x = x
      @y = y
      @direction = direction
    end

    def move
      delta = DIRECTION_TO_DELTA[@direction]
      @x += delta[:dx]
      @y += delta[:dy]
    end

    def rotate_right
      @direction = ROTATE_RIGHT[@direction]
    end

    def rotate_left
      @direction = ROTATE_LEFT[@direction]
    end

  end

  class RoverInstructor

    class RoverLostError < StandardError
    end

    class UnknownInstructionError < StandardError
    end

    def initialize(rover, instructions, x_top, y_top)
      @rover = rover
      @instructions = instructions
      @x_top = x_top
      @y_top = y_top
    end

    def instruct
      check_lost
      @instructions.each { |inst|
        instruct_step(inst)
        check_lost
      }

      @rover
    end

    private def check_lost
      if @rover.x < 0 || @rover.x > @x_top || @rover.y < 0 || @rover.y > @y_top
        raise RoverLostError, 'Rover has left the plateau'
      end
    end

    private def instruct_step(inst)
      case inst
      when 'M' then @rover.move
      when 'L' then @rover.rotate_left
      when 'R' then @rover.rotate_right
      else
        raise UnknownInstructionError, "Instruction '#{inst}' is not known"
      end
    end

  end

  class Application

    def self.calculate_end_positions(input_lines)
      parse_instructors(input_lines).map do |i|
        rover = i.instruct
        "#{rover.x} #{rover.y} #{rover.direction}"
      end
    end

    def self.parse_instructors(input_lines)
      lines = input_lines.select { |line| line !~ /\A\s*\z/ }

      x_top, y_top = lines[0].split(' ').map(&:to_i)

      lines[1..-1].each_slice(2).map { |rover_line, instructions_line|
        RoverInstructor.new(
          parse_rover(rover_line),
          instructions_line.chomp.split(''),
          x_top,
          y_top
        )
      }
    end

    def self.parse_rover(rover_line)
      x, y, direction = rover_line.chomp.split(' ')
      x = x.to_i
      y = y.to_i

      Rover.new(x, y, direction)
    end

  end

end
