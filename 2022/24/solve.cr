# input = {{ read_file("2022/24/test0.txt").strip }}.lines
input = {{ read_file("2022/24/input.txt").strip }}.lines

DIRS = {'v' => {1, 0}, '>' => {0, 1}, '^' => {-1, 0}, '<' => {0, -1}}

xmax = input.size - 2
ymax = input[0].size - 2

alias Pair = Tuple(Int32, Int32)
alias State = Hash(Pair, Array(Pair))

states = [State.new]

input.each_with_index do |line, x|
  line.chars.each_with_index do |char, y|
    states.last[{x - 1, y - 1}] = [DIRS[char]] unless char.in?('.', '#')
  end
end

2.to(xmax.lcm(ymax)) do
  state = State.new { |h, k| h[k] = [] of Pair }

  states.last.each do |(x, y), bv|
    bv.each do |(vx, vy)|
      state[{(x + vx) % xmax, (y + vy) % ymax}] << {vx, vy}
    end
  end

  states << state
end

def travel(states, xmax, ymax, start, goal, step : Int32 = 0)
  queue = [start]
  next_queue = [] of {Int32, Int32}

  # visited = Set(Int32).new
  visited = Set({Int32, Int32, Int32}).new

  while !queue.empty?
    step += 1
    state = states[step % states.size]
    next_queue = [] of {Int32, Int32}

    queue.each do |x, y|
      next if visited.includes?({step, x, y})
      visited << {step, x, y}

      next_queue << {x, y} unless state.has_key?({x, y})

      DIRS.each_value do |(dx, dy)|
        nx, ny = x + dx, y + dy
        return step if {nx, ny} == goal

        next unless nx.in?(0...xmax) && ny.in?(0...ymax)
        next_queue << {nx, ny} unless state.has_key?({nx, ny})
      end

      queue = next_queue
    end
  end

  raise "path not found!"
end

start, goal = {-1, 0}, {xmax, ymax - 1}
routes = { {start, goal}, {goal, start}, {start, goal} }

steps = routes.accumulate(0) { |step, (start, goal)| travel(states, xmax, ymax, start, goal, step) }
puts steps[1], steps[3]
