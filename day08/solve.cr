require "colorize"

# INPUT = File.read("day08/test0.txt").strip
input = File.read("day08/input.txt").strip

map = input.lines.map(&.chars)

max = 0

1.upto(map.size - 2) do |i|
  1.upto(map.first.size - 2) do |j|
    imap = map[i]
    jmap = map.map(&.[j])
    min = imap[j]
    # puts imap, jmap

    score = score_for(imap[0...j].reverse, min)
    score *= score_for(imap[(j + 1)..], min)
    score *= score_for(jmap[0...i].reverse, min)
    score *= score_for(jmap[(i + 1)..], min)

    # puts [i, j, score].colorize.blue

    max = score if score > max
  end
end

puts max

def score_for(map, min)
  c = 1

  map.each do |v|
    return c if v >= min
    c += 1
  end

  c - 1
end

# count = map.size * 2 + map.first.size * 2 - 4
# def visible?(map, i, j)
#   n = map.size
#   m = map[0].size

#   x = map[i][j]

#   c = 0

#   (0...i).each do |ii|
#     next if map[ii][j] < x

#     c += 1
#     break
#   end

#   (i + 1...n).each do |ii|
#     next if map[ii][j] < x
#     c += 1
#     break
#   end

#   (0...j).each do |jj|
#     next if map[i][jj] < x
#     c += 1
#     break
#   end

#   (j + 1...m).each do |jj|
#     next if map[i][jj] < x
#     c += 1
#     break
#   end

#   c < 4
# end

# 1.upto(map.size - 2) do |i|
#   1.upto(map[0].size - 2) do |j|
#     count += 1 if visible?(map, i, j)
#   end
# end

# puts count
