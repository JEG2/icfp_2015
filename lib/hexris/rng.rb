module Hexris
  class RNG

    INCREMENT  = 12345
    MULTIPLIER = 1_103_515_245
    MODULUS    = 2 ** 32

    def initialize(seed)
      @init          = true
      @seed          = seed
      @current_value = seed
    end

    def succ
      if @init == true
        @init = false
        mask_bits(@seed)
      else
        @current_value = (MULTIPLIER * @current_value + INCREMENT) % MODULUS
        mask_bits(@current_value)
      end
    end

    def mask_bits(value)
      (value >> 16) & 0b111111111111111
    end

  end
end
