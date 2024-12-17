MOVES = { {0, 1}, {1, 0}, {0, -1}, {-1, 0} }

INPUT = File.read("#{__DIR__}/input.txt").strip.lines.map(&.chars)
COSTS = {} of {Int32, Int32, Int32} => Int32

def travel(tgt, src, dir)
  cost = COSTS[{src[0], src[1], dir}]
  puts [src, dir, cost]

  i, j = MOVES[dir]
  x, y = src[0] &+ i, src[1] &+ j

  if INPUT[x][y] != '#' && COSTS.fetch({x, y, dir}, 999999) > cost &+ 1
    COSTS[{x, y, dir}] = cost &+ 1
    travel(tgt, {x, y}, dir) if {x, y} != tgt
  end

  d1, d2, cost2 = (dir &- 1) % 4, (dir &+ 1) % 4, cost &+ 1000

  if COSTS.fetch({x, y, d1}, 999999) > cost2
    COSTS[{src[0], src[1], d1}] = cost2
    travel(tgt, src, d1)
  end

  if COSTS.fetch({x, y, d2}, 999999) > cost2
    COSTS[{src[0], src[1], d2}] = cost2
    travel(tgt, src, d2)
  end
end

src = tgt = {0, 0}

INPUT.each.with_index do |line, i|
  line.each.with_index do |char, j|
    src = {i, j} if char == 'S'
    tgt = {i, j} if char == 'E'
  end
end

COSTS[{src[0], src[1], 0}] = 0
travel(tgt, src, 0)

part1 = (0..4).min_of { |dir| COSTS[{tgt[0], tgt[1], dir}]? || 999999 }
puts part1

# (0..4).each { |dir| puts min[{tgt, dir}]? }

# def part2(inp)
#   src = tgt = {0, 0}
#   map = Hash({Int32, Int32}, Char).new
#   min = Hash({Int32, Int32, Int32}, Int32).new

#   inp.each_line.with_index do |line, i|
#     line.each_char.with_index do |char, j|
#       map[{i, j}] = char
#       src = {i, j} if char == 'S'
#       tgt = {i, j} if char == 'E'
#     end
#   end

#   min[{src[0], src[1], 0}] = 0
#   travel(map, min, tgt, src[0], src[1], 0)

#   tgt_min = (0..4).min_of { |i| min[{tgt[0], tgt[1], i}]? || 999999 }

#   queue = [] of {Int32, Int32, Int32}
#   (0..4).each { |i| queue << {tgt[0], tgt[1], i} if min[{tgt[0], tgt[1], i}]? == tgt_min }

#   queue.each do |(x, y, d)|
#     cost0 = min[{x, y, d}]
#     d1, d2 = (d - 1) % 4, (d + 1) % 4

#     queue << {x, y, d1} if min[{x, y, d1}]? == cost0 - 1000
#     queue << {x, y, d2} if min[{x, y, d2}]? == cost0 - 1000

#     i, j = MOVES[d]
#     a, b = x - i, y - j
#     queue << {a, b, d} if min[{a, b, d}]? == cost0 - 1
#   end
#   queue.uniq { |x, y, d| {x, y} }.size
# end

# answer1 = 7036
# actual1 = part1(test0)

# if actual1 == answer1
#   puts "part 1: #{part1(input)}".colorize.yellow
# else
#   puts "part 1: expected: #{answer1}, actual: #{actual1}"
# end

# answer2 = 45
# actual2 = part2(test0)

# if actual2 == answer2
#   puts "part 2: #{part2(input)}".colorize.yellow
# else
#   puts "part 2: expected: #{answer2}, actual: #{actual2}"
# end
