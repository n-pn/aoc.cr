input = File.read("#{__DIR__}/input.txt").strip

test1 = <<-TXT
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
TXT

test2 = <<-TXT
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
TXT

def parse(text)
  ins, map = text.split("\n\n")
  ins = ins.chars.map { |c| c == 'L' ? 0 : 1 }
  map = map.lines.to_h { |l| a, b, c = l.scan(/\w+/).map(&.[0]); {a, {b, c}} }
  {ins, map}
end

def solve(ins, map, node)
  step = 0_i64

  ins.cycle do |i|
    node = map[node][i]
    step += 1
    break step if yield node
  end
end

def part1(text)
  ins, map = parse(text)
  solve(ins, map, "AAA", &.== "ZZZ")
end

def part2(text)
  ins, map = parse(text)
  map.each_key.select(&.ends_with?('A')).map { |n| solve(ins, map, n, &.ends_with?('Z')) }.reduce { |x, y| x.lcm(y) }
end

puts "part 1: #{part1(input)}" if part1(test1) == 2
puts "part 2: #{part2(input)}" if part2(test2) == 6
