module Hexris
  class AI
    MOVES = %w[E W SW SE c cc]

    def initialize(game)
      @game     = game
      @heat_map = { }

      build_heat_map
    end

    attr_reader :game, :heat_map
    private     :game, :heat_map

    def find_moves
      unit  = game.unit.dup
      moves = [ ]
      loop do
        best_score = 0
        scored     = { }
        MOVES.each do |move|
          begin
            new_unit = unit.dup
            new_unit.move_or_rotate(move)
            scored[move] = score_move(new_unit)
            if scored[move] > best_score
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

    private

    def build_heat_map
      middle_x = (game.board.width - 1) / 2
      game.board.height.times do |y|
        game.board.width.times do |x|
          xyz           = Coordinates.offset_to_cube(x, y)
          heat_map[xyz] = (middle_x - x).abs + y * 2
        end
      end
    end

    def score_move(unit)
      unit.members.inject(0) { |sum, member| sum + heat_map[member] }
    end
  end
end
