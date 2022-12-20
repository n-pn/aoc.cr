# input = File.read("day03/test0.txt")
input = File.read("day03/input.txt")

input = input.lines.map { |l| l.chars.map { |c| c <= 'Z' ? c - 'A' + 27 : c - 'a' + 1 } }

puts input.sum { |x| x.each_slice(x.size // 2).reduce { |a, b| a & b }.first }
puts input.each_slice(3).sum(&.reduce { |a, b| a & b }.first)
