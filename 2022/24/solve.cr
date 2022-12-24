# input = {{ read_file("2022/24/test0.txt").strip }}.lines
input = {{ read_file("2022/24/input.txt").strip }}.lines

DIRS = {'v' => {1, 0}, '>' => {0, 1}, '^' => {-1, 0}, '<' => {0, -1}}

xmax = input.size - 2
ymax = input[0].size - 2

alias Pair = Tuple(Int32, Int32)
alias State = Array({Int32, Int32, Int32, Int32})

blocks = [] of {Int32, Int32, Int32, Int32}

input.each_with_index do |line, x|
  line.chars.each_with_index do |char, y|
    blocks << {x - 1, y - 1, DIRS[char][0], DIRS[char][1]} unless char.in?('.', '#')
  end
end

def travel(blocks, xmax, ymax, start, goal, step : Int32 = 0)
  queue = [start].to_set
  next_queue = Set({Int32, Int32}).new

  while !queue.empty?
    step += 1

    blocked = blocks.map { |(x, y, vx, vy)| {(x + vx * step) % xmax, (y + vy * step) % ymax} }.to_set

    queue.each do |x, y|
      next_queue << {x, y} unless blocked.includes?({x, y})

      DIRS.each_value do |(dx, dy)|
        nx, ny = x + dx, y + dy

        if 0 <= nx < xmax && 0 <= ny < ymax
          next_queue << {nx, ny} unless blocked.includes?({nx, ny})
        elsif {nx, ny} == goal
          return step
        end
      end
    end

    queue, next_queue = next_queue, queue
    next_queue.clear
  end

  raise "path not found!"
end

start, goal = {-1, 0}, {xmax, ymax - 1}
routes = { {start, goal}, {goal, start}, {start, goal} }

steps = routes.accumulate(0) { |step, (start, goal)| travel(blocks, xmax, ymax, start, goal, step) }
puts steps[1], steps[3]
