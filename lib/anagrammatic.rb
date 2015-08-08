require_relative 'anagrammatic/translator'
require_relative 'anagrammatic/phrase'
require_relative 'constants'

module Anagrammatic

  PHRASES = POWER_WORDS
    .map { |phrase| Phrase.new(phrase) }

  def self.interpolate_powerphrases!(string)
    PHRASES.each { |phrase| phrase.interpolate(string) }
    string
  end

end
