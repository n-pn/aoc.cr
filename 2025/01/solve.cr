input = File.read("#{__DIR__}/input.txt").strip.lines

test0 = <<-TXT.strip.lines
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
TXT

def part1(input : Array(String), start = 50)
  input.reduce(0) do |count, line|
    steps = line[1..].to_i
    steps = -steps if line[0] == 'L'
    start = (start + steps) % 100
    start == 0 ? count + 1 : count
  end
end

def part2(input : Array(String))
  start = 50
  count = 0

  input.each do |line|
    steps = line[1..-1].to_i

    count += steps // 100
    steps %= 100
    next if steps == 0

    case line[0]
    when 'L'
      count += 1 if start == steps || (start > 0 && start < steps)
      start = (start - steps) % 100
    when 'R'
      count += 1 if start + steps >= 100
      start = (start + steps) % 100
    end
    # puts [line, start, count]
  end

  count
end

answer1 = 3
answer2 = 6

if part1(test0) == answer1
  puts "part 1: #{part1(input)}".colorize.yellow
else
  puts "part 1: expected: #{answer1}, actual: #{part1(test0)}"
end

if part2(test0) == answer2
  puts "part 2: #{part2(input)}".colorize.yellow
else
  puts "part 2: expected: #{answer2}, actual: #{part2(test0)}"
end
