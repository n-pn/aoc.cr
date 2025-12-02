require "colorize"

input = File.read("#{__DIR__}/input.txt").strip

def calc(input : String, regex : Regex)
  input.scan(/(\d+)-(\d+)/).sum do |x|
    (x[1].to_i64..x[2].to_i64).select(&.to_s.matches?(regex)).sum
  end
end

puts calc(input, /^(\d+)\1$/)
puts calc(input, /^(\d+)\1+$/)
