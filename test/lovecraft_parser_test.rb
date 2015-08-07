require 'minitest/autorun'

require_relative '../lib/lovecraft_parser'

describe "LoveCraftParser" do
  it "gets all sentences" do
    LovecraftParser.new('./data/call_of_chthulhu.xtml')
  end
end
