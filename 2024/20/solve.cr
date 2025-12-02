require "colorize"

input = File.read("#{__DIR__}/input.txt").strip

test0 = <<-TXT
###############
#...#...#.....#
#.#.#.#.#.###.#
#S#...#.#.#...#
#######.#.#.###
#######.#.#...#
#######.#.###.#
###..E#...#...#
###.#######.###
#...###...#...#
#.#####.#.###.#
#.#...#.#.#...#
#.#.#.#.#.#.###
#...#...#...###
###############
TXT

MOVES = { {0, 1}, {1, 0}, {0, -1}, {-1, 0} }

def travel(map, src, dst, min = -1, max = 0)
  queue = [src]
  visited = Set({Int32, Int32}).new

  (1..).each do |n|
    queue = queue.flat_map do |i, j|
      MOVES.compact_map do |x, y|
        pos = {i + x, j + y}
        next unless chr = map[pos]?
        pos if pos != '#' # || (min <= n < max)
      end
    end

    count = queue.count(&.== dst)
    return {n, count} if count > 0
    # visited.concat(queue)
  end

  {-1, 0}
end

def part1(input)
  m, n = input.size - 1, input.lines.first.size - 1

  src = dst = {0, 0}
  map = Hash({Int32, Int32}, Char).new

  input.each_line.with_index do |line, i|
    line.each_char.with_index do |char, j|
      map[{i, j}] = char
      src = {i, j} if char == 'S'
      dst = {i, j} if char == 'E'
    end
  end

  min, _ = travel(map, src, dst, -1, 0)

  (1..min).count do |x|
    new_min, count = travel(map, src, dst, x, x + 1)
    puts [x, new_min, count]
    min - new_min >= 100 ? count : 0
  end

  # map.sum do |(i, j), c|
  #   next 0 unless c == '#' && 0 < i < m && 0 < j < n
  #   new_min, count = travel(map, src, dst, {i, j})
  #   puts [{i, j}, new_min, count]
  #   min - new_min >= 100 ? count : 0
  # end
end

def part2(input)
end

puts "part 1: #{part1(test0)}".colorize.yellow
# puts "part 1: #{part1(input)}".colorize.yellow
