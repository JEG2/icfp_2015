require_relative 'anagrammatic/translator'
require_relative 'anagrammatic/phrase'

module Anagrammatic

  PHRASES = [ "ei!" ]
    .map { |phrase| Phrase.new(phrase)  }

  def self.interpolate_powerphrases!(string)
    PHRASES.each { |t| t.interpolate(string) }
    string
  end

end
