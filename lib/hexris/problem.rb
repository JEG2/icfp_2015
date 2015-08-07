require "json"

module Hexris
  class Problem
    def initialize(json)
      @details = JSON.parse(json)
    end

    attr_reader :details
    private     :details

    def board
      { width:  details["width"],
        height: details["height"],
        filled: details["filled"] }
    end
  end
end
