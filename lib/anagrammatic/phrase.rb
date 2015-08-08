class Phrase

  E =  { }; %w[b c e f y 2].each { |letter| E[letter] = "b" }
  W =  { }; %w[p ' ! . 0 3].each { |letter| W[letter] = "p" }
  SW = { }; %w[a g h i j 4].each { |letter| SW[letter] = "a" }
  SE = { }; (%w[l m n o 5] << ' ').each { |letter| SE[letter] = "l" }
  C  = { }; %w[d q r v z 1].each { |letter| C[letter] = "d"}
  CC = { }; %w[k s t u w x].each { |letter| CC[letter] = "k" }
  LOOKUP_TABLE = E.merge(W).merge(SW).merge(SE).merge(C).merge(CC)

  attr_reader :phrase, :lookup_table

  def initialize(phrase)
    @phrase = phrase
  end

  def default
    @default ||= phrase.chars.map { |char| LOOKUP_TABLE[char.downcase] }.join
  end

  def interpolate(command_string)
    command_string.gsub!(default, phrase)
  end
end
