require "colorize"

input = File.read("#{__DIR__}/input.txt").strip
test0 = File.read("#{__DIR__}/test0.txt").strip

MOVES = { {0, 1}, {1, 0}, {0, -1}, {-1, 0} }

def travel(map, min, dst, x, y, d)
  return if dst == {x, y}
  cost0 = min[{x, y, d}]

  i, j = MOVES[d]
  a, b = x + i, y + j

  if map[{a, b}] != '#'
    cost1 = min[{a, b, d}]? || 9999999
    if cost1 > cost0 + 1
      min[{a, b, d}] = cost0 + 1
      travel(map, min, dst, a, b, d)
    end
  end

  d1 = (d - 1) % 4
  cost1 = min[{x, y, d1}]? || 9999999

  if cost1 > cost0 + 1000
    min[{x, y, d1}] = cost0 + 1000
    travel(map, min, dst, x, y, d1)
  end

  d2 = (d + 1) % 4
  cost2 = min[{x, y, d2}]? || 9999999

  if cost2 > cost0 + 1000
    min[{x, y, d2}] = cost0 + 1000
    travel(map, min, dst, x, y, d2)
  end
end

def part1(inp)
  src = dst = {0, 0}
  map = Hash({Int32, Int32}, Char).new
  min = Hash({Int32, Int32, Int32}, Int32).new

  inp.each_line.with_index do |line, i|
    line.each_char.with_index do |char, j|
      map[{i, j}] = char
      src = {i, j} if char == 'S'
      dst = {i, j} if char == 'E'
    end
  end

  min[{src[0], src[1], 0}] = 0
  travel(map, min, dst, src[0], src[1], 0)

  (0..4).min_of { |i| min[{dst[0], dst[1], i}]? || 999999 }
end

def part2(inp)
  src = dst = {0, 0}
  map = Hash({Int32, Int32}, Char).new
  min = Hash({Int32, Int32, Int32}, Int32).new

  inp.each_line.with_index do |line, i|
    line.each_char.with_index do |char, j|
      map[{i, j}] = char
      src = {i, j} if char == 'S'
      dst = {i, j} if char == 'E'
    end
  end

  min[{src[0], src[1], 0}] = 0
  travel(map, min, dst, src[0], src[1], 0)

  dst_min = (0..4).min_of { |i| min[{dst[0], dst[1], i}]? || 999999 }

  queue = [] of {Int32, Int32, Int32}
  (0..4).each { |i| queue << {dst[0], dst[1], i} if min[{dst[0], dst[1], i}]? == dst_min }

  queue.each do |(x, y, d)|
    cost0 = min[{x, y, d}]
    d1, d2 = (d - 1) % 4, (d + 1) % 4

    queue << {x, y, d1} if min[{x, y, d1}]? == cost0 - 1000
    queue << {x, y, d2} if min[{x, y, d2}]? == cost0 - 1000

    i, j = MOVES[d]
    a, b = x - i, y - j
    queue << {a, b, d} if min[{a, b, d}]? == cost0 - 1
  end

  queue.uniq { |x, y, d| {x, y} }.size
end

# answer1 = 7036
# actual1 = part1(test0)

# if actual1 == answer1
#   puts "part 1: #{part1(input)}".colorize.yellow
# else
#   puts "part 1: expected: #{answer1}, actual: #{actual1}"
# end

answer2 = 45
actual2 = part2(test0)

if actual2 == answer2
  puts "part 2: #{part2(input)}".colorize.yellow
else
  puts "part 2: expected: #{answer2}, actual: #{actual2}"
end
