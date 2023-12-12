input = File.read("#{__DIR__}/input.txt").strip
# input = File.read("#{__DIR__}/bigboy.txt").strip

test1 = <<-TXT
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
TXT

CACHE = Hash({String, Array(Int32)}, Int64).new

def calc(text : String, ints : Array(Int32))
  CACHE.put_if_absent({text, ints}) do
    break 0_i64 if text.count(&.!= '.') < ints.sum
    break text.includes?('#') ? 0_i64 : 1_i64 if ints.empty?

    char = text[0]
    head, *tail = ints

    sum1 = char.in?('.', '?') ? calc(text[1..], ints) : 0_i64
    break sum1 if char == '.' || text[0..head] !~ (/^[?#]+[?.]$/)

    sum1 &+ calc(text[(head + 1)..], tail)
  end
end

def part1(text)
  text.lines.sum do |line|
    str, ints = line.split(' ', 2)
    calc(str + '.', ints.split(',').map(&.to_i))
  end
end

def part2(text)
  text.lines.sum do |line|
    str, ints = line.split(' ', 2)
    calc([str].*(5).join('?') + '.', ints.split(',').map(&.to_i) * 5)
  end
end

time = Time.measure do
  puts "part 1: #{part1(input)}" # if part1(test1) == 21
  puts "part 2: #{part2(input)}" # if part2(test1) == 525152
end

puts time.total_milliseconds
