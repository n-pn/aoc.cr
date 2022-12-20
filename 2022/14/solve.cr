input = File.read("day14/test0.txt").strip
input = File.read("day14/input.txt").strip

def part1(map, ymax)
  (0..).each do |n|
    x, y = 500, 0

    blocked = while y < ymax
      x, y = { {x, y + 1}, {x - 1, y + 1}, {x + 1, y + 1} }.find(&.in?(map).!) || break true
    end

    return n unless blocked
    map << {x, y}
  end
end

def part2(map, ymax)
  bfs = [{500, 0}]

  bfs.each do |(x, y)|
    return bfs.size if y == ymax

    {0, 1, -1}.map { |i| {x + i, y + 1} }.each do |v|
      bfs << v unless v.in?(map)
      map << v
    end
  end
end

map = Set({Int32, Int32}).new

input.each_line do |line|
  line.scan(/(\d+),(\d+)/).map(&.[1..].map(&.to_i)).each_cons_pair { |(a, b), (c, d)|
    if a == c
      b.to(d).each { |y| map << {a, y} }
    else
      a.to(c).each { |x| map << {x, b} }
    end
  }
end

ymax = map.max_of(&.[1])
puts part1(map.clone, ymax)
puts part2(map, ymax + 1)
