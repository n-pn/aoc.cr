# input = File.read("day09/test0.txt").strip
# input = File.read("day09/test1.txt").strip
input = File.read("day09/input.txt").strip

alias Pos = Tuple(Int32, Int32)
p1, p2 = Set(Pos).new, Set(Pos).new

rope = Array(Pos).new(10, {0, 0})
move = {'R' => {1, 0}, 'L' => {-1, 0}, 'U' => {0, -1}, 'D' => {0, 1}}

input.each_line do |line|
  mx, my = move[line[0]]

  line[2..].to_i.times do
    rope.map_with_index! do |(tx, ty), i|
      next {tx + mx, ty + my} if i == 0
      dx, dy = rope[i - 1][0] - tx, rope[i - 1][1] - ty
      dx.abs > 1 || dy.abs > 1 ? {tx + dx.sign, ty + dy.sign} : {tx, ty}
    end

    p1 << rope[1]
    p2 << rope[-1]
  end
end

puts p1.size, p2.size
