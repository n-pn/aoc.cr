require "colorize"

def part1_1(input : Array(Array(Char)))
  input.sum { |x| x.join.scan(/XMAS/).size + x.join.scan(/SAMX/).size }
end

def part1_2(input : Array(Array(Char)))
  chars = Array(Array(Char)).new(input.size * 2) { |x| [] of Char }
  input.size.times { |i| input.first.size.times { |j| chars[i + j] << input[i][j] } }
  part1_1(chars)
end

def part2(input)
  map = { {0, 0} => 'M', {0, 2} => 'S', {1, 1} => 'A', {2, 0} => 'M', {2, 2} => 'S' }
  0.upto(input.size - 3).sum do |i|
    0.upto(input.first.size - 3).sum do |j|
      map.all? { |(a, b), m| input[i + a][j + b] == m } ? 1 : 0
    end
  end
end

input = File.read("#{__DIR__}/input.txt").strip.lines.map(&.chars)
puts part1_1(input) + part1_1(input.transpose) + part1_2(input) + part1_2(input.map(&.reverse))
puts part2(input) + part2(input.map(&.reverse)) + part2(input.transpose) + part2(input.transpose.map(&.reverse))
