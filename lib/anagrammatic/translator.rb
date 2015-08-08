module Anagrammatic

  class Translator

    SUBSTITUTIONS = {
      'E'  => %w[b c e f y 2],
      'W'  => %w[p ' ! . 0 3],
      'SW' => %w[a g h i j 4],
      'SE' => %w[l m n o 5] << ' ',
      'C'  => %w[d q r v z 1],
      'CC' => %w[k s t u w x]
    }
    attr_reader :commands
    private     :commands

    def initialize(commands)
      @commands = commands
    end

    def submittable_string
      Anagrammatic.interpolate_powerphrases!(default_translation)
    end

    def default_translation
      commands.map do |command|
        SUBSTITUTIONS[command.upcase].first
      end.join
    end

  end
end
