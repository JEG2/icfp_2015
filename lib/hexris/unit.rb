module Hexris
  class Unit
    def initialize(initial_members: , initial_pivot: , board: )
      y_offset            = 0
      lowest_x, highest_x = initial_members.map { |member| member["x"] }.minmax
      x_size              = highest_x - lowest_x + 1
      x_offset            = (board.width - x_size) / 2

      @members = initial_members.map { |member|
        Coordinates.offset_to_cube(
          member["x"] + x_offset,
          member["y"] + y_offset
        )
      }
      @pivot   = Coordinates.offset_to_cube(
        initial_pivot["x"] + x_offset,
        initial_pivot["y"] + y_offset
      )
      @board   = board
      @locked  = false
      @memory  = [[members.sort + [pivot]]]
    end

    attr_reader :members

    attr_reader :pivot, :board, :memory
    private     :pivot, :board, :memory

    def size
      members.size
    end

    def locked?
      @locked
    end

    def in?(xyx)
      members.include?(xyx)
    end

    def pivot?(xyz)
      pivot == xyz
    end

    def valid?(check: members)
      check.all? { |member|
        x, y = Coordinates.cube_to_offset(*member)
        x.between?(0, board.width  - 1) &&
        y.between?(0, board.height - 1) &&
        !board[member]
      }
    end

    def move(direction)
      case direction
      when "E"  then try_move(1, -1, 0)
      when "W"  then try_move(-1, 1, 0)
      when "SE" then try_move(0, -1, 1, clear_memory: true)
      when "SW" then try_move(-1, 0, 1, clear_memory: true)
      end
    end

    def rotate(direction)
      case direction
      when "c"  then try_rotate(60)
      when "cc" then try_rotate(-60)
      end
    end

    private

    def try_move(x_offset, y_offset, z_offset, clear_memory: false)
      new_members  = members.map { |x, y, z|
        [x + x_offset, y + y_offset, z + z_offset]
      }
      new_pivot    =
        [pivot[0] + x_offset, pivot[1] + y_offset, pivot[2] + z_offset]
      new_position = [new_members.sort + [new_pivot]]
      fail "Duplicate move" if memory.include?(new_position)
      if valid?(check: new_members)
        @members = new_members
        @pivot   = new_pivot
        if clear_memory
          @memory.clear
        end
        @memory << new_position
      else
        @locked = true
      end
    end

    def try_rotate(angle)
      new_members = members.map { |member|
        origin_x = member[0] - pivot[0]
        origin_y = member[1] - pivot[1]
        origin_z = member[2] - pivot[2]

        to = angle == 60 ? [-origin_z, -origin_x, -origin_y]
                         : [-origin_y, -origin_z, -origin_x]

        [to[0] + pivot[0], to[1] + pivot[1], to[2] + pivot[2]]
      }
      new_position = [new_members.sort + [pivot]]
      fail "Duplicate move" if memory.include?(new_position)
      if valid?(check: new_members)
        @members = new_members
        @memory << new_position
      else
        @locked = true
      end
    end
  end
end
