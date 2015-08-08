require_relative "honeycomb"
require_relative "unit"
require_relative "rng"
require_relative "scorer"

module Hexris
  class Game
    def initialize(problem: , seed: )
      @problem     = problem
      @seed        = seed
      @rng         = RNG.new(seed)
      @game_over   = false
      @pieces_left = problem.source_limit
      @score       = Scorer.new
      @board       = Honeycomb.new(problem.board)
      @unit        = nil
      @moves       = [ ]

      spawn_unit
    end

    attr_reader :seed, :pieces_left, :score, :board, :unit, :moves

    attr_reader :problem, :rng
    private     :problem, :rng

    def game_over?
      @game_over
    end

    def spawn_unit
      if (@pieces_left -= 1) > 0
        @unit = Unit.new(
          problem.units[rng.succ % problem.units.size].merge(board: board)
        )
        unless unit.valid?
          @unit      = nil
          @game_over = true
        end
      else
        @game_over = true
      end
    end

    def make_move(move)
      case move
      when /\AS?[EW]\z/ then unit.move(move)
      else                   unit.rotate(move)
      end
      moves << move

      if unit.locked?
        board.fill(unit.members)
        cleared = board.clear_rows
        score.score_move(unit.size, cleared)
        spawn_unit
      end
    end

    def quit
      @game_over = true
    end
  end
end
