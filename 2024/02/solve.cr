input = File.read("#{__DIR__}/input.txt").lines.map(&.split.map(&.to_i))

is_safe = ->(x : Array(Int32)) { x.each_cons_pair.all? { |a, b| (a > b) == (x[0] > x[1]) && (a - b).abs.in?(1, 2, 3) } }

puts input.count { |x| is_safe.call(x) }
puts input.count { |x| is_safe.call(x) || (0...x.size).any? { |i| is_safe.call(x.clone.tap(&.delete_at(i))) } }
