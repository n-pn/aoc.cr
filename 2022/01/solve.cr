input = File.read("2022/01/input.txt").strip
total = input.split("\n\n").map { |x| x.lines.sum(&.to_i) }.sort!
puts total.last, total.last(3).sum
