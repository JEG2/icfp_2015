module Hexris
  class AI
    MOVES = %w[E W SW SE c cc]

    def initialize(game)
      @game          = game
      @default_score = game.board.width * game.board.height
      @heat_map      = Hash.new(default_score)
    end

    attr_reader :game, :default_score, :heat_map
    private     :game, :default_score, :heat_map

    def find_moves
      if board_empty?
        lock_a_unit
      else
        build_heat_map
        clear_lines
      end
    end

    private

    def build_heat_map
      heat_map.clear

      game.board.height.times do |y|
        game.board.width.times do |x|
          xyz = Coordinates.offset_to_cube(x, y)

          next if game.board[xyz]

          score = score_cell(x, y)
          radiate(x, y, score)
        end
      end

      # show_heat_map
    end

    def score_cell(x, y)
      default_score - game.board.row(y).count(&:itself) * game.board.height
    end

    def radiate(x, y, score)
      q = [{x: x, y: y, score: score}]
      while (mark = q.pop)
        xyz = Coordinates.offset_to_cube(mark[:x], mark[:y])
        if heat_map[xyz] > mark[:score]
          heat_map[xyz] = mark[:score]
          neighbors(mark[:x], mark[:y]).each do |x, y|
            q << {x: x, y: y, score: mark[:score] + 1}
          end
        end
      end
    end

    def neighbors(x, y)
      offsets = y.odd? ? [[1, -1], [1, 0], [1, 1], [0, 1], [-1, 0], [0, -1]]
                       : [[0, -1], [1, 0], [0, 1], [-1, 1], [-1, 0], [-1, -1]]
      open    = [ ]
      offsets.each do |x_offset, y_offset|
        cell_x = x + x_offset
        cell_y = y + y_offset

        next unless cell_x.between?(0, game.board.width  - 1)
        next unless cell_y.between?(0, game.board.height - 1)
        next if     game.board[Coordinates.offset_to_cube(cell_x, cell_y)]

        open << [cell_x, cell_y]
      end
      open
    end

    def board_empty?
      game.board.rows.flatten.none?
    end

    def lock_a_unit
      unit  = game.unit.dup
      moves = [ ]
      loop do
        unit.move_or_rotate("SW")
        moves << "SW"
        if unit.locked?
          return moves
        end
      end
    end

    def clear_lines
      unit  = game.unit.dup
      moves = [ ]
      loop do
        best_score = unit.size * default_score
        scored     = { }
        MOVES.each do |move|
          begin
            new_unit = unit.dup
            new_unit.move_or_rotate(move)
            scored[move] = score_move(new_unit)
            if scored[move] < best_score
              best_score = scored[move]
            end
          rescue
            scored[move] = 0
          end
        end
        move, _ = scored.find { |_, score| score == best_score }
        unit.move_or_rotate(move)
        moves << move
        if unit.locked?
          return moves
        end
      end
    end

    def score_move(unit)
      unit.members.inject(0) { |sum, member| sum + heat_map[member] }
    end

    def show_heat_map
      puts Array.new(game.board.height) { |y|
        (y.odd? ? " " : "") + Array.new(game.board.width) { |x|
          xyz = Coordinates.offset_to_cube(x, y)
          heat_map[xyz].to_s(36)
        }.join(" ")
      }.join("\n")
      $stdin.gets
    end
  end
end
