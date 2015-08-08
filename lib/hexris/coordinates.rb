module Hexris
  module Coordinates
    module_function

    def offset_to_cube(offset_x, offset_y)
      cube_x = offset_x - (offset_y - (offset_y & 1)) / 2
      cube_z = offset_y
      cube_y = -cube_x - cube_z
      [cube_x, cube_y, cube_z]
    end

    def cube_to_offset(cube_x, cube_y, cube_z)
      offset_x = cube_x + (cube_z - (cube_z & 1)) / 2
      offset_y = cube_z
      [offset_x, offset_y]
    end
  end
end
