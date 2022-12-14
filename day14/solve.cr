input = File.read("day14/test0.txt").strip
input = File.read("day14/input.txt").strip

def solve(map, bottom, count_bottom = false)
  (0..).each do |n|
    x, y = 500, 0
    return n if map.includes?({x, y})

    while !map.includes?({x, y})
      if y == bottom
        return n unless count_bottom
        map << {x, y}
        break
      end

      y += 1

      if i = {0, -1, 1}.find { |a| !{x + a, y}.in? map }
        x += i
      else
        map << {x, y - 1}
      end
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

bottom = map.max_of(&.[1])
puts solve(map.clone, bottom, false)
puts solve(map, bottom + 1, true)
