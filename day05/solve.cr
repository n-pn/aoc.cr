def solve(input : String, part1 = true)
  layout, moves = input.split("\n\n")
  layout = layout.split("\n").tap(&.pop)

  boxes = (0..layout.first.size // 4).map do |i|
    layout.reverse_each.with_object([] of Char) do |line, list|
      line[i * 4 + 1].tap { |c| list << c if c != ' ' }
    end
  end

  moves.each_line do |line|
    a, b, c = line.split(/\D+/, remove_empty: true).map(&.to_i)
    boxes[c - 1].concat boxes[b - 1].pop(a).tap { |x| x.reverse! if part1 }
  end

  boxes.map(&.last).join
end

puts solve(File.read("day05/test0.txt"), part1: true)
puts solve(File.read("day05/input.txt"), part1: true)

puts solve(File.read("day05/test0.txt"), part1: false)
puts solve(File.read("day05/input.txt"), part1: false)
