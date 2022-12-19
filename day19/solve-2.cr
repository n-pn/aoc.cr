alias Quad = Tuple(Int32, Int32, Int32, Int32)

class Plan
  getter id : Int32
  getter costs : Tuple(Quad, Quad, Quad, Quad)

  def initialize(input : Array(Int32))
    @id = input[0]

    @costs = {
      {input[1], 0, 0, 0},
      {input[2], 0, 0, 0},
      {input[3], input[4], 0, 0},
      {input[5], 0, input[6], 0},
    }
  end

  @[AlwaysInline]
  def can_build?(type : Int32, stored : Quad)
    @costs[type].each_with_index.all? { |x, i| stored[i] >= x }
  end

  @[AlwaysInline]
  def build_robot!(type : Int32, robots : Quad, stored : Quad, time : Int32)
    robots_2 = robots.map_with_index { |r, i| i == type ? r + 1 : r }
    stored_2 = @costs[type].map_with_index { |c, i| stored[i] + robots[i] - c }

    # puts [robots_2, stored_2, time + 1]

    {robots_2, stored_2, time + 1}
  end

  def limits(max_time)
    {
      @costs.max_of(&.[0]),                  # max ore robots
      {@costs[2][1], max_time // 2 + 1}.min, # max clay robots
      {@costs[3][2], max_time // 2 + 1}.min, # max obsidian robots
      Int32::MAX,                            # max geoge robot
    }
  end
end

def max_geode(plan : Plan, max_time = 32)
  queue = [{ {1, 0, 0, 0}, {0, 0, 0, 0}, 0 }]
  seens = Hash({Quad, Quad}, Int32).new

  robot_limits = plan.limits(max_time)

  output = 0

  while entry = queue.pop?
    robots, stored, time = entry

    next if seens[{robots, stored}]?.try(&.<= time)
    seens[{robots, stored}] = time

    if time == max_time
      output = {output, robots[3]}.max
      next
    end

    if plan.can_build?(3, stored)
      queue << plan.build_robot!(3, robots, stored, time)
      next
    end

    if robots[2] < robot_limits[2] && plan.can_build?(2, stored)
      queue << plan.build_robot!(2, robots, stored, time)
      next
    end

    if robots[1] < robot_limits[1] && plan.can_build?(1, stored)
      queue << plan.build_robot!(1, robots, stored, time)
    end

    if robots[0] < robot_limits[0] && plan.can_build?(0, stored)
      queue << plan.build_robot!(0, robots, stored, time)
    end

    stored_2 = stored.map_with_index { |a, i| a + robots[i] }
    queue << {robots, stored_2, time + 1}
  end

  puts [plan.id, output]
  output
end

# input = {{ read_file("day19/test0.txt").strip }}
input = {{ read_file("day19/input.txt").strip }}

plans = input.lines.map { |line| Plan.new(line.scan(/\d+/).map(&.[0].to_i)) }
puts plans.sum { |plan| plan.id * max_geode(plan, 24) }
puts plans.first(3).product { |plan| max_geode(plan, 32) }
