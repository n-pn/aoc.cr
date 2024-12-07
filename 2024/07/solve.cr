input = File.read("#{__DIR__}/input.txt").strip.lines.map(&.scan(/\d+/).map(&.[0].to_i64))

def solve(a, s, m, i, p2)
  i >= a.size ? s == m : {a[i] + m, a[i] * m, p2 ? a[i] + m * 10 ** a[i].digits.size : 0_i64}.any? { |x| solve(a, s, x, i + 1, p2) }
end

puts input.sum { |arr| solve(arr[1..], arr[0], arr[1], 1) ? arr[0] : 0_i64 }
puts input.sum { |arr| solve(arr[1..], arr[0], arr[1], 1, true) ? arr[0] : 0_i64 }
