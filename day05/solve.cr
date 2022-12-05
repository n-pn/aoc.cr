def solve(input : String, part1 = true)
  layout, moves = input.split("\n\n")
  layout = layout.split("\n").tap(&.pop)
  size = (layout.first.size + 1) // 4

  boxes = (0..size - 1).map do |i|
    layout.reverse_each.with_object([] of Char) do |line, list|
      line[i * 4 + 1].tap { |c| list << c unless c == ' ' }
    end
  end

  moves.each_line do |line|
    a, b, c = line.split(/\D+/, remove_empty: true).map(&.to_i)
    x = boxes[b - 1]

    if part1
      a.times { boxes[c - 1] << x.pop }
    else
      m = [] of Char
      a.times { m.unshift(x.pop) }
      boxes[c - 1].concat(m)
    end
  end

  boxes.map(&.last).join
end

puts solve(File.read("day05/test0.txt"), part1: true)
puts solve(File.read("day05/input.txt"), part1: true)

puts solve(File.read("day05/test0.txt"), part1: false)
puts solve(File.read("day05/input.txt"), part1: false)
