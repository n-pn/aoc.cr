CHECKS = {
  { {-1, -1}, {-1, 0}, {-1, 1} }, # north
  { {1, -1}, {1, 0}, {1, 1} },    # south
  { {-1, -1}, {0, -1}, {1, -1} }, # west
  { {-1, 1}, {0, 1}, {1, 1} },    # east
}

# input = {{ read_file("2022/23/test1.txt").strip }}
input = {{ read_file("2022/23/input.txt").strip }}

alias Pix = Tuple(Int32, Int32)

state = Set(Pix).new
input.each_line.with_index { |line, i| line.each_char.with_index { |v, j| state << {i, j} if v == '#' } }

proposes = Hash(Pix, Array(Pix)).new { |h, k| h[k] = [] of Pix }
propose = [] of Pix

(0..).each do |i|
  state.each do |(x, y)|
    propose.clear

    4.times do |j|
      array = CHECKS[(i + j) % 4].map { |(dx, dy)| {x + dx, y + dy} }
      propose << array[1] unless array.any?(&.in?(state))
    end

    proposes[propose[0]] << {x, y} if propose.size.in?(1, 2, 3)
  end

  moved = false

  proposes.each do |place, elves|
    next if elves.size > 1
    moved = true

    state << place
    state.delete(elves[0])
  end

  if i == 9
    xmin, xmax = state.minmax_of(&.[0])
    ymin, ymax = state.minmax_of(&.[1])

    puts (xmax - xmin + 1) * (ymax - ymin + 1) - state.size
  end

  proposes.clear
  next if moved

  puts i + 1
  break
end
