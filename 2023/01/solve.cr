# input = File.read("2023/01/test0.txt")
# input = File.read("2023/01/test1.txt")
input = File.read("2023/01/input.txt")

p1 = input.lines.reduce(0) do |memo, line|
  digits = line.scan(/\d/)
  memo + digits[0][0].to_i * 10 + digits[-1][0].to_i
end

DIGITS = {
  "zero"  => 0,
  "one"   => 1,
  "two"   => 2,
  "three" => 3,
  "four"  => 4,
  "five"  => 5,
  "six"   => 6,
  "seven" => 7,
  "eight" => 8,
  "nine"  => 9,
  "0"     => 0,
  "1"     => 1,
  "2"     => 2,
  "3"     => 3,
  "4"     => 4,
  "5"     => 5,
  "6"     => 6,
  "7"     => 7,
  "8"     => 8,
  "9"     => 9,
}

FDIGIT_RE = Regex.new "(" + DIGITS.keys.join("|") + ")"
LDIGIT_RE = Regex.new ".*(" + DIGITS.keys.join("|") + ")"

p2 = input.lines.reduce(0) do |memo, line|
  fdigit = FDIGIT_RE.match!(line)[1]
  ldigit = LDIGIT_RE.match!(line)[1]
  memo + DIGITS[fdigit] * 10 + DIGITS[ldigit]
end

puts p1, p2
