def solve(program, a, b, c)
  res = [] of Int64
  pos = 0

  while pos &+ 2 <= program.size
    x, y, pos = program[pos], program[pos &+ 1], pos &+ 2
    z = {0_i64, 1_i64, 2_i64, 3_i64, a, b, c}[y]

    case x
    when 0 then a = a // 2 ** z
    when 1 then b = b ^ y
    when 2 then b = z % 8
    when 3 then pos = y.unsafe_as(Int32) if a != 0
    when 4 then b = b ^ c
    when 5 then res << z % 8
    when 6 then b = a // 2 ** z
    when 7 then c = a // 2 ** z
    end
  end

  res
end

input = File.read("#{__DIR__}/input.txt").strip
a, b, c, *program = input.scan(/\d+/m).map(&.[0].to_i64)

puts solve(program, a, b, c).join(',')

a = 1_i64
puts(loop do
  output = solve(program, a, b, c)
  break a if output == program
  a = output == program.last(output.size) ? a &* 8 : a &+ 1
end)
