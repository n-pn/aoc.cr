# input = File.read("day09/test0.txt").strip
# input = File.read("day09/test1.txt").strip
input = File.read("day09/input.txt").strip

alias Pos = Tuple(Int32, Int32)
p1, p2 = Set(Pos).new, Set(Pos).new

rope = Array(Pos).new(10, {0, 0})
DIRS = {'R' => {1, 0}, 'L' => {-1, 0}, 'U' => {0, -1}, 'D' => {0, 1}}

input.each_line do |line|
  mx, my = DIRS[line[0]]
  line[2..].to_i.times do
    rope.map_with_index! do |(tx, ty), i|
      next {tx + mx, ty + my} if i == 0
      hx, hy = rope[i - 1]

      if (hx - tx).abs > 1 || (hy - ty).abs > 1
        tx += (hx - tx).sign
        ty += (hy - ty).sign
      end

      {tx, ty}
    end

    p1 << rope[1]
    p2 << rope[-1]
  end
end

puts p1.size, p2.size
