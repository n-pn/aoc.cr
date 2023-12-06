input = File.read("#{__DIR__}/input.txt").strip

test1 = <<-TXT
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
TXT

def parse(input)
  seeds, *maps_list_input = input.split(/\n\n/)
  seeds = seeds.split.tap(&.shift).map(&.to_i64)

  maps_list = [] of Array({Int64, Int64, Int64})

  maps_list_input.each do |map|
    map_data = map.lines.tap(&.shift).map(&.split.map(&.to_i64))
    maps_list << map_data.map { |a| {a[1], a[1] + a[2] - 1, a[0] - a[1]} }
  end

  {seeds, maps_list}
end

def solve(init_range, maps_list)
  maps_list.each do |ranges|
    next_range = [] of {Int64, Int64}

    init_range.each do |ia, ib|
      unless found = ranges.find { |ra, rb, _| ia.in?(ra..rb) || ra.in?(ia..ib) }
        next_range << {ia, ib}
        next
      end

      ra, rb, diff = found

      case
      when ia >= ra && ib <= rb
        next_range << {ia + diff, ib + diff}
      when ia < ra && ib > rb
        next_range << {ia, ra - 1}
        next_range << {ra + diff, rb + diff}
        init_range << {rb + 1, ib}
      when ia >= ra && ib > rb
        next_range << {ia + diff, rb + diff}
        init_range << {rb + 1, ib}
      when ia < ra && ib <= rb
        next_range << {ia, ra - 1}
        next_range << {ra + diff, ib + diff}
      end
    end

    init_range = next_range
  end

  init_range.min_of(&.[0])
end

def part1(input)
  seeds, map_range = parse(input)

  input = seeds.map { |x| {x, x} }
  solve input, map_range
end

def part2(input)
  seeds, map_range = parse(input)
  input = seeds.each_slice(2).map { |x| {x[0], x[0] + x[1] - 1} }.to_a
  solve input, map_range
end

puts part1(test1) == 35
puts part1(input)

puts part2(test1) == 46
puts part2(input)
