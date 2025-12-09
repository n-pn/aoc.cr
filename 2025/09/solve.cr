require "colorize"

def part1(input : Array(String))
  arr = input.map(&.split(',').map(&.to_i64))
  max = 0
  arr.each_with_index do |a, i|
    arr[i + 1..].each_with_index(i + 1) do |b, j|
      x = (a[0] - b[0]).abs + 1
      y = (a[1] - b[1]).abs + 1
      dis = x * y
      max = dis if dis > max
    end
  end
  max
end

def part2(input : Array(String))
  arr = input.map { |x| a, b = x.split(',').map(&.to_i); {a, b} }

  x_map = arr.map(&.[0]).uniq.sort!.map_with_index { |x, i| {x, i * 2} }.to_h
  y_map = arr.map(&.[1]).uniq.sort!.map_with_index { |x, i| {x, i * 2} }.to_h

  inner = Set({Int32, Int32}).new

  arr << arr[0]
  arr.each_cons_pair do |(ax, ay), (bx, by)|
    ax = x_map[ax]
    ay = y_map[ay]
    bx = x_map[bx]
    by = y_map[by]

    if ax == bx
      ay.to(by).each { |i| inner << {ax, i} }
    else
      ax.to(bx).each { |i| inner << {i, ay} }
    end
  end

  arr.pop

  x_min, y_min = arr.min_by { |a, b| {a, b} }

  start = {x_map[x_min] + 1, y_map[y_min] + 1}
  inner << start

  queue = [start]
  queue.each do |(x, y)|
    [{0, -1}, {0, 1}, {-1, 0}, {1, 0}].each do |i, j|
      next if inner.includes?({x + i, y + j})
      queue << {x + i, y + j}
      inner << {x + i, y + j}
    end
  end

  max = 0
  arr.each_with_index do |(ax, ay), i|
    arr[i + 1..].each do |bx, by|
      next unless x_map[ax].to(x_map[bx]).all? { |k| y_map[ay].to(y_map[by]).all? { |l| inner.includes?({k, l}) } }
      max = {(ax - bx).abs.+(1) * (ay - by).abs.+(1), max}.max
    end
  end

  max
end

input = File.read("#{__DIR__}/input.txt").strip.lines
puts "part 1: #{part1(input)}".colorize.yellow
puts "part 2: #{part2(input)}".colorize.yellow
