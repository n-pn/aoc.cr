# input = {{ read_file("2022/25/test0.txt").strip }}
input = {{ read_file("2022/25/input.txt").strip }}

MAP = {'0' => 0, '1' => 1, '2' => 2, '-' => -1, '=' => -2}

sum = input.lines.sum { |l| l.chars.reduce(0_i64) { |a, c| a * 5 + MAP[c] } }
res = [] of Char

while sum != 0
  rem = sum % 5
  rem -= 5 if rem > 2
  sum = (sum - rem) // 5
  res.unshift MAP.key_for(rem)
end

puts res.join
