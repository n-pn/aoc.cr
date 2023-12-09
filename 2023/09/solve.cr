input = File.read("#{__DIR__}/input.txt").strip.lines

test1 = <<-TXT.lines
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
TXT

def solve(line)
  res = [line]
  while res.last.any?(&.!= 0)
    res << res.last.each_cons_pair.map { |a, b| b - a }.to_a
  end
  res
end

time = Time.measure do
  solved = input.map { |line| solve(line.split.map(&.to_i)) }
  puts solved.sum { |line| line.sum(&.last) }
  puts solved.sum { |line| line.reverse.reduce(0) { |a, b| b[0] - a } }
end

puts time.total_milliseconds
