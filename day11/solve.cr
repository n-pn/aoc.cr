class Monkey
  getter p1 : Array(Int64), p2 : Array(Int64)
  getter op_chr : Char, op_val : Int32
  getter test : Int32, if_true : Int32, if_false : Int32
  property c1 = 0, c2 = 0_i64

  def initialize(input : String)
    input = input.sub("* old", "^ 2")
    @op_chr = input.match(/old (.)/).not_nil![1][0]
    _, *items, @op_val, @test, @if_true, @if_false = input.scan(/\d+/).map(&.[0].to_i)
    @p1 = items.map(&.to_i64)
    @p2 = @p1.dup
  end

  def move(lvl : Int64, mod : Int32, div = 3)
    val = @op_chr == '^' ? lvl : @op_val
    lvl = @op_chr == '+' ? lvl + val : lvl * val
    lvl = lvl % mod // div
    {lvl, lvl % @test == 0 ? @if_true : @if_false}
  end
end

# input = File.read("day11/test0.txt").strip
input = File.read("day11/input.txt").strip

monkeys = input.split("\n\n").map { |x| Monkey.new(x) }
mod = monkeys.product(&.test)

20.times do
  monkeys.each do |m|
    m.c1 += m.p1.size
    m.p1.each { |l| l, i = m.move(l, mod, 3); monkeys[i].p1 << l }
    m.p1.clear
  end
end

10000.times do
  monkeys.each do |m|
    m.c2 += m.p2.size
    m.p2.each { |l| l, i = m.move(l, mod, 1); monkeys[i].p2 << l }
    m.p2.clear
  end
end

puts monkeys.map(&.c1).sort!.last(2).product
puts monkeys.map(&.c2).sort!.last(2).product
