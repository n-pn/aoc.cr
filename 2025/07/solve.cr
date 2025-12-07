input = File.read("#{__DIR__}/input.txt").strip.lines

beams = Hash(Int32, Int64).new(0_i64)
beams[input[0].chars.index!('S')] = 1
count = 0

input[1..].each do |line|
  new_beams = Hash(Int32, Int64).new(0)

  beams.each do |k, v|
    if line[k] == '^'
      count += 1
      new_beams[k - 1] += v
      new_beams[k + 1] += v
    else
      new_beams[k] += v
    end

    beams = new_beams
  end
end

puts "part 1: #{count}"
puts "part 2: #{beams.sum(&.[1])}"
