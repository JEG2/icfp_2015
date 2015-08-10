require_relative 'anagrammatic/translator'
require_relative 'anagrammatic/phrase'
require_relative 'constants'

module Anagrammatic

  def self.interpolate_powerphrases!(string, power_phrases)
    phrases = power_phrases.map { |phrase| Phrase.new(phrase) }
    phrases.each { |phrase| phrase.interpolate(string) }
    string
  end

end
