def solve(boxes, moves, part1 = true)
  moves.each { |(a, b, c)| boxes[c - 1].concat yield(boxes[b - 1].pop(a)) }
  boxes.join(&.[-1])
end

input = File.read("2022/05/test0.txt")
boxes, _, moves = input.partition(/\n.+\n\n/).map(&.lines)

moves = moves.map(&.scan(/\d+/).map(&.[0].to_i))

lines = boxes.reverse!

boxes = (0..boxes[0].size // 4).map do |i|
  lines.compact_map { |line| line[i * 4 + 1].try { |c| c if c != ' ' } }
end

puts solve(boxes.clone, moves, &.reverse!)
puts solve(boxes, moves, &.itself)
