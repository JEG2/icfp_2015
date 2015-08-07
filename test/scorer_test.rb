require 'minitest/autorun'

require_relative '../lib/constants'
require_relative '../lib/scorer'

describe Scorer do
  it "takes a list of power words" do
    power_words = POWER_WORDS

    s = Scorer.new
    s.power_words.must_equal(nil)
    s = Scorer.new(power_words: POWER_WORDS)
    s.power_words.must_equal(POWER_WORDS)
  end

  it "finds a phrase of power" do
    s = Scorer.new(power_words: ["test"])
    s.count_phrases("test").must_equal({"test" => 1})
    s.count_phrases("nope!").must_equal({})
  end

  it "scores a phrase of power" do
    s = Scorer.new(power_words: ["test"])
    s.power_score("test").must_equal(308)
    s.power_score("test test").must_equal(316)
  end

  it "scores two phrases of power" do
    s = Scorer.new(power_words: ["test","me"])
    s.power_score("test").must_equal(308)
    s.power_score("test me").must_equal(612)
    s.power_score("test me more").must_equal(612)
  end

  it "scores move_score" do
    s = Scorer.new()
    s.move_score(1,1).must_equal(101)
    s.move_score(1,1).must_equal(101)
    s.move_score(1,2).must_equal(301)
    s.move_score(1,2).must_equal(331)
  end
end
