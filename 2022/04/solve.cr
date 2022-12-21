# input = File.read("2022/04/test0.txt").strip
input = File.read("2022/04/input.txt").strip
input = input.lines.map(&.split(/\D+/).map(&.to_i))

puts input.count { |(a, b, c, d)| a == c || (a > c ? b <= d : d <= b) }
puts input.count { |(a, b, c, d)| a > c ? a <= d : c <= b }
