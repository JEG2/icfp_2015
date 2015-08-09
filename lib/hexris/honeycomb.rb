require_relative "coordinates"

module Hexris
  class Honeycomb
    def initialize(width: , height: , filled: )
      @width  = width
      @height = height
      @cells  = { }

      height.times do |y|
        width.times do |x|
          xyz        = Coordinates.offset_to_cube(x, y)
          cells[xyz] = false
        end
      end

      fill(
        filled.map { |cell| Coordinates.offset_to_cube(cell["x"], cell["y"]) }
      )
    end

    attr_reader :width, :height

    attr_reader :cells
    private     :cells

    def on?(xyz)
      cells.include?(xyz)
    end

    def [](xyz)
      cells[xyz]
    end

    def row(y)
      (0...width).map { |x| self[Coordinates.offset_to_cube(x, y)] }
    end

    def rows
      (0...height).map { |y| row(y) }
    end

    def fill(new_cells)
      new_cells.each do |new_cell|
        cells[new_cell] = true
      end
    end

    def clear_rows
      cleared = 0
      (0..height).each do |y|
        if row(y).all?
          (y - 1).downto(0) do |higher_y|
            (0...width).each do |x|
              cells[Coordinates.offset_to_cube(x, higher_y + 1)] =
                self[Coordinates.offset_to_cube(x, higher_y)]
            end
          end
          (0...width).each do |x|
            cells[Coordinates.offset_to_cube(x, 0)] = false
          end
          cleared += 1
        end
      end
      cleared
    end
  end
end
