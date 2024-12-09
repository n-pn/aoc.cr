def part1(disk, free, fill)
  fill.reverse_each do |flen, fpos, f_id|
    while flen > 0 && (index = free.index { |plen, pidx| plen > 0 && pidx < fpos })
      plen, pidx = free[index]
      move = {plen, flen}.min
      free << {move, fpos}
      move.times { |i| disk[fpos + i] = -1; disk[pidx + i] = f_id }
      flen, fpos = flen - move, fpos + move
      free[index] = {plen - move, pidx + move}
    end
  end

  disk.each.with_index.sum(0_i64) { |f_id, b_id| f_id > 0 ? f_id * b_id : 0 }
end

def part2(disk, free, fill)
  fill.reverse_each do |flen, fpos, f_id|
    next unless index = free.index { |a, b| a >= flen && b < fpos }
    size, pidx = free[index]
    free[index] = {size - flen, pidx + flen}
    flen.times { |i| disk[fpos + i] = -1; disk[pidx + i] = f_id }
  end

  disk.each.with_index.sum(0_i64) { |f_id, b_id| f_id > 0 ? f_id * b_id : 0 }
end

disk = [] of Int32
free = [] of {Int32, Int32}
fill = [] of {Int32, Int32, Int32}

input = File.read("#{__DIR__}/input.txt").strip

input.each_char.with_index do |char, i|
  size = char.to_i
  if i.even?
    fill << {size, disk.size, fill.size}
    size.times { disk << fill.size - 1 }
  else
    free << {size, disk.size}
    size.times { disk << -1 }
  end
end

puts part1(disk.clone, free.clone, fill.clone)
puts part2(disk, free, fill)
