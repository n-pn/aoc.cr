input = <<-TEST
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
TEST

input = File.read("day16/input.txt").strip

COSTS = {} of UInt32 => Int32
RATES = Array(Int32).new(60, 0)

DISTS = Hash(Int32, Hash(Int32, Int32)).new { |h, k| h[k] = Hash(Int32, Int32).new Int32::MAX // 2 }
INDEX = Hash(String, Int32).new { |h, k| h[k] = h.size }

def cost_of(valve : Int32, remain : Int32, opened : UInt32, count = 15)
  COSTS[opened | valve.unsafe_shl(count + 1) | remain.unsafe_shl(count + 8)] ||= begin
    base = rate_of(opened, count)

    DISTS[valve].max_of do |new_valve, dist|
      index = 1.unsafe_shl(new_valve)
      next base * remain if (opened & index != 0) || RATES[new_valve] == 0

      new_remain = remain - dist - 1
      new_remain <= 0 ? base * remain : base * (dist + 1) + cost_of(new_valve, new_remain, opened | index)
    end
  end
end

def rate_of(opened, count)
  count.times.sum { |val| 0 != 1.unsafe_shl(val) & opened ? RATES[val] : 0 }
end

REGEX = /^Valve (\w+) .+=(\d+).+valves? (.+)$/

array = input.lines.map do |line|
  _, valve, rate, valves = line.match(REGEX).not_nil!
  {rate.to_i, valve, valves.split(", ")}
end

array.sort_by!(&.[0].-)
array.each { |(_, valve, _)| RATES[INDEX[valve]] = 0 }

array.each do |rate, valve, neigs|
  v_int = INDEX[valve]
  RATES[v_int] = rate
  neigs.each { |neig| DISTS[v_int][INDEX[neig]] = 1 }
end

INDEX.each_value { |a| DISTS[a][a] = 0 }
count = RATES.count { |r| r > 0 }

INDEX.size.times do |m|
  INDEX.size.times do |x|
    INDEX.size.times do |y|
      dist = DISTS[x][m] + DISTS[m][y]
      DISTS[x][y] = dist if dist < DISTS[x][y]
    end
  end
end

start = INDEX["AA"]
puts cost_of(start, 30, 0_u32, count)

p2 = (0_u32..1_u32.unsafe_shl(count) - 1).max_of do |opened|
  opened = opened.to_u32
  reverse = opened ^ (1.unsafe_shl(count) - 1)

  cost = cost_of(start, 26, opened) + cost_of(start, 26, reverse)
  cost -= rate_of(opened, count) * 26 + rate_of(reverse, count) * 26
  cost
end

puts p2
