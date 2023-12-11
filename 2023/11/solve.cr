input = File.read("#{__DIR__}/input.txt").strip.lines

test1 = <<-TXT.lines
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
TXT

def solve(input, zoom = 2)
  data = [] of {Int32, Int32}
  rows = Set(Int32).new
  cols = Set(Int32).new

  input.each_with_index do |line, x|
    line.each_char.with_index do |char, y|
      next unless char == '#'
      data << {x, y}
      rows << x
      cols << y
    end
  end

  data[..-2].each_with_index.sum(0_i64) do |(ax, ay), i|
    data[i + 1..].sum(0_i64) do |(bx, by)|
      ex = ax.to(bx).count(&.in?(rows).!)
      ey = ay.to(by).count(&.in?(cols).!)
      (ax - bx).abs + (ay - by).abs + ex * (zoom - 1) + ey * (zoom - 1)
    end
  end
end

time = Time.measure do
  puts "p1: #{solve(input, 2)}" if solve(test1, 2) == 374
  puts "p2: #{solve(input, 1000000)}" if solve(test1, 10) == 1030
end

puts time.total_milliseconds
