require "json"
require "io/console"

require_relative "problem"
require_relative "game"
require_relative "visualizer"
require_relative "../anagrammatic"

module Hexris
  class Player
    CLEAR  = "\e[2J"
    MOVES  = %w[E W SE SW c cc]
    KEYS   = {
      "e" => "E",
      "q" => "W",
      "d" => "SE",
      "a" => "SW",
      "j" => "c",
      "k" => "cc"
    }
    PROMPT = KEYS.map { |k, m| "#{k}(#{m})" }.join(", ") + ", u, s, or x?  "

    def initialize(json: , opening: nil)
      @problem   = Problem.new(json)
      @opening   = opening
      @game      = nil
      @solutions = [ ]
    end

    attr_reader :problem, :opening, :game, :solutions
    private     :problem, :opening, :game, :solutions

    def play
      problem.seeds.each do |seed|
        setup_game(seed)
        play_opening
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
      @game = Game.new(problem: problem, seed: seed)
    end

    def play_opening
      return unless opening

      opening.split(" ").each do |move|
        make_move(move)
      end
    end

    def game_over?
      game.game_over?
    end

    def show_board
      print CLEAR
      puts  Visualizer.new(board: game.board, unit: game.unit)
    end

    def show_score
      puts "Score:  #{game.score.total}"
      wait_for_enter
    end

    def handle_move
      move = read_move
      make_move(move) if move
    end

    def read_move
      loop do
        print "Pieces left:  #{game.pieces_left}.  " +
              "Score:  #{game.score.total}.  #{PROMPT}"

        move = $stdin.getch
        puts

        case move
        when "u"
          undo
          return nil
        when "s"
          show_moves
          return nil
        when "x", "\u0003"
          game.quit
          return nil
        end

        move = KEYS[move]
        if MOVES.include?(move)
          return move
        end
      end
    end

    def make_move(move)
      game.make_move(move)
    rescue
      puts "Illegal move blocked."
      wait_for_enter
    end

    def undo
      old_moves = game.moves[0..-2]
      setup_game(game.seed)
      old_moves.each do |move|
        make_move(move)
      end
    end

    def show_moves
      puts game.moves.join(" ")
      wait_for_enter
    end

    def wait_for_enter
      puts "Press enter to continue..."
      $stdin.gets
    end

    def record_solution
      solutions << {
        "problemId" => problem.id,
        "seed"      => game.seed,
        "tag"       => "manual:#{problem.id}:#{game.seed}:#{game.score.total}",
        "solution"  => Anagrammatic::Translator.new(
          game.moves
        ).submittable_string
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
