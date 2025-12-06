require "colorize"

input = File.read("#{__DIR__}/input.txt").strip.lines

def part1(input : Array(String))
  ops = input.pop.split
  input.map(&.split.map(&.to_i64)).transpose
    .each_with_index.sum { |row, i| ops[i] == "+" ? row.sum : row.product }
end

def part2(input : Array(String))
  input.pop.each_char.with_index.reject(&.[0].== ' ').sum do |op, i|
    (0..).reduce(op == '*' ? 1_i64 : 0_i64) do |m, j|
      break m unless d = input.join(&.[i + j]?).to_i?
      op == '*' ? m * d : m + d
    end
  end
end

puts "part 1: #{part1(input.dup)}".colorize.yellow
puts "part 2: #{part2(input)}".colorize.yellow
