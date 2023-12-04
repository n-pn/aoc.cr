input = <<-TXT
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
TXT

input = File.read("#{__DIR__}/input.txt")

games = input.lines(chomp: true).compact_map do |line|
  label, steps = line.split(": ", 2)

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

  steps
end

p1 = games.each.with_index(1).sum(0) do |steps, id|
  valid = true
  steps.each do |step|
    next if step["red"] <= 12 && step["green"] <= 13 && step["blue"] <= 14
    valid = false
    break
  end

  valid ? id : 0
end

p2 = games.each.with_index(1).sum(0) do |steps, id|
  steps.max_of(&.["red"]) * steps.max_of(&.["green"]) * steps.max_of(&.["blue"])
end

puts p1, p2
