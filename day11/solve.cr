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

  def new_level(level : Int64)
    case @op_chr
    when '+' then level + @op_val
    when '*' then level * @op_val
    else          level * level
    end
  end

  def pass_to(level : Int64)
    level % @test == 0 ? @if_true : @if_false
  end
end

# input = File.read("day11/test0.txt").strip
input = File.read("day11/input.txt").strip

monkeys = input.split("\n\n").map { |x| Monkey.new(x) }
factor = monkeys.product(&.test)

20.times do
  monkeys.each do |m|
    while level = m.p1.shift?
      m.c1 += 1
      level = m.new_level(level) // 3
      monkeys[m.pass_to(level)].p1 << level
    end
  end
end

10000.times do
  monkeys.each do |m|
    while level = m.p2.shift?
      m.c2 += 1
      level = m.new_level(level % factor)
      monkeys[m.pass_to(level)].p2 << level
    end
  end
end

puts monkeys.map(&.c1).sort!.last(2).product
puts monkeys.map(&.c2).sort!.last(2).product
