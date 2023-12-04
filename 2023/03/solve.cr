input = File.read("#{__DIR__}/input.txt").strip.lines

test0 = <<-TXT.lines
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
TXT

input = input.map { |x| ".#{x}.".chars }
input.unshift Array.new(input.first.size, '.')
input.push Array.new(input.first.size, '.')

def symbol?(char : Char)
  !(char.number? || char == '.')
end

def part_number?(input, l_id, lower, upper)
  return true if input[l_id - 1][lower..upper].any? { |x| symbol?(x) }
  return true if input[l_id + 1][lower..upper].any? { |x| symbol?(x) }
  input[l_id][lower..upper].any? { |x| symbol?(x) }
end

def gear?(char : Char)
  char == '*'
end

def gear_number?(input, l_id, lower, upper)
  lower.upto(upper) do |r_id|
    return {l_id - 1, r_id} if input[l_id - 1][r_id] == '*'
    return {l_id + 1, r_id} if input[l_id + 1][r_id] == '*'
  end

  return {l_id, lower} if input[l_id][lower] == '*'
  return {l_id, upper} if input[l_id][upper] == '*'

  nil
end

p1 = 0

gears = Hash({Int32, Int32}, Array(Int32)).new do |h, k|
  h[k] = [] of Int32
end

lmax = input.first.size - 1

1.upto(input.size - 2) do |l_id|
  # puts input[l_id].join

  line = input[l_id]

  i = 0
  while i < lmax
    unless line[i].number?
      i += 1
      next
    end

    j = i + 1
    while line[j].number?
      j += 1
    end

    if part_number?(input, l_id, i - 1, j)
      p1 += (line[i...j].join).to_i
      # puts line[i...j].join
    end

    if pos = gear_number?(input, l_id, i - 1, j)
      gears[pos] << (line[i...j].join).to_i
    end

    i = j
  end
end

puts p1
puts gears.values.select(&.size.== 2).sum(&.product)
