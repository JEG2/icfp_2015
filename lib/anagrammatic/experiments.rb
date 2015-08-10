require 'minitest/autorun'
require 'minitest/pride'

require_relative 'anagrammatic'

module Anagrammatic

  class Mutator
    attr_reader :possibilities
    private     :possibilities

    def initialize(possibilities)
      @possibilities = possibilities
    end

    def combinations
      possibilities.first.product(*possibilities[1..-1]).map(&:join)
    end

  end

  describe 'Mutator' do
    it 'builds all possibilities' do
      mutator = Mutator.new( [ %w[b c e ], %w[p ' !] ])
      assert_equal mutator.combinations.count, 9
    end
  end

  # describe 'flow' do
  #   input = %w[E W SW C]
  #   possible = Mutator.new(Translator.new(input).sample)
  #   puts possible.combinations.uniq.count
  # end

  class Command
    attr_reader :possible_values

    def initialize(possible_values)
      @possible_values = possible_values
    end

    def matches?(letter)
      possible_values.include?(letter)
    end

    def ==(command)
      command.is_a?(Command) &&
        command.possible_values == possible_values
    end
  end

  class PowerWord
    attr_reader :commands
    private     :commands

    def initialize(commands)
      @commands = commands
    end

    def permutations
      all_possible.first.product(*all_possible[1..-1]).map(&:join)
    end

    def tokens
      @tokens ||= commands.to_enum
    end

    private

    def all_possible
      @all_possible ||= commands.map(&:possible_values)
    end

  end

  class Seeker
    attr_reader :commands
    private :commands

    def initialize(commands)
      @idx = 0
      @commands = commands
    end

    def has?(power_word)
      first_letter = power_word.tokens.next
      @idx = commands.index { |letter| first_letter.matches?(letter) }
      !!searcher(power_word.tokens)
    end

    def count(power_word)

    end

    private

    def searcher(tokens)
      next_letter = tokens.next
      @idx += 1
      return unless next_letter.matches?(commands[@idx])
      searcher(tokens)
      rescue StopIteration
        return @idx
    end

    def start_again(tokens)

    end
  end

  describe 'Seeker' do

    possible_commands = [
      Command.new(%w[E b c e f y 2]),
      Command.new(%w[W p ' ! . 0 3]),
      Command.new(%w[SW a g h i j 4]),
      Command.new(%w[SE l m n o 5] << ' '),
      Command.new(%w[C d q r v z 1]),
      Command.new(%w[CC k s t u w x])
    ]

    input = %w[CC E SW W C E SW W]
    seeker = Seeker.new(input)

    it 'knows if a command string has a word' do
      parsed = "ei!".split(//).map { |letter| possible_commands.find { |command| command.matches?(letter) } }
      power_word = PowerWord.new(parsed)
      assert_equal true, seeker.has?(power_word)
    end

    it 'knows if a command string does not have a word' do
      parsed = "fff".split(//).map { |letter| possible_commands.find { |command| command.matches?(letter) } }
      bad_word = PowerWord.new(parsed)
      assert_equal false, seeker.has?(bad_word)
    end

    # it 'can count how many times a word is found' do
    #   parsed = "ei!".split(//).map { |letter| possible_commands.find { |command| command.matches?(letter) } }
    #   power_word = PowerWord.new(parsed)
    #   seeker = Seeker.new(input)

    #   assert_equal 2, seeker.count(power_word)
    # end

  end

end
