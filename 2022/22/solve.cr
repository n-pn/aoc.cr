#########
#   A B #
#   C   #
# E D   #
# F     #
#########

# 0: right, 1: bottom, 2: left, 3: top

WRAP_1 = {} of {Int32, Int32, Int32} => {Int32, Int32, Int32}
WRAP_2 = {} of {Int32, Int32, Int32} => {Int32, Int32, Int32}

50.times do |i|
  WRAP_1[{i, 50, 2}] = {i, 149, 2}          # A-2
  WRAP_1[{0, i + 50, 3}] = {149, i + 50, 3} # A-3

  WRAP_1[{i, 149, 0}] = {i, 50, 0}           # B-0
  WRAP_1[{49, i + 100, 1}] = {0, i + 100, 1} # B-1
  WRAP_1[{0, i + 100, 3}] = {49, i + 100, 3} # B-3

  WRAP_1[{i + 50, 99, 0}] = {i + 50, 50, 0} # C-0
  WRAP_1[{i + 50, 50, 2}] = {i + 50, 99, 2} # C-2

  WRAP_1[{i + 100, 99, 0}] = {i + 100, 0, 0} # D-0
  WRAP_1[{149, i + 50, 1}] = {0, i + 50, 1}  # D-1

  WRAP_1[{i + 100, 0, 2}] = {i + 100, 99, 2} # E-2
  WRAP_1[{100, i, 3}] = {199, i, 3}          # E-3

  WRAP_1[{i + 150, 49, 0}] = {i + 150, 0, 0} # F-0
  WRAP_1[{199, i, 1}] = {100, i, 1}          # F-1
  WRAP_1[{i + 150, 0, 2}] = {i + 150, 49, 2} # F-2

  # part 2
  WRAP_2[{i, 50, 2}] = {149 - i, 0, 0}      # A-2 => E-2
  WRAP_2[{i + 100, 0, 2}] = {49 - i, 50, 0} # E-2 => A-2

  WRAP_2[{0, i + 50, 3}] = {i + 150, 0, 0} # A-3 => F-2
  WRAP_2[{i + 150, 0, 2}] = {0, i + 50, 1} # F-2 => A-3

  WRAP_2[{i, 149, 0}] = {149 - i, 99, 2}      # B-0 => D-0
  WRAP_2[{i + 100, 99, 0}] = {49 - i, 149, 2} # D-0 => B-0

  WRAP_2[{49, i + 100, 1}] = {i + 50, 99, 2} # B-1 => C-0
  WRAP_2[{i + 50, 99, 0}] = {49, i + 100, 3} # C-0 => B-1

  WRAP_2[{0, i + 100, 3}] = {199, i, 3} # B-3 => F-1
  WRAP_2[{199, i, 1}] = {0, i + 100, 1} # F-1 => B-3

  WRAP_2[{i + 50, 50, 2}] = {100, i, 1} # C-2 => E-3
  WRAP_2[{100, i, 3}] = {i + 50, 50, 0} # E-3 => C-2

  WRAP_2[{149, i + 50, 1}] = {i + 150, 49, 2} # D-1 => F-0
  WRAP_2[{i + 150, 49, 0}] = {149, i + 50, 3} # F-0 => D-1
end

DIRS = { {0, 1}, {1, 0}, {0, -1}, {-1, 0} } # >, v, <, ^

# input = {{ read_file("2022/22/test0.txt") }}
input = {{ read_file("2022/22/input.txt") }}

maze, path = input.split("\n\n")
maze = maze.lines.map(&.chars)
path = path.split(/(L|R)/).map { |x| x.to_i? || x }

{WRAP_1, WRAP_2}.each do |wrap|
  dir, x, y = 0, 0, maze[0].index!('.')

  path.each do |n|
    case n
    when "L" then dir = (dir - 1) % 4
    when "R" then dir = (dir + 1) % 4
    when Int32
      n.times do
        nx, ny, ndir = wrap[{x, y, dir}]? || begin
          dx, dy = DIRS[dir]
          {x + dx, y + dy, dir}
        end

        break if maze[nx][ny] == '#'
        x, y, dir = nx, ny, ndir
      end
    end
  end

  puts (x + 1) * 1000 + (y + 1) * 4 + dir
end
