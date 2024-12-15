def part1(inp, m, n, s = 100)
  i = j = k = l = 0

  inp.each do |line|
    a, b, x, y = line.scan(/-?\d+/).map(&.[0].to_i)
    c, d = (a + x * s) % m, (b + y * s) % n

    case
    when c < m // 2 && d < n // 2 then i += 1
    when c < m // 2 && d > n // 2 then j += 1
    when c > m // 2 && d < n // 2 then k += 1
    when c > m // 2 && d > n // 2 then l += 1
    end
  end

  i * j * k * l
end

def tree?(res, m, n)
  map = Array(Array(Int32)).new(m) { |x| Array(Int32).new(n, 0) }
  res.each { |(a, b)| map[a][b] += 1 }
  map.join('\n', &.join { |x| x > 0 ? x : ' ' }).includes?("111111111111")
end

def part2(inp, m, n)
  inp = inp.map(&.scan(/-?\d+/).map(&.[0].to_i))

  (1..).each do |i|
    res = inp.map { |a| {(a[0] + a[2] * i) % m, (a[1] + a[3] * i) % n} }
    return i if tree?(res, m, n)
  end
end

input = File.read("#{__DIR__}/input.txt").strip.lines
puts part1(input, 101, 103), part2(input, 101, 103)
