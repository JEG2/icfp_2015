class LovecraftParser
  def initialize(file)
    @lines = File.new(file).readlines("<p>")
    sentences = @lines.each_with_object([]) do |line,accum|
      temp = line.split(/[.?:]/)
      temp.each {|s| accum << s.gsub("<p>","")
                               .gsub("</p>","")
                               .gsub("</i>","")
                               .gsub("<i>","")
                               .gsub(/<blockquote[^>]*>/,"")
                               .gsub("</blockquote>","")
                               .gsub(/(\t|\n|\r)/,"")
                               .gsub(/<p[^>]*>/,"")
                               .gsub('”',"")
                              }
    end
    sentences.map! {|x| x.strip}
    p sentences.size
    exclude_east_west(sentences).each {|s| puts "'" + s + "'"}
    p exclude_east_west(sentences).size
  end

  def exclude_east_west(sentences)
    sentences.reject { |line| !!line[/[p'!.03][bcefy2]/] }
       .reject { |line| !!line[/[bcefy2][p'!.03]/] }
       .reject { |line| !!line[/[drvzl][kstuwx]/] }
       .reject { |line| !!line[/[kstuwx][drvzl]/] }
       .reject { |line| line.size > 75 || line.size < 3}
       .reject { |line| line =~ /^\S+$/}
       .reject { |line| line =~ /\/html/}
       .reject { |line| line =~ /Return to Table of Contents/}
       .reject { |line| line =~ /a href=/}
       .reject { |line| line =~ /font-/}
       .reject { |line| line =~ /xml version/}
       .reject { |line| line =~ /DOCTYPE/}
       .reject { |line| line =~ /encoding=/}
       .reject { |line| line =~ /http:/}
       .reject { |line| line =~ /text-/}
       .reject { |line| line =~ /[16789]/}
  end
end
