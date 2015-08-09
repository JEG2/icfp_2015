require_relative '../constants'
require_relative "../hexris/problem"
require_relative "../hexris/game"
require_relative "../anagrammatic"

module DumbBot
  class DumbBot

    def initialize(json: )
      @local_power_words = POWER_WORDS + ["a"]
      @problem   = Hexris::Problem.new(json)
      @game      = nil
      @solutions = [ ]
      @power_word_value = Hash.new(300)
    end

    attr_reader :problem, :game, :solutions

    def play
      problem.seeds.each do |seed|
        @power_word_value = Hash.new(300)
        setup_game(seed)
        until game_over?
          explore_map
        end
        record_solution
      end
      show_solutions
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

    def setup_game(seed)
      @game = Hexris::Game.new(problem: problem, seed: seed)
    end

    def game_over?
      game.game_over?
    end

    def explore_map
      until(game.game_over?)
        word = try_words
        p "going with"
        p word
        if word == 'a'
          @power_word_value['a'] = 0
        else
          @power_word_value[word] = @power_word_value[word] - word.length
        end
        pw_to_moves(word).each do |move| 
          break if game.game_over?
          game.make_move(move) 
        end

      end
    end

    def try_words
      @local_power_words.rotate!
      @local_power_words.max do |power_word|
        p power_word
        temp_game = Marshal.load(Marshal.dump(@game))
        moves = pw_to_moves(power_word)
        if moves.all? do |move| 
          begin
            break false if temp_game.game_over?
            temp_game.make_move(move)
            true
          rescue
            break false
          end
        end 
        p "power_word:"
        p power_word
        p "pwv:"
        p @power_word_value[power_word]
        p @power_word_value[power_word] + power_word.length
        else
          p 0
        end
      end
    end

    def pw_to_moves(word)
      moves  = {"p" => "W", "'" => "W",
        "!" => "W", "." => "W", "0" => "W", 
        "3" => "W", "b" => "E", "c" => "E", 
        "e" => "E", "f" => "E", "y" => "E", 
        "2" => "E", "a" => "SW", "g" => "SW", 
        "h" => "SW", "i" => "SW", "j" => "SW", 
        "4" => "SW", "l" => "SE", "m" => "SE", 
        "n" => "SE", "o" => "SE", " " => "SE", 
        5 => "SE", "d" => "c", "q" => "c", 
        "r" => "c", "v" => "c", "z" => "c", 
        "1" => "c", "k" => "cc", "s" => "cc", 
        "t" => "cc", "u" => "cc", "w" => "cc",
        "x" => "cc"}
      word.downcase.chars.map { |unit| moves[unit] }
    end
  end
end
