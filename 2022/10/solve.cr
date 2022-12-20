# input = File.read("day10/test0.txt").strip
input = File.read("day10/input.txt").strip

values = input.each_line.with_object([1]) do |line, obj|
  obj << obj[-1]
  obj << obj[-1] + line[5..].to_i unless line == "noop"
end

p1 = values.each_with_index(1).sum { |v, i| i % 40 == 20 ? v * i : 0 }
puts p1

p2 = values.each_slice(40).map(&.map_with_index { |v, i| v - 1 <= i <= v + 1 ? '#' : '.' }.join)
puts p2.join('\n')
