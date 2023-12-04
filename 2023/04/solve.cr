input = File.read("#{__DIR__}/input.txt").strip.lines

test1 = <<-TXT.lines
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
TXT

def parse(text)
  text.map(&.split(/[:|]/).tap(&.shift).map(&.split.to_set).reduce { |a, b| a & b }.size)
end

def part1(data)
  data.sum(0) { |x| x > 0 ? 2 ** (x - 1) : 0 }
end

def part2(data)
  cards = Array.new(data.size, 1)
  # cards.each_with_index { |c, i| data[i].times { |j| cards[i + j + 1] += c } }
  data.each_with_index { |c, i| 1.upto(c) { |j| cards[i + j] += cards[i] } }
  cards.first(data.size).sum
end

puts part1(parse(test1)) == 13
puts part1(parse(input))

puts part2(parse(test1)) == 30
puts part2(parse(input))
