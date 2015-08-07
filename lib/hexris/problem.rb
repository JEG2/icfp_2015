require "json"

module Hexris
  class Problem
    def initialize(json)
      @details = JSON.parse(json)
    end

    attr_reader :details
    private     :details

    def id
      details["id"]
    end

    def board
      { width:  details["width"],
        height: details["height"],
        filled: details["filled"] }
    end

    def units
      @units ||= details["units"].map { |unit|
        {members: unit["members"], pivot: unit["pivot"]}
      }
    end

    def seeds
      details["sourceSeeds"]
    end

    def source_limit
      details["sourceLength"]
    end
  end
end
