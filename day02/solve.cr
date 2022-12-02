# input = File.read("day02/test0.txt").strip
input = File.read("day02/input.txt").strip

puts input.each_line.reduce({0, 0}) { |(p1, p2), line|
  a, b = line[0] - 'A', line[2] - 'X'
  {p1 + (b - a + 1) % 3 * 3 + b + 1, p2 + b * 3 + (b + a - 1) % 3 + 1}
}
