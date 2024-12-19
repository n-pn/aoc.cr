def travel(map, max)
  (1..).reduce([{0, 0}]) do |queue, i|
    break -1 if queue.empty?
    { {0, 1}, {1, 0}, {0, -1}, {-1, 0} }.flat_map do |x, y|
      queue.compact_map do |q|
        n = {q[0] + x, q[1] + y}
        return i if n == {max, max}
        n.tap { |x| map << x } if n.all?(&.in?(0..max)) && !map.includes?(n)
      end
    end
  end
end

input = File.read("#{__DIR__}/input.txt").strip.lines.map(&.split(',').try { |x| {x[0].to_i, x[1].to_i} })
part2 = (1..input.size).bsearch { |i| travel(input.first(i).to_set, 70) == -1 } || 1

puts travel(input.first(1024).to_set, 70), input[part2 - 1].join(',')
