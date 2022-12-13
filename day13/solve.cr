input = File.read("day13/test0.txt").strip
input = File.read("day13/input.txt").strip

class Arr
  @arr = [] of Arr | Int32
  forward_missing_to @arr

  def self.from(x : Int32)
    new.tap(&.<< x)
  end
end

def parse(input : String)
  parse_iter(input.each_char)[0].as(Arr)
end

def parse_iter(iter)
  res = Arr.new
  acc = ""

  iter.each do |char|
    case char
    when '[' then res << parse_iter(iter)
    when ']' then break
    when ','
      res << acc.to_i unless acc.empty?
      acc = ""
    else acc += char
    end
  end

  res << acc.to_i unless acc.empty?

  res
end

def cmp(l, r) : Int32
  case {l, r}
  in {Int32, Int32} then return l <=> r
  in {Int32, Arr}   then l = Arr.from(l)
  in {Arr, Int32}   then r = Arr.from(r)
  in {Arr, Arr}
  end

  l.each_with_index do |a, i|
    return 1 unless b = r[i]?
    cmp(a, b).try { |c| return c unless c == 0 }
  end

  l.size <=> r.size
end

packets = input.lines.reject!(&.empty?).map { |x| parse(x) }
p1 = packets.each_slice(2).with_index(1).sum { |(a, b), i| cmp(a, b) < 1 ? i : 0 }

two, six = parse("[[2]]"), parse("[[6]]")
packets << two << six
packets.sort! { |a, b| cmp(a, b) }

p2 = {two, six}.product { |x| packets.index! { |y| cmp(x, y) == 0 } + 1 }
puts p1, p2
