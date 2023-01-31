input = File.read_lines(__DIR__ + "/test0.txt")

def reduce(input, regex) : String
  while m = input.match(regex)
    input = input.sub(m[0], yield(m))
  end

  input
end

def part1(inp : String)
  reduce(inp, /(\d+) (\+|\*) (\d+)/) { |m| m[2] == "+" ? m[1].to_i + m[3].to_i : m[1].to_i * m[3].to_i }
end

def part2(inp : String)
  inp = reduce(inp, /(\d+) \+ (\d+)/) { |m| m[1].to_i + m[2].to_i }
  reduce(inp, /(\d+) \* (\d+)/) { |m| m[1].to_i * m[2].to_i }
end

def eval(input : String)
  input = reduce(input, /\(([^\(]+)\)/) { |m| yield m[1] }
  yield(input).to_i64
end

puts input.sum { |line| eval(line) { |s| part1(s) } }
puts input.sum { |line| eval(line) { |x| part2(x) } }
