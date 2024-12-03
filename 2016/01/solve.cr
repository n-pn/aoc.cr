require "colorize"

MOVES = { {0, 1}, {1, 0}, {0, -1}, {-1, 0} }

input = File.read("#{__DIR__}/input.txt").strip.split(", ")

steps = input.reduce([{0, 0, 0}]) do |a, m|
  d = (a.last[2] + (m[0] == 'R' ? 1 : -1)) % 4
  a.concat (1..m[1..].to_i).map { |s| {a.last[0] + MOVES[d][0] * s, a.last[1] + MOVES[d][1] * s, d} }
end

puts steps.last.try { |x, y, _| x.abs + y.abs }

visited = Set({Int32, Int32}).new
steps.each do |(x, y, _)|
  if visited.includes?({x, y})
    puts x.abs + y.abs
    break
  else
    visited << {x, y}
  end
end
