input = File.read("#{__DIR__}/input.txt").strip.lines

test1 = <<-TXT.strip.lines
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
TXT

struct Hand
  def initialize(cards : String)
    @cards = cards.chars
    @tally = @cards.tally
  end

  def has?(c)
    @tally.any?(&.[1].== c)
  end

  def has32?
    has?(3) && has?(2)
  end

  def has22?
    @tally.count(&.[1].== 2) == 2
  end

  include Comparable(self)

  class_property ranking = "AKQJT98765432".chars

  def rank(i)
    @@ranking.index!(@cards[i])
  end

  def <=>(other : self)
    high = 5.times do |i|
      h = other.rank(i) <=> rank(i)
      break h unless h == 0
    end

    case
    when self.has?(5)  then other.has?(5) ? high : 1
    when other.has?(5) then -1
    when self.has?(4)  then other.has?(4) ? high : 1
    when other.has?(4) then -1
    when self.has32?   then other.has32? ? high : 1
    when other.has32?  then -1
    when self.has?(3)  then other.has?(3) ? high : 1
    when other.has?(3) then -1
    when self.has22?   then other.has22? ? high : 1
    when other.has22?  then -1
    when self.has?(2)  then other.has?(2) ? high : 1
    when other.has?(2) then -1
    else                    high
    end
  end

  def use_joker!
    return unless t = @tally['J']?

    4.downto(1) do |x|
      @tally.each do |k, v|
        next if k == 'J' || v != x

        @tally[k] += t
        @tally['J'] = 0

        return
      end
    end
  end

  def inspect(io : IO) : Nil
    @cards.join(io)
  end
end

def solve(text, use_joker = false)
  data = text.map do |line|
    cards, bid = line.split ' ', 2
    hand = Hand.new(cards)
    hand.use_joker! if use_joker
    {hand, bid.to_i}
  end

  data.sort!.map_with_index(1) { |(_, bid), i| bid * i }.sum
end

if solve(test1) == 6440
  puts solve(input)
end

Hand.ranking = "AKQT98765432J".chars

if solve(test1, true) == 5905
  puts solve(input, true)
end
