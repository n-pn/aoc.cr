# input = File.read("day07/test0.txt").strip
input = File.read("day07/input.txt").strip
SIZES = [] of Int32

def parse(input)
  size = 0

  input.each do |line|
    case line[0]
    when 'd' then next
    when '$'
      break if line.ends_with?("..")
      size += parse(input) unless line[3] == 'l'
    else size += line.split(' ').first.to_i
    end
  end

  SIZES << size
  size
end

parse(input.each_line)

puts SIZES.reject(&.> 100000).sum
puts SIZES.reject(&.<(SIZES.last - 40000000)).min
