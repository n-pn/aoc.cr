# input = {{ read_file("2022/23/test1.txt").strip }}
input = {{ read_file("2022/23/input.txt").strip }}

sides = {
  { {-1, -1}, {-1, 0}, {-1, 1} }, # north
  { {1, -1}, {1, 0}, {1, 1} },    # south

  { {-1, -1}, {0, -1}, {1, -1} }, # west
  { {-1, 1}, {0, 1}, {1, 1} },    # east
}

elf_place = Set({Int32, Int32}).new
input.each_line.with_index { |line, i| line.each_char.with_index { |v, j| elf_place << {i, j} if v == '#' } }

proposes = Hash({Int32, Int32}, Array({Int32, Int32})).new

p1 = 0

p2 = (0..).each do |i|
  elf_place.each do |(x, y)|
    propose = [] of {Int32, Int32}

    4.times do |j|
      array = sides[(i + j) % 4].map { |(dx, dy)| {x + dx, y + dy} }
      propose << array[1] unless array.any?(&.in?(elf_place))
    end

    next if propose.size == 0 || propose.size == 4

    proposes[propose[0]] ||= [] of {Int32, Int32}
    proposes[propose[0]] << {x, y}
  end

  if i == 9
    xmin = elf_place.min_of { |(x, _)| x }
    xmax = elf_place.max_of { |(x, _)| x }

    ymin = elf_place.min_of { |(_, y)| y }
    ymax = elf_place.max_of { |(_, y)| y }

    p1 = (xmax - xmin + 1) * (ymax - ymin + 1) - elf_place.size
  end

  moved = false

  proposes.each do |place, elves|
    next if elves.size > 1
    moved = true

    elf_place << place
    elf_place.delete(elves[0])
  end

  proposes.clear
  break i + 1 unless moved
end

puts p1, p2
