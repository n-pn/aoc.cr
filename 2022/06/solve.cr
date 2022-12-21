# tests = File.read("2022/06/test0.txt").lines
input = File.read("2022/06/input.txt")
solve = ->(x : Int32) { input.each_char.cons(x).index!(&.uniq.size.== x) + x }
puts solve.call(4), solve.call(14)
