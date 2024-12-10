MOVES = { {-1, 0}, {0, 1}, {1, 0}, {0, -1} }

def travel(tmap, queue)
  9.times.reduce(queue) do |q|
    q.flat_map do |(x, y)|
      MOVES.compact_map { |i, j| {x + i, y + j} if tmap[{x + i, y + j}]? == tmap[{x, y}] + 1 }
    end
  end
end

input = File.read("#{__DIR__}/input.txt").strip.lines
tmap = {} of {Int32, Int32} => Int32
from = [] of {Int32, Int32}

input.each_with_index do |line, i|
  line.each_char.with_index do |c, j|
    from << {i, j} if c == '0'
    tmap[{i, j}] = c.to_i
  end
end

time = Time.measure do
  puts from.reduce({0, 0}) { |(a, b), x| travel(tmap, [x]).try { |l| {a + l.uniq.size, b + l.size} } }
end

puts time.total_milliseconds
