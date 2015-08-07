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
      board.cells.map.with_index { |row, y|
        (y.odd? ? " " : "") + row.map.with_index { |cell, x|
          symbol =
            if unit && unit.in?(x, y)
              CELL_STRINGS[:unit]
            else
              CELL_STRINGS[cell]
            end
          if unit && unit.pivot?(x, y)
            "#{PIVOT_START}#{symbol}#{PIVOT_STOP}"
          else
            symbol
          end
        }.join(" ")
      }.join("\n")
    end
  end
end
