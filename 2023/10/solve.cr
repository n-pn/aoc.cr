require "colorize"

input = File.read("#{__DIR__}/input.txt").strip

test1 = <<-TXT
-L|F7
7S-7|
L|7||
-L-J|
L|-JF
TXT

test2 = <<-TXT
.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...
TXT

record Pos, x : Int32, y : Int32 do
  def move(d : self)
    Pos.new(x + d.x, y + d.y)
  end

  DIR = {new(-1, 0), new(0, 1), new(1, 0), new(0, -1)}

  def each_next(map, &)
    DIR.each_with_index do |dir, idx|
      pos = self.move(dir)
      yield pos if map[self][idx] && map[pos]?.try(&.[(idx + 2) % 4])
    end
  end
end

MAP = {
  'S' => {true, true, true, true},
  '|' => {true, false, true, false},
  '-' => {false, true, false, true},
  '7' => {false, false, true, true},
  'F' => {false, true, true, false},
  'L' => {true, true, false, false},
  'J' => {true, false, false, true},
}

def parse(text)
  input = {} of Pos => {Bool, Bool, Bool, Bool}
  start = Pos.new(0, 0)

  text.each_line.with_index do |line, x|
    line.each_char.with_index do |char, y|
      next unless pipe = MAP[char]?
      pos = Pos.new(x, y)
      input[pos] = pipe
      start = pos if char == 'S'
    end
  end

  {input, start}
end

def solve(text)
  input, start = parse(text)
  stack = [] of Array(Pos)

  start.each_next(input) { |node| stack << [start, node] }

  while rope = stack.pop?
    rope.last.each_next(input) do |node|
      if node == start
        next if rope.size < 3
        area = rope.push(rope.first).each.cons_pair.sum { |a, b| a.x * b.y - a.y * b.x }.abs // 2 - rope.size // 2 + 1
        return rope.size // 2, area
      end

      next if rope.includes?(node)
      stack << rope.dup.push(node)
    end
  end
end

puts solve(test1)
puts solve(test2)
puts solve(input)
