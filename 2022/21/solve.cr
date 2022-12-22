def solve(rules, values, target = "root", part2 = false)
  values.delete(target)
  changed = true

  while changed
    changed = false

    rules.each_with_index do |(monkey, lh, rh, op), i|
      left, right = values[lh]?, values[rh]?

      if part2 && monkey == "root"
        next unless num = left || right
        values[lh] = values[rh] = num
        rules.delete_at(i)
        changed = true
      elsif left && right
        values[monkey] = op.call(left, right)
        rules.delete_at(i)
        changed = true
      end
    end
  end

  values[target]
end

# input = {{ read_file("2022/21/test0.txt").strip }}
input = {{ read_file("2022/21/input.txt").strip }}

rules = [] of {String, String, String, Proc(Int64, Int64, Int64)}
values = {} of String => Int64

OPS = {
  "+" => ->(l : Int64, r : Int64) { l + r },
  "-" => ->(l : Int64, r : Int64) { l - r },
  "*" => ->(l : Int64, r : Int64) { l * r },
  "/" => ->(l : Int64, r : Int64) { l // r },
}

input.each_line do |line|
  left, right = line.split(": ")

  if value = right.to_i64?
    values[left] = value
  else
    lhs, op, rhs = right.split(' ')
    rules << {left, lhs, rhs, OPS[op]}

    case op
    when "+" then rules << {lhs, left, rhs, OPS["-"]} << {rhs, left, lhs, OPS["-"]}
    when "-" then rules << {lhs, left, rhs, OPS["+"]} << {rhs, lhs, left, OPS["-"]}
    when "*" then rules << {lhs, left, rhs, OPS["/"]} << {rhs, left, lhs, OPS["/"]}
    when "/" then rules << {lhs, left, rhs, OPS["*"]} << {rhs, lhs, left, OPS["/"]}
    end
  end
end

puts solve(rules.dup, values.dup, "root")
puts solve(rules, values, "humn", true)
