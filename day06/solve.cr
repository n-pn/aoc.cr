# tests = File.read("day06/test0.txt").strip.lines
input = File.read("day06/input.txt").strip

puts input.chars.each_cons(4).with_index { |a, i| break i + 4 if a.uniq.size == 4 }
puts input.chars.each_cons(14).with_index { |a, i| break i + 14 if a.uniq.size == 14 }
