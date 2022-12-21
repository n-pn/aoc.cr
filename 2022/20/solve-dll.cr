class Node
  property data : Int64
  property! prev : Node
  property! succ : Node

  def initialize(@data)
  end
end

def solve(input, times)
  limit = input.size

  input.each_with_index do |node, i|
    node.prev = input[(i - 1) % limit]
    node.succ = input[(i + 1) % limit]
  end

  times.times do
    input.each do |node|
      next if node.data == 0

      succ = node.succ
      (node.data % (limit - 1)).times { succ = succ.succ }

      node.prev.succ = node.succ
      node.succ.prev = node.prev

      prev = succ.prev
      prev.succ = node
      node.prev = prev

      node.succ = succ
      succ.prev = node
    end
  end

  zero = input.find!(&.data.== 0)
  {1000, 2000, 3000}.sum { |i| (0...i % limit).reduce(zero) { |x, _| x = x.succ }.data }
end

input = {{ read_file("2022/20/input.txt").strip }}.lines.map { |x| Node.new(x.to_i64) }

puts solve(input, 1)
input.each { |x| x.data *= 811589153 }
puts solve(input, 10)
