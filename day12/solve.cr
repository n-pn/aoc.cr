# input = File.read("day12/test0.txt").strip
input = File.read("day12/input.txt").strip

def solve(map, queue, reach = 'S')
  steps = 0
  moves = { {0, -1}, {0, 1}, {-1, 0}, {1, 0} }

  while !queue.empty?
    steps += 1
    next_queue = [] of {Int32, Int32}

    queue.each do |(i, j)|
      c = map[i][j]
      map[i][j] = '.'

      moves.each do |(a, b)|
        x, y = i + a, j + b

        d = map[x][y]
        next if d == '.'

        if d == reach
          return steps if c.in?('a', 'b')
        elsif c - d < 2
          next_queue << {x, y}
        end
      end
    end

    queue = next_queue.uniq!
  end
end

map = input.lines.map { |x| ['.'].concat(x.chars).tap(&.push('.')) }
map.unshift Array(Char).new(map.first.size, '.')
map << Array(Char).new(map.first.size, '.')

s_x = map.index!(&.includes?('E'))
s_y = map[s_x].index!('E')

map[s_x][s_y] = 'z'
queue = [{s_x, s_y}]

puts solve(map.clone, queue, 'S')
puts solve(map, queue, 'a')
