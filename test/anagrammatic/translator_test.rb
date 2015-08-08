require 'minitest/autorun'
require 'minitest/pride'

require_relative '../../lib/anagrammatic'

module Anagrammatic

  describe 'Translator' do

    it 'can generate a submitable series of steps' do
      translator = Translator.new(["E", "W"])
      assert_equal('bp', translator.submittable_string)
    end

    it 'can substitute power phrases' do
      translator = Translator.new(["E", "SW", "W", "C"])
      assert_equal( 'ei!d', translator.submittable_string )
    end

  end

end
