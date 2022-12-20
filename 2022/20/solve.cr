def solve(input, times)
  limit = input.size
  nexts = Array.new(limit) { |i| (i + 1) % limit }

  times.times do
    input.each_with_index do |value, index|
      next if value == 0

      left, right = index, nexts[index]
      nexts[nexts.index!(&.== index)] = right

      (value % (limit - 1)).times { left, right = right, nexts[right] }

      nexts[left] = index
      nexts[index] = right
    end
  end

  start = input.index!(0)
  {1000, 2000, 3000}.sum { |i| input[0.to(i % limit - 1).reduce(start) { |r, _| nexts[r] }] }
end

# input = {{ read_file("day20/test0.txt").strip }}.lines.map(&.to_i64)
input = {{ read_file("day20/input.txt").strip }}.lines.map(&.to_i64)

def solve_2(input, times = 1)
  indexes = (0...input.size).to_a

  times.times do
    input.each_with_index do |v, i|
      j = indexes.index!(i)
      indexes.delete_at(j)
      indexes.insert((v + j) % indexes.size, i)
    end
  end

  start = indexes.index!(input.index!(0))
  {1000, 2000, 3000}.sum { |idx| input[indexes[(start + idx) % input.size]] }
end

puts solve(input, 1)
puts solve(input.map(&.* 811589153), 10)

puts solve_2(input, 1)
puts solve_2(input.map(&.* 811589153), 10)
