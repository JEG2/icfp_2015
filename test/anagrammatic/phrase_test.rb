require 'minitest/autorun'
require 'minitest/pride'

require_relative '../../lib/anagrammatic/phrase'

module Anagrammatic

  describe 'Phrase' do

    it 'translates a power word to a default string' do
      phrase = Phrase.new('ei!')
      assert_equal 'bap', phrase.default
    end

    it 'can interpolate power words if they exist' do
      phrase = Phrase.new('ei!')
      assert_equal 'ppamei!plei!', phrase.interpolate('ppambapplbap')
    end

  end

end
