class Plan
  getter id : Int32

  getter ore_robot_ore_cost : Int32
  getter clay_robot_ore_cost : Int32

  getter obsidian_robot_ore_cost : Int32
  getter obsidian_robot_clay_cost : Int32

  getter geode_robot_ore_cost : Int32
  getter geode_robot_obsidian_cost : Int32

  def initialize(input : Array(Int32))
    @id = input[0]

    @ore_robot_ore_cost = input[1]
    @clay_robot_ore_cost = input[2]

    @obsidian_robot_ore_cost = input[3]
    @obsidian_robot_clay_cost = input[4]

    @geode_robot_ore_cost = input[5]
    @geode_robot_obsidian_cost = input[6]
  end
end

struct State
  property ore_count : Int32 = 0
  property clay_count : Int32 = 0
  property obsidian_count : Int32 = 0
  property geode_count : Int32 = 0

  property ore_robots : Int32 = 1
  property clay_robots : Int32 = 0
  property obsidian_robots : Int32 = 0
  property geode_robots : Int32 = 0

  def initialize(@ore_count = 0, @clay_count = 0, @obsidian_count = 0, @geode_count = 0,
                 @ore_robots = 1, @clay_robots = 0, @obsidian_robots = 0, @geode_robots = 0)
  end

  def collect!
    res = self.dup

    res.ore_count += res.ore_robots
    res.clay_count += res.clay_robots
    res.obsidian_count += res.obsidian_robots
    res.geode_count += res.geode_robots

    res
  end

  def make_ore_robot(blueprint : Plan)
    res = self.collect!

    res.ore_robots += 1
    res.ore_count -= blueprint.ore_robot_ore_cost

    res
  end

  def make_clay_robot(blueprint : Plan)
    res = self.collect!

    res.clay_robots += 1
    res.ore_count -= blueprint.clay_robot_ore_cost

    res
  end

  def make_obsidian_robot(blueprint : Plan)
    return if @ore_count < blueprint.obsidian_robot_ore_cost || @clay_count < blueprint.obsidian_robot_clay_cost

    res = self.collect!

    res.obsidian_robots += 1
    res.ore_count -= blueprint.obsidian_robot_ore_cost
    res.clay_count -= blueprint.obsidian_robot_clay_cost

    res
  end

  def make_geode_robot(blueprint : Plan)
    return if @ore_count < blueprint.geode_robot_ore_cost || @obsidian_count < blueprint.geode_robot_obsidian_cost

    res = self.collect!

    res.geode_robots += 1
    res.ore_count -= blueprint.geode_robot_ore_cost
    res.obsidian_count -= blueprint.geode_robot_obsidian_cost

    res
  end
end

def max_geode(plan : Plan, limit = 32)
  queue = [{State.new, 0}]
  max = 0

  seens = Hash(State, Int32).new

  ore_robot_limit = {plan.clay_robot_ore_cost, plan.obsidian_robot_ore_cost, plan.geode_robot_ore_cost}.max
  clay_robot_limit = plan.obsidian_robot_clay_cost

  while entry = queue.pop?
    state, minute = entry

    next if seens[state]?.try(&.<= minute)
    seens[state] = minute

    if minute == limit
      max = state.geode_count if max < state.geode_count
      next
    end

    next if state.make_geode_robot(plan).try { |s| queue << {s, minute + 1} }

    if state.obsidian_robots < plan.geode_robot_obsidian_cost
      next if state.make_obsidian_robot(plan).try { |s| queue << {s, minute + 1} }
    end

    if state.clay_robots < clay_robot_limit && state.ore_count >= plan.clay_robot_ore_cost
      queue << {state.make_clay_robot(plan), minute + 1}
    end

    if state.ore_robots < ore_robot_limit && state.ore_count >= plan.ore_robot_ore_cost
      queue << {state.make_ore_robot(plan), minute + 1}
    end

    queue << {state.collect!, minute + 1}
  end

  # puts [plan.id, max]
  max
end

# input = {{ read_file("day19/test0.txt").strip }}
input = {{ read_file("day19/input.txt").strip }}

plans = input.lines.map { |line| Plan.new(line.scan(/\d+/).map(&.[0].to_i)) }
puts plans.sum { |plan| plan.id * max_geode(plan, 24) }
puts plans.first(3).product { |plan| max_geode(plan, 32) }
