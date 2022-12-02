def read_input(file : String)
  a_map = {"A", "B", "C"}
  b_map = {"X", "Y", "Z"}

  File.read_lines(file).reject!(&.empty?).map do |line|
    a, b = line.split(" ")
    {a_map.index!(a), b_map.index!(b)}
  end
end

# input = read_input("day02/test0.txt")
input = read_input("day02/input.txt")

# part 1
puts input.sum { |a, b| {3, 0, 6}[(a - b) % 3] + b + 1 }

# part 2
puts input.sum { |a, b| {0, 3, 6}[b] + (a + {-1, 0, 1}[b]) % 3 + 1 }
