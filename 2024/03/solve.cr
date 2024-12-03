input = File.read("#{__DIR__}/input.txt").strip

solve = ->(str : String) { str.scan(/mul\((\d+),(\d+)\)/).sum { |x| x[1].to_i * x[2].to_i } }

puts solve.call(input)
puts "do()#{input}".split(/(do\(\)|don't\(\))/).each_cons_pair.sum { |a, b| a == "do()" ? solve.call(b) : 0 }
