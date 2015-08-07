require 'minitest/autorun'

require_relative '../lib/random'

describe Random do
  it "knows the incrementer" do
    random = Random.new(17)
    nums = [0,24107,16552,12125,9427,13152,21440,3383,6873,16117]
    nums.each {|x| random.succ.must_equal(x) }
  end
end
