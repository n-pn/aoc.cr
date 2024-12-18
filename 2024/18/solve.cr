MOVES = { {0, 1}, {1, 0}, {0, -1}, {-1, 0} }

def travel(map, max)
  queue = [{0, 0}]

  (1..).each do |i|
    qnext = [] of {Int32, Int32}

    queue.each do |a, b|
      MOVES.each do |x, y|
        c, d = a + x, b + y
        return i if c == max && d == max
        next unless c.in?(0..max) && d.in?(0..max) && !map.includes?({c, d})
        map << {c, d}
        qnext << {c, d}
      end
    end

    return -1 if qnext.empty?
    queue = qnext
  end

  -1
end

input = File.read("#{__DIR__}/input.txt").strip.lines

map = Set({Int32, Int32}).new
map << {0, 0}

input.first(1024).each do |line|
  a, b = line.split(',')
  map << {a.to_i, b.to_i}
end

puts travel(map.clone, 70)

puts(input[1024..].each do |line|
  a, b = line.split(',')
  map << {a.to_i, b.to_i}
  break line if travel(map.clone, 70) == -1
end)
