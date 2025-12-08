require "colorize"

input = File.read("#{__DIR__}/input.txt").strip.lines

def part1(input : Array(String), times = 10)
  points = input.map(&.split(',').map(&.to_i64))

  pairs = [] of {Int32, Int32, Int64}
  points.each_with_index do |a, i|
    points[(i + 1)..].each_with_index(i + 1) do |b, j|
      w = (a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2 + (a[2] - b[2]) ** 2
      pairs << {i, j, w}
    end
  end

  pairs.sort_by! { |_, _, w| w }
  joints = Hash(Int32, Array(Int32)).new { |h, k| h[k] = [] of Int32 }

  pairs.first(times).each do |i, j, _|
    joints[i] << j
    joints[j] << i
  end

  visited = Array.new(points.size, false)

  sizes = [] of Int32

  points.size.times do |i|
    next if visited[i]
    visited[i] = true
    queue = [i]
    queue.each do |j|
      joints[j].each do |k|
        next if visited[k]
        visited[k] = true
        queue << k
      end
    end

    sizes << queue.size
  end

  sizes.sort!
  sizes.last(3).product
end

def part2(input : Array(String))
  pairs = [] of {Int32, Int32, Int64}

  points = input.map(&.split(',').map(&.to_i64))

  points.each_with_index do |a, i|
    points[(i + 1)..].each_with_index(i + 1) do |b, j|
      w = (a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2 + (a[2] - b[2]) ** 2
      pairs << {i, j, w}
    end
  end

  pairs.sort_by! { |_, _, w| w }

  joints = Hash(Int32, Array(Int32)).new { |h, k| h[k] = [] of Int32 }

  pairs.each do |a, b, _|
    joints[b] << a
    joints[a] << b

    visited = Array.new(points.size, false)
    visited[0] = true
    queue = [0]
    queue.each do |i|
      joints[i].each do |j|
        next if visited[j]
        visited[j] = true
        queue << j
      end
    end

    return points[a][0] * points[b][0] if queue.size == points.size
  end
end

puts "part 1: #{part1(input, 1000)}".colorize.yellow

puts "part 2: #{part2(input)}".colorize.yellow
