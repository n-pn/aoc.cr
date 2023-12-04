text = File.read_lines("#{__DIR__}/bigboy.txt")
data = text.map(&.split(/[:|]/).try { |x| x[1].split & x[2].split }.size)
puts data.sum { |x| 1 << x - 1 }
puts data.map { 1 }.tap { |a| data.each_with_index { |c, i| 1.upto(c) { |j| a[i + j] += a[i] } } }.sum
