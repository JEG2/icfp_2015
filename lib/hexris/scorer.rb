module Hexris
  class Scorer
    def initialize(power_words: nil)
      @power_words  = power_words
      @last_cleared = 0
      @total        = 0
    end

    attr_accessor :power_words, :total

    def score_move(size, lines_cleared)
      score         =  points(size,lines_cleared)
      final_score   =  score + line_bonus(score)
      @last_cleared =  lines_cleared
      @total        += final_score
      final_score
    end

    def points(size,lines_cleared)
      size + 100 * (1 + lines_cleared) * lines_cleared / 2
    end

    def line_bonus(points)
      if @last_cleared > 1
        ((@last_cleared - 1) * points / 10).floor
      else
        0
      end
    end

    def score_phrase(move_string)
      phrase_count = count_phrases(move_string)
      score = 0
      phrase_count.each do |key,value|
        score = score + 2 * key.length * value + 300
      end
      @total += score
      score
    end

    def count_phrases(move_string)
      @power_words.each_with_object({}) do |power_word,word_counter|
        if !!move_string[/#{power_word}/]
          word_counter[power_word] = move_string.scan(/#{power_word}/).size
        end
      end
    end
  end
end
