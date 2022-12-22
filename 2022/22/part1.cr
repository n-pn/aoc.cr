input = {{ read_file("2022/22/input.txt") }}

map, ins = input.split("\n\n")
map = map.lines.map(&.chars)
ins = parse_ins(ins)

def parse_ins(ins)
  res = [] of Char | Int32
  acc = 0
  ins.each_char do |char|
    if char.in?('0'..'9')
      acc = acc * 10 + (char - '0')
    else
      res << acc if acc > 0
      res << char
      acc = 0
    end
  end

  res << acc if acc > 0
  res
end

# >, v, <, ^
DIRS = { {0, 1}, {1, 0}, {0, -1}, {-1, 0} }

wraps = {} of {Int32, Int32, Int32} => {Int32, Int32, Int32}

#########
#   A B #
#   C   #
# E D   #
# F     #
#########

50.times do |i|
  wraps[{0, i + 50, 3}] = {149, i + 50, 3}  # A-3 => F-2
  wraps[{i + 150, 0, 2}] = {i + 150, 49, 2} # F-2 => A-3

  wraps[{i, 50, 2}] = {i, 149, 2} # A-2 => E-2

end

# top b -
(100..149).each { |i| wraps[{0, i, 3}] = {49, i, 3} }
# right b -
(0..49).each { |i| wraps[{i, 149, 0}] = {i, 50, 0} }
# bottom b -
(100..149).each { |i| wraps[{49, i, 1}] = {0, i, 1} }

# right c -
(50..99).each { |i| wraps[{i, 99, 0}] = {i, 50, 0} }
# left c -
(50..99).each { |i| wraps[{i, 50, 2}] = {i, 99, 2} }

# right d -
(100..149).each { |i| wraps[{i, 99, 0}] = {i, 0, 0} }
# bottom d -
(50..99).each { |i| wraps[{149, i, 1}] = {0, i, 1} }

# top e -
(0..49).each { |i| wraps[{100, i, 3}] = {199, i, 3} }
# left e -
(100..149).each { |i| wraps[{i, 0, 2}] = {i, 99, 2} }

# right f -
(150..199).each { |i| wraps[{i, 49, 0}] = {i, 0, 0} }
# bottom f -
(0..49).each { |i| wraps[{199, i, 1}] = {100, i, 1} }

x = 0
y = map[0].index!('.')
dir = 0

ins.each do |curr|
  case curr
  when 'L' then dir = (dir - 1) % 4
  when 'R' then dir = (dir + 1) % 4
  when Int32
    curr.times do
      if wrap = wraps[{x, y, dir}]?
        nx, ny, ndir = wrap
      else
        dx, dy = DIRS[dir]
        nx, ny, ndir = x + dx, y + dy, dir
      end

      break if map[nx][ny] == '#'
      x, y, dir = nx, ny, ndir
    end
  end
end

puts (x + 1) * 1000 + (y + 1) * 4 + dir
