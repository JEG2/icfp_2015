module Hexris
  class Honeycomb
    def initialize(width: , height: , filled: )
      @width  = width
      @height = height
      @cells  = Array.new(height) { Array.new(width) { false } }

      fill(filled)
    end

    attr_reader :width, :height, :cells

    def fill(new_cells)
      new_cells.each do |new_cell|
        cells[new_cell["y"]][new_cell["x"]] = true
      end
    end
  end
end
