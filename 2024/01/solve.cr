input = File.read("#{__DIR__}/input.txt").strip.lines

lhs = input.map(&.split.first.to_i).sort!
rhs = input.map(&.split.last.to_i).sort!

puts lhs.zip(rhs).sum { |a, b| (a - b).abs }
puts lhs.sum { |a| a * rhs.count(a) }
