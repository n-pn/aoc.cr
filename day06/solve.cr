# tests = File.read("day06/test0.txt").lines
input = File.read("day06/input.txt")

puts input.each_char.cons(4).index!(&.uniq.size.== 4) + 4
puts input.each_char.cons(14).index!(&.uniq.size.== 14) + 14
