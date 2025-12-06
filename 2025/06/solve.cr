require "colorize"

input = File.read("#{__DIR__}/input.txt").strip.lines

def part1(input : Array(String))
  input[..-2].map(&.split.map(&.to_i64)).transpose
    .zip(input[-1].split).sum { |row, op| op == "+" ? row.sum : row.product }
end

def part2(input : Array(String))
  input.pop.each_char.with_index.reject(&.[0].== ' ').sum do |op, i|
    (i..).reduce(op == '*' ? 1_i64 : 0_i64) do |m, j|
      break m unless d = input.join(&.[j]?).to_i?
      op == '*' ? m * d : m + d
    end
  end
end

puts "part 1: #{part1(input)}".colorize.yellow
puts "part 2: #{part2(input)}".colorize.yellow
