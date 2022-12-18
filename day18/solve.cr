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

DIRS = {
  {-1, 0, 0}, {1, 0, 0},
  {0, 1, 0}, {0, -1, 0},
  {0, 0, 1}, {0, 0, -1},
}

CUBES = Hash(Int32, Hash(Int32, Hash(Int32, Int32))).new do |h, k|
  h[k] = Hash(Int32, Hash(Int32, Int32)).new { |h2, k2| h2[k2] = Hash(Int32, Int32).new(0) }
end

xmin = ymin = zmin = Int32::MAX
xmax = ymax = zmax = Int32::MIN

input.each_line do |line|
  x, y, z = line.split(",").map(&.to_i)
  CUBES[x][y][z] = 1

  xmin = {xmin, x - 1}.min
  ymin = {ymin, y - 1}.min
  zmin = {zmin, z - 1}.min

  xmax = {xmax, x + 1}.max
  ymax = {ymax, y + 1}.max
  zmax = {zmax, z + 1}.max
end

queue = [{xmin, ymin, zmin}]

queue.each do |(x, y, z)|
  next unless x.in?(xmin..xmax) && y.in?(xmin..zmax) && z.in?(zmin..zmax)

  CUBES[x][y][z] ||= begin
    DIRS.each { |(i, j, k)| queue << {x + i, y + j, z + k} }
    -1
  end
end

p1 = p2 = 0

CUBES.each do |x, ymap|
  ymap.each do |y, zmap|
    zmap.each do |z, mask|
      next unless mask == 1

      DIRS.each do |(i, j, k)|
        mx, my, mz = x + i, y + j, z + k
        p1 += 1 if CUBES[mx][my][mz] != 1
        p2 += 1 if CUBES[mx][my][mz] == -1
      end
    end
  end
end

puts p1, p2
