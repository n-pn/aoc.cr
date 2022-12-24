require "complex"
# input = {{ read_file("2022/24/test0.txt").strip }}.lines
input = {{ read_file("2022/24/input.txt").strip }}.lines

struct Complex
  def mod(xmax, ymax)
    Complex.new(@real % xmax, @imag % ymax)
  end
end

DIRS = {'v' => Complex.new(1, 0), '>' => Complex.new(0, 1), '^' => Complex.new(-1, 0), '<' => Complex.new(0, -1)}

xmax = input.size - 2
ymax = input[0].size - 2

blocks = [] of {Complex, Complex}

input.each_with_index do |line, x|
  line.chars.each_with_index do |char, y|
    blocks << {Complex.new(x - 1, y - 1), DIRS[char]} unless char.in?('.', '#')
  end
end

def travel(blocks, xmax, ymax, start, goal, step : Int32 = 0)
  queue = [start].to_set
  next_queue = Set(Complex).new

  while !queue.empty?
    step += 1
    blocked = blocks.map { |(x, v)| (x + v * step).mod(xmax, ymax) }.to_set

    queue.each do |cx|
      next_queue << cx unless blocked.includes?(cx)

      DIRS.each_value do |vx|
        nx = cx + vx

        if 0 <= nx.real < xmax && 0 <= nx.imag < ymax
          next_queue << nx unless blocked.includes?(nx)
        elsif nx == goal
          return step
        end
      end
    end

    queue, next_queue = next_queue, queue
    next_queue.clear
  end

  raise "path not found!"
end

start, goal = Complex.new(-1, 0), Complex.new(xmax, ymax - 1)
routes = { {start, goal}, {goal, start}, {start, goal} }

steps = routes.accumulate(0) { |step, (start, goal)| travel(blocks, xmax, ymax, start, goal, step) }
puts steps[1], steps[3]
