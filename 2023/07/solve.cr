input = File.read("#{__DIR__}/input.txt").strip.lines

test1 = <<-TXT.strip.lines
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
TXT

struct Hand
  getter bid = 0, value = 0, cards : Array(Char)

  def initialize(line : String, ranking, use_joker = false)
    cards, bid = line.split
    @cards, @bid = cards.chars, bid.to_i

    @tally = @cards.tally
    self.use_joker! if use_joker && @tally['J']? != 5

    @cards.each { |c| @value = @value * ranking.size + ranking.index!(c) }
    (2..5).each { |x| @value += @tally.values.count(x) * 1_000_000 * x * x }
  end

  def use_joker! : Nil
    k = @tally.to_a.select(&.[0].!= 'J').max_by(&.[1]).first
    @tally[k] += @tally.delete('J') || 0
  end
end

def solve(text, ranking, use_joker = false)
  data = text.map { |line| Hand.new(line, ranking, use_joker) }
  data.sort_by!(&.value).map_with_index(1) { |c, i| c.bid * i }.sum
end

ranking = "AKQJT98765432".chars.reverse!
if solve(test1, ranking) == 6440
  puts solve(input, ranking)
end

ranking = "AKQT98765432J".chars.reverse!
if solve(test1, ranking, true) == 5905
  puts solve(input, ranking, true)
end
