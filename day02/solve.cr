M = {"A" => 0, "B" => 1, "C" => 2, "X" => 0, "Y" => 1, "Z" => 2}

# input = File.read("day02/test0.txt").strip
input = File.read("day02/input.txt").strip
array = input.split(/\W+/).map { |x| M[x] }.each_slice(2).to_a

# part 1
puts array.sum { |(a, b)| {3, 0, 6}[(a - b) % 3] + b + 1 }

# part 2
puts array.sum { |(a, b)| {0, 3, 6}[b] + (a + {-1, 0, 1}[b]) % 3 + 1 }
