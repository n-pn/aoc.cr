def total(type : String)
  input = File.read("day01/#{type}.txt").strip

  input.split("\n\n").map do |x|
    x.split("\n").sum(&.to_i)
  end
end

puts total("test0").max
puts total("input").max

puts total("test0").sort.last(3).sum
puts total("input").sort.last(3).sum
