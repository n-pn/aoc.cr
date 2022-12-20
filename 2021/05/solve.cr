# input = File.read("#{__DIR__}/test0.txt")
input = File.read("#{__DIR__}/input.txt")

def solve(input, part2 = false)
  count = Hash({Int32, Int32}, Int32).new(0)

  input.each_line do |line|
    a, b, c, d = line.scan(/\d+/).map(&.[0].to_i)

    if a == c
      b.to(d) { |i| count[{a, i}] += 1 }
    elsif b == d
      a.to(c) { |i| count[{i, b}] += 1 }
    elsif part2
      a.to(c).zip(b.to(d)).each { |(i, j)| count[{i, j}] += 1 if j }
    end
  end

  count.values.count(&.> 1)
end

puts solve(input, false), solve(input, true)
