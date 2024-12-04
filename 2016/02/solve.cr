require "colorize"

def solve(input, map, x = 1, y = 1)
  moves = {'R' => {0, 1}, 'D' => {1, 0}, 'L' => {0, -1}, 'U' => {-1, 0}}

  input.join do |line|
    line.each_char do |c|
      nx, ny = x + moves[c][0], y + moves[c][1]
      x, y = nx, ny if map[nx][ny] != '.'
    end
    map[x][y]
  end
end

map_1 = <<-TXT.lines
.....
.123.
.456.
.789.
.....
TXT

map_2 = <<-TXT.lines
.......
...1...
..234..
.56789.
..ABC..
...D...
.......
TXT

input = File.read("#{__DIR__}/input.txt").strip.lines
puts solve(input, map_1, 2, 2)
puts solve(input, map_2, 3, 1)
