def part1_1(inp)
  inp.sum(&.each_cons(4).count(&.join.in?("XMAS", "SAMX")))
end

def part1_2(inp, max = inp.size * 2)
  part1_1 (0..max).map { |s| (0..max).compact_map { |x| inp[x]?.try(&.[s - x]?) if x <= s } }
end

def part2(inp, len = inp.size - 3)
  map = { {0, 0} => 'M', {0, 2} => 'S', {1, 1} => 'A', {2, 0} => 'M', {2, 2} => 'S' }
  0.upto(len).sum { |i| 0.upto(len).count { |j| map.all? { |(a, b), m| inp[i + a][j + b] == m } } }
end

inp = File.read("#{__DIR__}/input.txt").strip.lines.map(&.chars)
puts part1_1(inp) + part1_1(inp.transpose) + part1_2(inp) + part1_2(inp.reverse)
puts part2(inp) + part2(inp.map(&.reverse)) + part2(inp.transpose) + part2(inp.transpose.map(&.reverse))
