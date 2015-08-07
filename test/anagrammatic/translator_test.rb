require 'minitest/autorun'
require 'minitest/pride'

require_relative '../../lib/anagrammatic'

module Anagrammatic

  describe 'Translator' do
    it 'converts commands to letters' do
      e = %w[b c e f y 2]
      w = %w[p ' ! . 0 3]
      translator = Translator.new(["E", "W"])
      assert_equal( [ e, w ], translator.sample)
    end

    it 'can generate a submitable series of steps' do
      translator = Translator.new(["E", "W"])
      assert_equal('bp', translator.submittable_string)
    end
  end

end
