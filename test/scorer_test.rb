require 'minitest/autorun'

require '../lib/constants'
require '../lib/scorer'

describe Scorer do
  it "takes a list of power words" do
    power_words = POWER_WORDS

    s = Scorer.new
    s.power_words.must_equal(nil)
  end
end
