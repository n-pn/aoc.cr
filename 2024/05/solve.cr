rules, updates = File.read("#{__DIR__}/input.txt").split("\n\n").map(&.lines)
wrongs, rights = updates.map(&.split(',')).partition { |x| (1...x.size).any? { |i| x[i..].any? { |j| "#{j}|#{x[i - 1]}".in?(rules) } } }

puts rights.sum { |x| x[x.size//2].to_i }
puts wrongs.sum { |x| x.sort! { |a, b| "#{a}|#{b}".in?(rules) ? -1 : 0 }[x.size // 2].to_i }
