input = File.read("2023/02/test0.txt")
input = File.read("2023/02/input.txt")

games = input.lines(chomp: true).compact_map do |line|
  label, steps = line.split(": ", 2)

  id = label.lchop("Game ").to_i

  steps = steps.split("; ").map do |game|
    game.split(", ").to_h do |cube|
      number, color = cube.split(' ')
      {color, number.to_i}
    end
  end

  steps.each do |step|
    step["red"] ||= 0
    step["green"] ||= 0
    step["blue"] ||= 0
  end

  {id, steps}
end

p1 = games.sum(0) do |(id, steps)|
  valid = true
  steps.each do |step|
    next if step["red"] <= 12 && step["green"] <= 13 && step["blue"] <= 14
    valid = false
    break
  end

  valid ? id : 0
end

p2 = games.sum(0) do |(id, steps)|
  steps.max_of(&.["red"]) * steps.max_of(&.["green"]) * steps.max_of(&.["blue"])
end

puts p1, p2
