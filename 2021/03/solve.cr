require "../../aoc"

# input = File.read("#{__DIR__}/test0.txt").lines.map(&.chars)
Ctx = AOC.new __DIR__
input = Ctx.input.lines.map(&.chars)

p1 = input.transpose.reduce({0, 0}) do |(gamma, epsilon), chars|
  a, b = chars.count('1') > (chars.size // 2)  ? {1, 0} : {0, 1}
  {gamma << 1 | a, epsilon << 1 | b}
end

puts p1.product

generator = input.clone

(input.first.size).times do |i|
  char = generator.map(&.[i]).count('1') >= (generator.size / 2) ? '1' : '0'
  generator.select!{|x| x[i] == char}
  break if generator.size == 1
end

scrubber = input.clone

(input.first.size).times do |i|
  char = scrubber.map(&.[i]).count('1') >= (scrubber.size / 2) ? '0' : '1'
  scrubber.select!{|x| x[i] == char}
  break if scrubber.size == 1
end

puts generator.first.join.to_i(base: 2) * scrubber.first.join.to_i(base: 2)
