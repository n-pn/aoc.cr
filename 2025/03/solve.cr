require "colorize"
input = File.read("#{__DIR__}/input.txt").strip.lines

def solve(input : Array(String), times = 12)
  input.sum do |line|
    arr = line.chars.map_with_index(1) { |a, b| {a.to_i, b} }
    idx = 0
    times.downto(1).reduce(0_i64) do |sum, max|
      chr, idx = arr[idx..-max].max_by(&.[0])
      sum * 10 + chr
    end
  end
end

puts "part 1: #{solve(input, 2)}".colorize.yellow
puts "part 2: #{solve(input, 12)}".colorize.yellow
