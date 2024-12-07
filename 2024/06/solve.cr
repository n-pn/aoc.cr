require "colorize"

input = File.read("#{__DIR__}/input.txt").strip.lines

test0 = <<-TXT.lines
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
TXT

def part1(input : Array(String))
  max_x, max_y = input.size, input.first.size

  area = {} of {Int32, Int32} => Char

  cx, cy = 0, 0

  input.each_with_index { |line, i| line.each_char.with_index { |c, j| area[{i, j}] = c; cx, cy = i, j if c == '^' } }
  area[{cx, cy}] = 'X'

  dirs, cdir = { {-1, 0}, {0, 1}, {1, 0}, {0, -1} }, 0

  loop do
    dx, dy = dirs[cdir % 4]
    case area[{cx + dx, cy + dy}]?
    when nil then break
    when '#' then cdir += 1
    else          cx += dx; cy += dy; area[{cx, cy}] = 'X'
    end
  end

  area.values.count('X')
end

def looped?(area, cx, cy)
  dirs, cdir = { {-1, 0}, {0, 1}, {1, 0}, {0, -1} }, 0
  visited = Set({Int32, Int32, Int32}).new

  loop do
    return true if visited.includes?({cx, cy, cdir})
    visited << {cx, cy, cdir}

    dx, dy = dirs[cdir]
    nx, ny = cx + dx, cy + dy

    case area[{nx, ny}]?
    when nil then return false
    when '#' then cdir = (cdir + 1) % 4
    else          cx, cy = nx, ny
    end
  end

  false
end

def part2(input : Array(String))
  max_x, max_y = input.size, input.first.size

  area = {} of {Int32, Int32} => Char
  cx, cy = 0, 0

  input.each_with_index { |line, i| line.each_char.with_index { |c, j| area[{i, j}] = c; cx, cy = i, j if c == '^' } }

  count = 0

  input.size.times do |i|
    input.first.size.times do |j|
      next if area[{i, j}] == '#'
      area[{i, j}] = '#'
      count += 1 if looped?(area, cx, cy)
      area[{i, j}] = '.'
    end
  end

  count
end

answer1 = 41
answer2 = 6

if part1(test0) == answer1
  puts "part 1: #{part1(input)}".colorize.yellow
else
  puts "part 1: expected: #{answer1}, actual: #{part1(test0)}"
end

if part2(test0) == answer2
  puts "part 2: #{part2(input)}".colorize.yellow
else
  puts "part 2: expected: #{answer2}, actual: #{part2(test0)}"
end
