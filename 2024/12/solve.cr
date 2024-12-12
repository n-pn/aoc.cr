SIDES = { {0, 1}, {1, 0}, {0, -1}, {-1, 0} }

def remap(inp)
  map = {} of {Int32, Int32} => Char
  inp.each_with_index { |line, i| line.each_char.with_index { |c, j| map[{i, j}] = c } }

  visited = Set({Int32, Int32}).new
  areas = [] of Array({Int32, Int32})

  map.compact_map do |pos, char|
    next if visited.includes?(pos)
    queue = [pos]
    visited << pos

    queue.each do |pos1|
      SIDES.each do |x, y|
        pos2 = {pos1[0] + x, pos1[1] + y}
        next if map[pos2]? != char || visited.includes?(pos2)
        queue << pos2
        visited << pos2
      end
    end

    queue
  end
end

input = File.read("#{__DIR__}/input.txt").strip.lines
areas = remap(input)

p1 = areas.sum do |area|
  area.size * area.sum { |x, y| SIDES.count { |i, j| !area.includes?({x + i, y + j}) } }
end

p2 = areas.sum do |area|
  sides = area.flat_map { |x, y| SIDES.each.with_index.compact_map { |(i, j), d| {x, y, d} if !area.includes?({x + i, y + j}) } }
  area.size * sides.count { |i, j, d| !sides.includes?({i + SIDES[d][1], j + SIDES[d][0], d}) }
end

puts p1, p2
