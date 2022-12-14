input = File.read("day14/test0.txt").strip
input = File.read("day14/input.txt").strip

def solve(map, ymax, part2 = false)
  (0..).each do |n|
    x, y = 500, 0
    return n if map.includes?({x, y})

    blocked = while y < ymax
      break part2 if y + 1 == ymax
      x, y = { {x, y + 1}, {x - 1, y + 1}, {x + 1, y + 1} }.find(&.in?(map).!) || break true
    end

    return n unless blocked
    map << {x, y}
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
puts solve(map.clone, ymax + 1, false)
puts solve(map, ymax + 2, true)
