require "../../aoc"

Ctx = AOC.new __DIR__
input = Ctx.input

p1_map = {'f' => {1, 0}, 'd' => {0, 1}, 'u' => {0, -1}}

p1 = input.each_line.reduce({0, 0}) do |(h, d), l|
  a, b = p1_map[l[0]]
  {h + (l[-1] - '0') * a, d + (l[-1] - '0') * b}
end

puts p1.product

p2 = input.each_line.reduce({0_i64, 0_i64, 0_i64}) do |(h, d, a), line|
  x = line[-1] - '0'

  case line[0]
  when 'd' then {h, d, a + x}
  when 'u' then {h, d, a - x}
  else          {h + x, d + a * x, a}
  end
end

puts p2[0] * p2[1]
