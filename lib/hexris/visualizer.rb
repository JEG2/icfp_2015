module Hexris
  class Visualizer
    CELL_STRINGS = {true => "*", false => "."}

    def initialize(board)
      @board = board
    end

    attr_reader :board
    private     :board

    def to_s
      board.cells.map.with_index { |row, i|
        (i.odd? ? " " : "") + row.map { |cell| CELL_STRINGS[cell] }.join(" ")
      }.join("\n")
    end
  end
end
