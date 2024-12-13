def solve(array, bonus = 0)
  ax, ay, bx, by, cx, cy = array
  cx, cy = cx + bonus, cy + bonus

  i = (cx * by / bx - cy) / (ax * by / bx - ay)
  j = (cx * ay / ax - cy) / (ay * bx / ax - by)

  i, j = i.round.to_i64, j.round.to_i64
  ax * i + bx * j == cx && ay * i + by * j == cy ? i * 3 + j : 0
end

input = File.read("#{__DIR__}/input.txt").split("\n\n").map(&.scan(/\d+/m).map(&.[0].to_i64))

puts input.sum(0_i64) { |x| solve(x) }
puts input.sum(0_i64) { |x| solve(x, 10000000000000) }
