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
  {-1, 0, 0},
  {1, 0, 0},
  {0, 1, 0},
  {0, -1, 0},
  {0, 0, 1},
  {0, 0, -1},
}

CUBES = Hash(Int32, Hash(Int32, Hash(Int32, Int32))).new do |h, k|
  h[k] = Hash(Int32, Hash(Int32, Int32)).new { |h2, k2| h2[k2] = Hash(Int32, Int32).new(0) }
end

xmin = ymin = zmin = Int32::MAX
xmax = ymax = zmax = Int32::MIN

input.each_line do |line|
  x, y, z = line.split(",").map(&.to_i)
  CUBES[x][y][z] = 1

  xmin = x if xmin > x
  ymin = y if ymin > y
  zmin = z if zmin > z

  xmax = x if xmax < x
  ymax = y if ymax < y
  zmax = z if zmax < z
end

queue = [] of {Int32, Int32, Int32}

ymin.to(ymax) do |y|
  zmin.to(zmax) do |z|
    CUBES[xmin - 1][y][z] = CUBES[xmax + 1][y][z] = -1
    queue << {xmin, y, z} << {xmax, y, z}
  end
end

xmin.to(xmax) do |x|
  zmin.to(zmax) do |z|
    CUBES[x][ymin - 1][z] = CUBES[x][ymax + 1][z] = -1
    queue << {x, ymin, z} << {x, ymax, z}
  end
end

xmin.to(xmax) do |x|
  ymin.to(ymax) do |y|
    CUBES[x][y][zmin - 1] = CUBES[x][y][zmax + 1] = -1
    queue << {x, y, zmin} << {x, y, zmax}
  end
end

queue.each do |(x, y, z)|
  next if CUBES[x][y][z] != 0
  CUBES[x][y][z] = -1
  DIRS.each { |(i, j, k)| queue << {x + i, y + j, z + k} }
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
