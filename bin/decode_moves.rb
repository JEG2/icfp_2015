
phrase = ARGV[0].downcase.chars

moves  = {"p" => "W", "'" => "W", "!" => "W", "." => "W", "0" => "W", "3" => "W", "b" => "E", "c" => "E", "e" => "E", "f" => "E", "y" => "E", "2" => "E", "a" => "SW", "g" => "SW", "h" => "SW", "i" => "SW", "j" => "SW", "4" => "SW", "l" => "SE", "m" => "SE", "n" => "SE", "o" => "SE", " " => "SE", 5 => "SE", "d" => "c", "q" => "c", "r" => "c", "v" => "c", "z" => "c", "1" => "c", "k" => "cc", "s" => "cc", "t" => "cc", "u" => "cc", "w" => "cc", "x" => "cc"}

keypresses = {'W' => 'q',
              'E' => 'e',
              'SW'=> 'a',
              'SE' => 'd',
              'c' => 'j',
              'cc' => 'k'}

p phrase.map { |unit| moves[unit] }.map {|move| keypresses[move]}
