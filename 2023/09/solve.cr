def solve(line)
  res = [line]
  while res.last.any?(&.!= 0)
    res << res.last.each_cons_pair.map { |a, b| b - a }.to_a
  end
  res
end

time = Time.measure do
  input = File.read_lines("#{__DIR__}/input.txt")
  solved = input.map { |line| solve(line.split.map(&.to_i)) }
  puts solved.sum { |line| line.sum(&.last) }
  puts solved.sum { |line| line.reverse.reduce(0) { |a, b| b[0] - a } }
end

puts time.total_milliseconds
