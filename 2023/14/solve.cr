require "colorize"

input = File.read("\#{__DIR__}/input.txt").strip.lines

test0 = <<-TXT.lines

TXT

test1 = <<-TXT.lines

TXT

def part1(input : Array(String))
end

def part2(input : Array(String))
end

answer1 = ""
answer2 = ""

if part1(test0) == answer1
  puts "part 1: #{part1(input)}".colorize.yellow
else
  puts "part 1: expected: #{answer1}, actual: #{part1(test0)}"
end

if part1(test0) == answer2
  puts "part 2: #{part2(input)}".colorize.yellow
else
  puts "part 2: expected: #{answer2}, actual: #{part2(test0)}"
end
