require 'minitest/autorun'

require_relative '../lib/dumb_bot/dumb_bot'

describe DumbBot::DumbBot do
  it "converts a power word" do
    d = DumbBot::DumbBot.new("hi")
    p d.pw_to_moves("hi").must_equal("SW SW")
  end
end
