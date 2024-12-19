def solve(design, patterns)
  counts = Array(Int64).new(design.size + 1, 0_i64)
  counts[0] = 1_i64

  1.upto(design.size) do |upper|
    patterns.each do |pattern|
      lower = upper - pattern.size
      next if lower < 0
      counts[upper] &+= counts[lower] if pattern == design[lower...upper]
    end
  end

  counts[design.size]
end

input = File.read("#{__DIR__}/input.txt").strip
patterns, designs = input.split("\n\n").map(&.split(/\W+/))
choices = designs.map { |x| solve(x, patterns) }

puts choices.count(&.> 0), choices.sum
