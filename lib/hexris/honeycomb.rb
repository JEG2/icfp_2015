module Hexris
  class Honeycomb
    def initialize(width: , height: , filled: )
      @width  = width
      @height = height
      @cells  = Array.new(height) { Array.new(width) { false } }

      fill(filled)
    end

    attr_reader :width, :height, :cells

    def [](x, y)
      cells[y][x]
    end

    def fill(new_cells)
      new_cells.each do |new_cell|
        cells[new_cell["y"]][new_cell["x"]] = true
      end
    end

    def clear_rows
      cells.delete_if { |row| row.all? }
      @cells =
        Array.new(height - cells.size) { Array.new(width) { false } } + cells
    end
  end
end
