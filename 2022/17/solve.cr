# initial shape of each blocks
PROTOS = {
  [{0, 2}, {0, 3}, {0, 4}, {0, 5}],
  [{0, 3}, {1, 2}, {1, 3}, {1, 4}, {2, 3}],
  [{0, 2}, {0, 3}, {0, 4}, {1, 4}, {2, 4}],
  [{0, 2}, {1, 2}, {2, 2}, {3, 2}],
  [{0, 2}, {0, 3}, {1, 2}, {1, 3}],
}

WIDTH = 8 # can be 7 but 8 is faster to compute

# reduce shape to list of integers
SHAPES = PROTOS.map &.map { |(x, y)| x * WIDTH + y }

def top_rows(screen, height, rows = 25) # can be lower
  String.build do |str|
    height.downto(height - rows) do |x|
      7.times { |y| str << (screen.includes?(x * WIDTH + y) ? '#' : '.') }
    end
  end
end

# input = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>".strip
input = {{ read_file("2022/17/input.txt").strip }}

pushes = input.chars.map(&.- '=') # { |c| c == '<' ? -1 : 1 }
push_id = 0

max_heights = [0]
state_memos = Hash(String, Tuple(Int32, Int32)).new

screen = Set(Int32).new
7.times { |i| screen << (i - WIDTH) }

max_height = 0
cycle_data = nil

(0..).each do |index|
  shape = SHAPES[index % SHAPES.size].map(&.+ (max_height + 3) * WIDTH)

  loop do
    shape_2 = shape.map(&.+ pushes[push_id])
    push_id = (push_id + 1) % pushes.size

    shape = shape_2 unless shape_2.any? { |x| !(x % WIDTH).in?(0..6) || x.in?(screen) }

    shape_2 = shape.map(&.- WIDTH)
    break if shape_2.any?(&.in?(screen))

    shape = shape_2
  end

  screen.concat(shape)
  max_height = {max_height, shape.max_of(&.// WIDTH) + 1}.max
  max_heights << max_height

  hash = "#{push_id * 5 + index % 5}:#{top_rows(screen, max_height - 1)}"

  if prev = state_memos[hash]?
    cycle_data = {prev[0], index - prev[0], max_height - prev[1]}
    break
  end

  state_memos[hash] = {index, max_height}
end

{2022, 1000000000000}.each do |part|
  start_idx, cycle_length, cycle_height = cycle_data.not_nil!
  remain_iter = part - start_idx
  cycle_count = remain_iter // cycle_length
  puts cycle_count * cycle_height + max_heights[remain_iter % cycle_length + start_idx]
end
