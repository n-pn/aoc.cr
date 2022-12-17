SHAPES = {
  [{0, 2}, {0, 3}, {0, 4}, {0, 5}],
  [{0, 3}, {1, 2}, {1, 3}, {1, 4}, {2, 3}],
  [{0, 2}, {0, 3}, {0, 4}, {1, 4}, {2, 4}],
  [{0, 2}, {1, 2}, {2, 2}, {3, 2}],
  [{0, 2}, {0, 3}, {1, 2}, {1, 3}],
}

def overlap?(screen, shape)
  shape.any? { |x, y| y < 0 || y > 6 || screen[y].includes?(x) }
end

def capture_screen(screen, height, depth = 30)
  String.build do |str|
    height.downto(height - depth) do |x|
      7.times { |y| str << (screen[y].includes?(x) ? '#' : '.') }
    end
  end
end

def solve(jet_dirs, limit = 3000)
  heights = [0]
  memoize = Hash(Int32, Hash(String, Tuple(Int32, Int32))).new

  screen = Array(Set(Int32)).new(7) { Set(Int32).new }
  7.times { |i| screen[i] << -1 }

  jet_idx = 0
  height = 0
  cycle_found = nil

  3000.times do |index|
    shape = SHAPES[index % SHAPES.size].map { |x, y| {x + height + 3, y} }

    loop do
      jet_dir = jet_dirs[jet_idx]
      jet_idx = (jet_idx + 1) % jet_dirs.size

      shape_2 = shape.map { |x, y| {x, y + jet_dir} }
      shape = shape_2 unless overlap?(screen, shape_2)

      shape_2 = shape.map { |x, y| {x - 1, y} }
      break if overlap?(screen, shape_2)
      shape = shape_2
    end

    shape.each { |(x, y)| screen[y] << x }
    height = {height, shape.max_of(&.[0]) + 1}.max
    heights << height

    next if cycle_found

    memo = memoize[jet_idx * 5 + index % 5] ||= {} of String => {Int32, Int32}
    hash = capture_screen(screen, height - 1)

    if prev = memo[hash]?
      cycle_found = {prev[0], index - prev[0], height - prev[1]}
    else
      memo[hash] = {index, height}
    end
  end

  {heights, cycle_found.not_nil!}
end

# input = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>".strip
input = File.read("day17/input.txt").strip

jet_dirs = input.chars.map { |c| c == '<' ? -1 : 1 }
heights, cycle = solve(jet_dirs)

start_idx, cycle_length, cycle_height = cycle.not_nil!
upper_idx = 1000000000000 - start_idx

cycle_count = upper_idx // cycle_length

puts heights[2022]
puts cycle_count * cycle_height + heights[upper_idx % cycle_length + start_idx]
