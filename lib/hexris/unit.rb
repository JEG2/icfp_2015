module Hexris
  class Unit
    def initialize(members: , pivot: , board: )
      @members  = members
      @pivot    = pivot
      @board    = board
      @x_offset = nil
      @y_offset = nil
      @cells    = nil
      @locked   = false
    end

    attr_reader :members, :pivot, :board, :x_offset, :y_offset
    private     :members, :pivot, :board, :x_offset, :y_offset

    def size
      members.size
    end

    def locked?
      @locked
    end

    def spawn
      @y_offset = 0

      lowest_x, highest_x = members.map { |member| member["x"] }.minmax
      x_size              = highest_x - lowest_x + 1
      @x_offset           = ((board.width - x_size) / 2.0).round
    end

    def cells(x_off: x_offset, y_off: y_offset, mems: members)
      members.map { |member|
        { "x" => member["x"] + x_off + (y_off.odd? && member["y"].odd? ? 1 : 0),
          "y" => member["y"] + y_off }
      }
    end

    def in?(x, y)
      cells.include?({"x" => x, "y" => y})
    end

    def pivot?(x, y)
      [pivot["x"] + x_offset, pivot["y"] + y_offset] == [x, y]
    end

    def valid?(x_off: x_offset, y_off: y_offset, mems: members)
      cells(x_off: x_off, y_off: y_off, mems: mems).all? { |cell|
        !board[cell["x"], cell["y"]]
      }
    end

    def move(direction)
      case direction
      when "E" then try_move(x_offset +  1, y_offset)
      when "W" then try_move(x_offset + -1, y_offset)
      when "SE"
        try_move(x_offset + (y_offset.odd? ? 1 : 0), y_offset + 1)
      when "SW"
        try_move(x_offset + (y_offset.odd? ? 0 : -1), y_offset + 1)
      end
    end

    def rotate(direction)
      case direction
      when "c"  then try_rotate(60)
      when "cc" then try_rotate(-60)
      end
    end

    private

    def try_move(new_x_offset, new_y_offset)
      if new_x_offset.between?(0, board.width  - 1) &&
         new_y_offset.between?(0, board.height - 1) &&
         valid?(x_off: new_x_offset, y_off: new_y_offset)
        @x_offset = new_x_offset
        @y_offset = new_y_offset
      else
        @locked = true
      end
    end

    def try_rotate(angle)
      new_members = members.map { |member|
        origin_x = member["x"] + -pivot["x"]
        origin_y = member["y"] + -pivot["y"]

        x = origin_x - (origin_y - (origin_y & 1)) / 2
        z = origin_y
        y = -x - z

        x, y, z = angle == 60 ? [-z, -x, -y] : [-y, -z, -x]

        {"x" => x + (z - (z & 1)) / 2, "y" => z}
      }

      if valid?(mems: new_members)
        @members = new_members
      else
        @locked = true
      end
    end
  end
end
