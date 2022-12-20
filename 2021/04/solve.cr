# input = File.read("#{__DIR__}/test0.txt")
input = File.read("#{__DIR__}/input.txt")

input = input.strip.split("\n\n")

draws = input[0].split(",").map(&.to_i)
boards = input[1..].map(&.lines.map(&.split.map(&.to_i)))

result = [] of Int32
bingos = Set(Int32).new

draws.each do |draw|
  boards.each_with_index do |board, id|
    next if bingos.includes?(id)

    board.each do |rows|
      rows.each_with_index do |val, y|
        next if val != draw
        rows[y] = -1

        next unless rows.all?(&.== -1) || board.map(&.[y]).all?(&.== -1)

        bingos << id
        result << board.flatten.reject(&.== -1).sum * draw
      end
    end
  end

  break if bingos.size == boards.size
end

puts result.first, result.last
