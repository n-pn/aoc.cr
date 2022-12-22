input = {{ read_file("2022/22/test0.txt") }}
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

#  top a -
(50..99).each { |i| wraps[{0, i, 3}] = {100 + i, 0, 0} }
# left a -
(0..49).each { |i| wraps[{i, 50, 2}] = {149 - i, 0, 0} }

# top b -
(100..149).each { |i| wraps[{0, i, 3}] = {199, i - 100, 3} }
# right b -
(0..49).each { |i| wraps[{i, 149, 0}] = {149 - i, 99, 2} }
# bottom b -
(100..149).each { |i| wraps[{49, i, 1}] = {i - 50, 99, 2} }

# right c -
(50..99).each { |i| wraps[{i, 99, 0}] = {49, i + 50, 3} }
# left c -
(50..99).each { |i| wraps[{i, 50, 2}] = {100, i - 50, 1} }

# right d -
(100..149).each { |i| wraps[{i, 99, 0}] = {149 - i, 149, 2} }
# bottom d -
(50..99).each { |i| wraps[{149, i, 1}] = {i + 100, 49, 2} }

# top e -
(0..49).each { |i| wraps[{100, i, 3}] = {i + 50, 50, 0} }
# left e -
(100..149).each { |i| wraps[{i, 0, 2}] = {149 - i, 50, 0} }

# right f -
(150..199).each { |i| wraps[{i, 49, 0}] = {149, i - 100, 3} }
# bottom f -
(0..49).each { |i| wraps[{199, i, 1}] = {0, i + 100, 1} }
# left f
(150..199).each { |i| wraps[{i, 0, 2}] = {0, i - 100, 1} }

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
        # puts [[x, y, dir], [nx, ny, ndir]]
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
