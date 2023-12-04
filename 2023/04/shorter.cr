require "bit_array"
time = Time.measure do
  text = File.read_lines("#{__DIR__}/bigboy.txt")

  data = text.map do |line|
    win, you = line.split(':', 2).last.split('|', 2)
    set = BitArray.new(100)
    win.split { |i| set[i.to_i] = true }
    you.split.count { |i| set[i.to_i] }
  end

  puts data.sum { |x| 1 << x - 1 }
  puts data.map { 1 }.tap { |a| data.each_with_index { |c, i| 1.upto(c) { |j| a[i + j] += a[i] } } }.sum
end

puts time
