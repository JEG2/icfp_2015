require "json"

require_relative "problem"
require_relative "game"
require_relative "ai"
require_relative "visualizer"
require_relative "../anagrammatic"

module Hexris
  class Solver
    CLEAR  = "\e[2J\e[H"

    def initialize(json, debug = false)
      @problem   = Problem.new(json)
      @game      = nil
      @ai        = nil
      @solutions = [ ]
      @debug     = debug
    end

    attr_reader :problem, :game, :ai, :solutions, :debug
    private     :problem, :game, :ai, :solutions, :debug

    def solve
      problem.seeds.each do |seed|
        setup_game(seed)
        until game_over?
          find_moves
        end
        record_solution
      end
      show_solutions
    end

    private

    def setup_game(seed)
      @game = Game.new(problem: problem, seed: seed)
      @ai   = AI.new(game)
    end

    def game_over?
      game.game_over?
    end

    def find_moves
      ai.find_moves.each do |move|
        game.make_move(move)
        show_board if debug
      end
    end

    def show_board
      print CLEAR
      puts  Visualizer.new(board: game.board, unit: game.unit)
      puts  "Pieces left:  #{game.pieces_left}.  Score:  #{game.score.total}."
      sleep 0.1
    end

    def record_solution
      solutions << {
        "problemId" => problem.id,
        "seed"      => game.seed,
        "tag"       => "solver:#{problem.id}:#{game.seed}:#{game.score.total}",
        "solution"  => Anagrammatic::Translator.new(
          game.moves
        ).submittable_string
      }
    end

    def show_solutions
      puts JSON.generate(solutions)
    end
  end
end
