input = File.read("#{__DIR__}/input.txt").gsub('\n', "")

solve = ->(str : String) { str.scan(/mul\((\d+),(\d+)\)/).sum { |x| x[1].to_i * x[2].to_i } }
puts solve.call(input), solve.call(input.gsub(/don't\(\).*?do\(\)/, "do()"))
