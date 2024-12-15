def do_move(hmap, orig, char)
  i, j = {'>' => {0, 1}, 'v' => {1, 0}, '<' => {0, -1}, '^' => {-1, 0}}[char]
  q_all = [[orig]]

  loop do
    qnext = [] of {Int32, Int32}

    q_all.last.each do |curr|
      succ = {curr[0] + i, curr[1] + j}

      return orig if hmap[succ] == '#'
      next if hmap[succ] == '.'

      qnext << succ
      next if char.in?('<', '>')

      qnext << {succ[0], succ[1] + 1} if hmap[succ] == '['
      qnext << {succ[0], succ[1] - 1} if hmap[succ] == ']'
    end

    break if qnext.empty?
    q_all << qnext.uniq!
  end

  q_all.reverse_each do |qlist|
    qlist.each do |curr|
      succ = {curr[0] + i, curr[1] + j}
      hmap[curr], hmap[succ] = hmap[succ], hmap[curr]
    end
  end

  {orig[0] + i, orig[1] + j}
end

map1 = {} of {Int32, Int32} => Char
map2 = {} of {Int32, Int32} => Char
pos1 = pos2 = {-1, -1}

imap, moves = File.read("#{__DIR__}/input.txt").split("\n\n")

imap.strip.each_line.with_index do |line, i|
  line.each_char.with_index do |char, j|
    map1[{i, j}] = char
    case char
    when '#', '.'
      map2[{i, j * 2}] = char
      map2[{i, j * 2 + 1}] = char
    when 'O'
      map2[{i, j * 2}] = '['
      map2[{i, j * 2 + 1}] = ']'
    when '@'
      map2[{i, j * 2}] = '@'
      map2[{i, j * 2 + 1}] = '.'
      pos1, pos2 = {i, j}, {i, j * 2}
    end
  end
end

moves.gsub('\n', "").each_char do |char|
  pos1 = do_move(map1, pos1, char)
  pos2 = do_move(map2, pos2, char)
end

puts map1.each.sum { |(i, j), c| c == 'O' ? 100 * i + j : 0 }
puts map2.each.sum { |(i, j), c| c == '[' ? 100 * i + j : 0 }
