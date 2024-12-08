def solve(input : Array(String), t = 1)
  map = Hash(Char, Array({Int32, Int32})).new { |h, k| h[k] = [] of {Int32, Int32} }
  res = Set({Int32, Int32}).new

  input.each_with_index do |line, i|
    line.each_char.with_index { |c, j| map[c] << {i, j} if c != '.' }
  end

  map.each_value do |arr|
    arr[0..-2].each_with_index(1) do |a, i|
      arr[i..].each do |b|
        (-t..t + 1).each do |i|
          cx, cy = b[0] - (b[0] - a[0]) * i, b[1] - (b[1] - a[1]) * i
          res << {cx, cy} if cx.in?(0...input.size) && cy.in?(0...input.first.size) && (t > 1 || i < 0 || i > 1)
        end
      end
    end
  end

  res.size
end

input = File.read("#{__DIR__}/input.txt").strip.lines
puts solve(input, 1)
puts solve(input, input.size)
