input = File.read("#{__DIR__}/input.txt").strip.lines

test1 = <<-TXT.lines
Time:      7  15   30
Distance:  9  40  200
TXT

def solve(time, dist)
  (0_i64..time).count { |i| i &* (time &- i) > dist }
end

def part1(text)
  times = text[0].scan(/\d+/).map(&.[0].to_i64)
  dists = text[1].scan(/\d+/).map(&.[0].to_i64)
  times.zip(dists).product { |time, dist| solve(time, dist) }
end

def part2(text)
  time = text[0].scan(/\d+/).map(&.[0]).join.to_i64
  dist = text[1].scan(/\d+/).map(&.[0]).join.to_i64
  solve(time, dist)
end

puts part1(test1) == 288
puts part1(input)

puts part2(test1) == 71503
puts part2(input)
