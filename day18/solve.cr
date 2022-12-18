NEIGS = {
  {-1, 0, 0}, {1, 0, 0},
  {0, 1, 0}, {0, -1, 0},
  {0, 0, 1}, {0, 0, -1},
}

min, max = Int32::MAX, Int32::MIN

# input = {{ read_file("day18/test0.txt").strip }}
INPUT = {{ read_file("day18/input.txt").strip }}

CUBES = Hash({Int32, Int32, Int32}, Int32).new(0)
INPUT.each_line do |line|
  x, y, z = line.split(",").map(&.to_i)
  CUBES[{x, y, z}] = 1
  min = {min, x, y, z}.min
  max = {max, x, y, z}.max
end

def add(x, y)
  x.map_with_index { |a, i| a + y[i] }
end

min, max = min - 1, max + 1
queue = [{min, min, min}]

queue.each do |q|
  next if CUBES.has_key?(q) || q.any? { |x| x < min || x > max }
  NEIGS.each { |i| queue << add(q, i) }
  CUBES[q] = -1
end

p1 = p2 = 0

CUBES.each do |c, m1|
  next unless m1 == 1
  p1 += NEIGS.count { |i| CUBES[add(c, i)] < 1 }
  p2 += NEIGS.count { |i| CUBES[add(c, i)] < 0 }
end

puts p1, p2
