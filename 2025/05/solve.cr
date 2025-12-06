require "colorize"

input = File.read("#{__DIR__}/input.txt").strip

test0 = <<-TXT
3-5
10-14
16-20
12-18

1
5
8
11
17
32
TXT

def part1(input : String)
  fresh, ingredients = input.split("\n\n")
  ranges = fresh.lines.map { |line| a, b = line.split("-").map(&.to_i64); a..b }

  ingredients.lines.count do |x|
    ranges.any?(&.includes?(x.to_i64))
  end
end

def part2(input : String)
  fresh, _ = input.split("\n\n")
  ranges = fresh.lines.map { |line| a, b = line.split("-").map(&.to_i64); {a, b} }
  ranges.sort!

  (ranges.size - 1).downto(0) do |i|
    x, y = ranges[i]
    next unless index = ranges[0...i].index { |a, b| x.in?(a..b) || y.in?(a..b) }
    a, b = ranges[index]
    ranges[index] = { {x, a}.min, {y, b}.max }
    ranges.delete_at(i)
  end

  ranges.sum { |a, b| b - a + 1 }
end

answer1 = 3
answer2 = 14

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
