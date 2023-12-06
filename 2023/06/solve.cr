input = File.read("#{__DIR__}/input.txt").strip.lines

test1 = <<-TXT.lines
Time:      7  15   30
Distance:  9  40  200
TXT

def solve(time, dist)
  (0_i64..time).count { |i| i * (time - i) > dist }
end

def part1(text)
  times, dists = text.map(&.split[1..])
  times.zip(dists).product { |time, dist| solve(time.to_i, dist.to_i) }
end

def part2(text)
  time, dist = text.map(&.split[1..].join)
  solve(time.to_i64, dist.to_i64)
end

puts part1(test1) == 288
puts part1(input)

puts part2(test1) == 71503
puts part2(input)
