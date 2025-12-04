require "colorize"

input = File.read("#{__DIR__}/input.txt").strip.lines

test0 = <<-TXT.lines
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
TXT

ADJACENT = [-1, 0, 1].flat_map { |i| [-1, 0, 1].map { |j| {i, j} } }.reject!(&.==({0, 0}))

def part1(input : Array(String))
  rolls = Set({Int32, Int32}).new
  input.each_with_index { |line, i| line.each_char.with_index { |c, j| rolls << {i, j} if c == '@' } }
  rolls.count { |x, y| ADJACENT.count { |a, b| rolls.includes?({x + a, y + b}) } < 4 }
end

def part2(input : Array(String))
  rolls = Set({Int32, Int32}).new
  input.each_with_index { |line, i| line.each_char.with_index { |c, j| rolls << {i, j} if c == '@' } }

  sum = 0
  loop do
    can_break = true
    rolls.each do |x, y|
      next if ADJACENT.count { |a, b| rolls.includes?({x + a, y + b}) } >= 4
      sum += 1
      rolls.delete({x, y})
      can_break = false
    end

    break if can_break
  end

  sum
end

answer1 = 13
answer2 = 43

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
