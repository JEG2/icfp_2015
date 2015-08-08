require_relative "coordinates"

module Hexris
  class Visualizer
    PIVOT_START  = "\e[31m"
    PIVOT_STOP   = "\e[0m"
    CELL_STRINGS = {true => "#", false => ".", :unit => "*"}

    def initialize(board: , unit: nil)
      @board = board
      @unit  = unit
    end

    attr_reader :board, :unit
    private     :board, :unit

    def to_s
      board.rows.map.with_index { |row, y|
        (y.odd? ? " " : "") + row.map.with_index { |cell, x|
          xyz    = Coordinates.offset_to_cube(x, y)
          symbol =
            if unit && unit.in?(xyz)
              CELL_STRINGS[:unit]
            else
            CELL_STRINGS[cell]
            end
          if unit && unit.pivot?(xyz)
            "#{PIVOT_START}#{symbol}#{PIVOT_STOP}"
          else
            symbol
          end
        }.join(" ")
      }.join("\n")
    end
  end
end
