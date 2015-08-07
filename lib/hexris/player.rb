require "json"

require_relative "problem"
require_relative "honeycomb"
require_relative "unit"
require_relative "rng"
require_relative "scorer"
require_relative "visualizer"
require_relative "../anagrammatic"

module Hexris
  class Player
    CLEAR  = "\e[2J"
    MOVES  = %w[E W SE SW c cc]
    PROMPT = [MOVES[0..-2].join(", "), MOVES[-1]].join(" or ") + "?  "

    def initialize(json)
      @problem     = Problem.new(json)
      @seed        = nil
      @rng         = nil
      @game_over   = nil
      @pieces_left = nil
      @score       = nil
      @board       = nil
      @unit        = nil
      @moves       = nil
      @solutions   = [ ]
    end

    attr_reader :problem, :seed, :rng, :pieces_left, :score, :board, :unit,
                :moves, :solutions
    private     :problem, :seed, :rng, :pieces_left, :score, :board, :unit,
                :moves, :solutions

    def play
      problem.seeds.each do |seed|
        setup_game(seed)
        until game_over?
          show_board
          handle_move
        end
        show_board
        show_score
        record_solution
      end
      show_solutions
    end

    private

    def setup_game(seed)
      puts "Seed:  #{seed}"
      wait_for_enter

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

    def spawn_unit
      if (@pieces_left -= 1) > 0
        @unit = Unit.new(
          problem.units[rng.succ % problem.units.size].merge(board: board)
        ).tap(&:spawn)
        unless unit.valid?
          @unit      = nil
          @game_over = true
        end
      else
        @game_over = true
      end
    end

    def game_over?
      @game_over
    end

    def show_board
      print CLEAR
      puts  Visualizer.new(board: board, unit: unit)
    end

    def show_score
      puts "Score:  #{score.total}"
      wait_for_enter
    end

    def handle_move
      read_move
      make_move
    end

    def read_move
      loop do
        print "Pieces left:  #{pieces_left}.  Score:  #{score.total}.  #{PROMPT}"

        move = $stdin.gets.strip

        exit if move == "q"
        move = MOVES.find { |m| m.downcase == move.downcase }
        if MOVES.include?(move)
          moves << move
          break
        end
      end
    end

    def make_move
      case moves.last
      when /\AS?[EW]\z/ then unit.move(moves.last)
      else                   unit.rotate(moves.last)
      end

      if unit.locked?
        board.fill(unit.cells)
        cleared = board.clear_rows
        score.score_move(unit.size, cleared)
        spawn_unit
      end
    end

    def wait_for_enter
      puts "Press enter to continue..."
      $stdin.gets
    end

    def record_solution
      solutions << {
        "problemId" => problem.id,
        "seed"      => seed,
        "tag"       => "manual:#{problem.id}:#{seed}:#{score.total}",
        "solution"  => Anagrammatic::Translator.new(moves).submittable_string
      }
    end

    def show_solutions
      json = JSON.generate(solutions)

      puts
      puts "Solutions:"
      puts
      puts json

      File.write(
        File.join(__dir__, *%W[.. .. solutions #{problem.id}.json]),
        json
      )
    end
  end
end
