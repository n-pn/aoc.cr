# input = <<-TEST
# Sensor at x=2, y=18: closest beacon is at x=-2, y=15
# Sensor at x=9, y=16: closest beacon is at x=10, y=16
# Sensor at x=13, y=2: closest beacon is at x=15, y=3
# Sensor at x=12, y=14: closest beacon is at x=10, y=16
# Sensor at x=10, y=20: closest beacon is at x=10, y=16
# Sensor at x=14, y=17: closest beacon is at x=10, y=16
# Sensor at x=8, y=7: closest beacon is at x=2, y=10
# Sensor at x=2, y=0: closest beacon is at x=2, y=10
# Sensor at x=0, y=11: closest beacon is at x=2, y=10
# Sensor at x=20, y=14: closest beacon is at x=25, y=17
# Sensor at x=17, y=20: closest beacon is at x=21, y=22
# Sensor at x=16, y=7: closest beacon is at x=15, y=3
# Sensor at x=14, y=3: closest beacon is at x=15, y=3
# Sensor at x=20, y=1: closest beacon is at x=15, y=3
# TEST

input = File.read("2022/15/input.txt").strip

record Sensor, x : Int32, y : Int32, d : Int32 do
  def reach?(a, b)
    (x - a).abs + (y - b).abs <= d
  end
end

sensors = [] of Sensor
beacons = Hash(Int32, Set(Int32)).new { |h, k| h[k] = Set(Int32).new }

input.lines.map(&.scan(/-?\d+/).map(&.[0].to_i)).each do |(sx, sy, bx, by)|
  beacons[by] << bx
  sensors << Sensor.new(sx, sy, (sx - bx).abs + (sy - by).abs)
end

def part1(sensors, beacons, y = 10)
  xmin = Int32::MAX
  xmax = Int32::MIN

  sensors.each do |sensor|
    dis = sensor.d - (sensor.y - y).abs
    xmin = {xmin, sensor.x - dis}.min
    xmax = {xmax, sensor.x + dis}.max
  end

  xmax - xmin - beacons[y].size + 1
end

def part2(sensors, upper = 20)
  in_range = 0..upper

  sensors.each do |sensor|
    sensor.d.times do |i|
      j = sensor.d - i + 1

      { {i, j}, {i, -j}, {-i, j}, {-i, -j} }.each do |x, y|
        bx, by = sensor.x + x, sensor.y + y
        next unless bx.in?(in_range) && by.in?(in_range)

        return 4000000_i64 * bx + by unless sensors.any?(&.reach?(bx, by))
      end
    end
  end
end

puts part1(sensors, beacons, 2000000)
puts part2(sensors, 4000000)
