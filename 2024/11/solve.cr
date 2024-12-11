require "colorize"

def solve(input, times = 25)
  array = (1..times).reduce(input) do |queue|
    queue.each_with_object(Hash(Int64, Int64).new(0_i64)) do |(n, c), new_q|
      d = n.digits.reverse
      case
      when n == 0
        new_q[n + 1] += c
      when d.size.even?
        new_q[(0...d.size//2).reduce(0_i64) { |a, b| a * 10 + d[b] }] += c
        new_q[(0...d.size//2).reduce(0_i64) { |a, b| a * 10 + d[b + d.size//2] }] += c
      else
        new_q[n * 2024] += c
      end
    end
  end
  array.each_value.sum
end

input = File.read("#{__DIR__}/input.txt").strip.split.to_h { |x| {x.to_i64, 1_i64} }
puts solve(input, 25), solve(input, 75)
