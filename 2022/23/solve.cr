CHECKS = {
  { {-1, -1}, {-1, 0}, {-1, 1} }, # north
  { {1, -1}, {1, 0}, {1, 1} },    # south
  { {-1, -1}, {0, -1}, {1, -1} }, # west
  { {-1, 1}, {0, 1}, {1, 1} },    # east
}

# input = {{ read_file("2022/23/test1.txt").strip }}
input = {{ read_file("2022/23/input.txt").strip }}

state = Set({Int32, Int32}).new
input.each_line.with_index { |line, i| line.each_char.with_index { |v, j| state << {i, j} if v == '#' } }

proposes = Hash({Int32, Int32}, Array({Int32, Int32})).new
propose = [] of {Int32, Int32}

(0..).each do |i|
  state.each do |(x, y)|
    propose.clear

    4.times do |j|
      array = CHECKS[(i + j) % 4].map { |(dx, dy)| {x + dx, y + dy} }
      propose << array[1] unless array.any?(&.in?(state))
    end

    next if propose.size == 0 || propose.size == 4

    proposes[propose[0]] ||= [] of {Int32, Int32}
    proposes[propose[0]] << {x, y}
  end

  if i == 9
    xmin = state.min_of { |(x, _)| x }
    xmax = state.max_of { |(x, _)| x }

    ymin = state.min_of { |(_, y)| y }
    ymax = state.max_of { |(_, y)| y }

    puts (xmax - xmin + 1) * (ymax - ymin + 1) - state.size
  end

  moved = false

  proposes.each do |place, elves|
    next if elves.size > 1
    moved = true

    state << place
    state.delete(elves[0])
  end

  proposes.clear
  next if moved

  puts i + 1
  break
end
