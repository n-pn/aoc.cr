input = File.read("#{__DIR__}/input.txt")

test1 = <<-TXT
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
TXT

def mirror_1?(data, x)
  data.each do |line|
    (x + 1).times do |i|
      a, b = x - i, x + i
      break if a < 0 || b >= line.size
      return false if line[a] != line[b]
    end
  end

  # puts data.map(&.join).join('\n'), [1, x]
  true
end

def mirror_2?(data, x)
  data.each do |line|
    (x + 1).times do |i|
      a, b = x - i, x + i + 1
      break if a < 0 || b >= line.size
      return false if line[a] != line[b]
    end
  end

  # puts data.map(&.join).join('\n'), [2, x]
  true
end

def solve(data, multi)
  1.upto(data.first.size - 2) do |x|
    return x * multi if mirror_1?(data, x)
  end

  1.upto(data.first.size - 3) do |x|
    return (x + 1) * multi if mirror_2?(data, x)
  end

  0
end

def part1(text)
  data = text.split("\n\n").map(&.lines.map(&.chars))

  data.sum(0) do |map|
    x = solve(map, 1) + solve(map.transpose, 100)
    puts map if x == 0
    x
  end
end

def part2(text)
  data = parse(text)
end

puts "part 1: #{part1(input)}" if part1(test1) == 405
# puts "part 2: #{part2(input)}"  if part2(test1) == 525152
