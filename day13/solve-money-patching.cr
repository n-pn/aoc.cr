# input = File.read("day13/test0.txt").strip
input = File.read("day13/input.txt").strip

class Arr
  @arr = [] of Arr | Int32
  forward_missing_to @arr

  include Comparable(Int32 | Arr)

  def <=>(other : Arr | Int32)
    other = Arr.from(other) if other.is_a?(Int32)

    each_with_index do |a, i|
      return 1 unless b = other[i]?
      c = a <=> b
      return c unless c == 0
    end

    size <=> other.size
  end

  def self.from(x : Int32)
    new.tap(&.<< x)
  end

  def self.parse(input : String)
    parse_iter(input.each_char)[0].as(Arr)
  end

  def self.parse_iter(iter)
    res = Arr.new
    acc = nil

    iter.each do |char|
      case char
      when '[' then res << parse_iter(iter)
      when ']' then break
      when ','
        res << acc if acc
        acc = nil
      else
        acc = char - '0' + (acc ? acc * 10 : 0)
      end
    end

    res << acc if acc
    res
  end
end

struct Int32
  include Comparable(Arr)

  def <=>(other : Arr)
    Arr.from(self) <=> other
  end
end

packets = input.lines.reject!(&.empty?).map { |x| Arr.parse(x) }
p1 = packets.each_slice(2).with_index(1).sum { |(a, b), i| a <= b ? i : 0 }

two, six = Arr.parse("[[2]]"), Arr.parse("[[6]]")
packets << two << six
packets.sort!

p2 = {two, six}.product { |x| packets.index!(x) + 1 }
puts p1, p2
