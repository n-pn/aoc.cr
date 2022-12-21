# input = File.read("2022/08/test0.txt").strip
input = File.read("2022/08/input.txt").strip

g1 = input.lines.map(&.chars)
g2 = g1.transpose

p1 = g1.each_with_index.sum do |r, i|
  r.each_with_index.count do |v, j|
    {r[0...j], r[j + 1..], g2[j][0...i], g2[j][i + 1..]}.any?(&.all?(&.< v))
  end
end

p2 = g1.each_with_index.max_of do |r, i|
  r.each_with_index.max_of do |v, j|
    {r[0...j].reverse, r[j + 1..], g2[j][0...i].reverse, g2[j][i + 1..]}.product { |a| a.index(&.>= v).try(&.+ 1) || a.size }
  end
end

puts p1, p2
