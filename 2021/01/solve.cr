require "../../aoc"

Ctx = AOC.new __DIR__
input = Ctx.input.lines.map(&.to_i)

p1 = input.each_cons_pair.count { |a, b| b > a }
p2 = input.each_cons(3).cons_pair.count { |a, b| b.sum > a.sum }

puts p1, p2
