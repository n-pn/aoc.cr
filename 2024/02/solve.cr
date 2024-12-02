input = File.read("#{__DIR__}/input.txt").strip.lines.map(&.split.map(&.to_i))

def safe?(x)
  x.each_cons_pair.all? { |a, b| (a > b) == (x[0] > x[1]) && (a - b).abs.in?(1, 2, 3) }
end

puts input.count { |x| safe?(x) }
puts input.count { |x| safe?(x) || (0...x.size).any? { |i| safe?(x.clone.tap(&.delete_at(i))) } }
