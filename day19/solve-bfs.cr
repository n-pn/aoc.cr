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
  def can_build?(type : Int32, stored : Quad) : Bool
    @costs[type].each_with_index.all? { |c, i| stored[i] >= c }
  end

  @[AlwaysInline]
  def build_robot!(type : Int32, robots : Quad, stored : Quad)
    robots_2 = robots.map_with_index { |r, i| i == type ? r + 1 : r }
    stored_2 = @costs[type].map_with_index { |c, i| stored[i] + robots[i] - c }
    {robots_2, stored_2}
  end
end

def max_geode(plan : Plan, max_time = 32)
  queue = [{ {1, 0, 0, 0}, {0, 0, 0, 0} }]
  seens = Set({Quad, Quad}).new

  robot_limits = {
    plan.costs.max_of(&.[0]),              # max ore robots
    {plan.costs[2][1], max_time // 2}.min, # max clay robots
    {plan.costs[3][2], max_time // 2}.min, # max obsidian robots
    Int32::MAX,                            # max geoge robot
  }

  max_time.times do
    new_queue = [] of {Quad, Quad}

    queue.each do |(robots, stored)|
      next if seens.includes?({robots, stored})
      seens << {robots, stored}

      # build geode robot
      if plan.can_build?(3, stored)
        new_queue << plan.build_robot!(3, robots, stored)
        next
      end

      # build obsidian robot
      if robots[2] < robot_limits[2] && plan.can_build?(2, stored)
        new_queue << plan.build_robot!(2, robots, stored)
        next
      end

      # build clay robot
      if robots[1] < robot_limits[1] && plan.can_build?(1, stored)
        new_queue << plan.build_robot!(1, robots, stored)
      end

      # build ore robot
      if robots[0] < robot_limits[0] && plan.can_build?(0, stored)
        new_queue << plan.build_robot!(0, robots, stored)
      end

      # do not build any robot
      stored_2 = stored.map_with_index { |a, i| a + robots[i] }
      new_queue << {robots, stored_2}
    end

    queue = new_queue
  end

  queue.max_of(&.[1][3])
end

# input = {{ read_file("day19/test0.txt").strip }}
input = {{ read_file("day19/input.txt").strip }}

plans = input.lines.map { |line| Plan.new(line.scan(/\d+/).map(&.[0].to_i)) }
puts plans.sum { |plan| plan.id * max_geode(plan, 24) }
puts plans.first(3).product { |plan| max_geode(plan, 32) }
