input = <<-TEST.strip
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
TEST
input = {{ read_file("day18/input.txt").strip }}

CUBES = Hash({Int32, Int32, Int32}, Int32).new(0)

xmin = ymin = zmin = Int32::MAX
xmax = ymax = zmax = Int32::MIN

input.each_line do |line|
  x, y, z = line.split(",").map(&.to_i)
  CUBES[{x, y, z}] = 1

  xmin = {xmin, x - 1}.min
  ymin = {ymin, y - 1}.min
  zmin = {zmin, z - 1}.min

  xmax = {xmax, x + 1}.max
  ymax = {ymax, y + 1}.max
  zmax = {zmax, z + 1}.max
end

NEIGS = {
  {-1, 0, 0}, {1, 0, 0},
  {0, 1, 0}, {0, -1, 0},
  {0, 0, 1}, {0, 0, -1},
}

queue = [{xmin, ymin, zmin}]

queue.each do |q|
  next if CUBES.has_key?(q)
  next if q[0] < xmin || q[0] > xmax || q[1] < ymin || q[1] > ymax || q[2] < zmin || q[2] > zmax
  NEIGS.each { |(i, j, k)| queue << {q[0] + i, q[1] + j, q[2] + k} }
  CUBES[q] = -1
end

p1 = p2 = 0

CUBES.each do |c, m1|
  next unless m1 == 1
  p1 += NEIGS.count { |i, j, k| CUBES[{c[0] + i, c[1] + j, c[2] + k}] < 1 }
  p2 += NEIGS.count { |i, j, k| CUBES[{c[0] + i, c[1] + j, c[2] + k}] < 0 }
end

puts p1, p2
