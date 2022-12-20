require "../../aoc"

Ctx = AOC.new __DIR__

input = Ctx.input.lines.map(&.chars).transpose

p1 = input.reduce({0, 0}) do |(gamma, epsilon), chars|
  a, b = chars.count('1') > (chars.size // 2) ? {1, 0} : {0, 1}
  {gamma << 1 | a, epsilon << 1 | b}
end

puts p1.product
