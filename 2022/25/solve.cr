# input = {{ read_file("2022/25/test0.txt").strip }}
input = {{ read_file("2022/25/input.txt").strip }}

MAP = {'0' => 0, '1' => 1, '2' => 2, '-' => -1, '=' => -2}

sum = input.lines.sum { |l| l.chars.reduce(0_i64) { |a, c| a * 5 + MAP[c] } }
res = String::Builder.new

while sum != 0
  r = sum % 5
  chr, num = MAP.key_for?(r).try { |c| {c, 0} } || MAP.find! { |_, n| MAP.has_value?(r + n) }

  sum = (sum - num) // 5
  res << chr
end

puts res.to_s.reverse
