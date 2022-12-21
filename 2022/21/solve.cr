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

def build(op : String)
  case op
  when "+" then ->(l : Int64, r : Int64) { l + r }
  when "-" then ->(l : Int64, r : Int64) { l - r }
  when "*" then ->(l : Int64, r : Int64) { l * r }
  when "/" then ->(l : Int64, r : Int64) { l // r }
  else          raise "Unsupport"
  end
end

input.each_line do |line|
  left, right = line.split(": ")

  if value = right.to_i64?
    values[left] = value
  else
    lhs, op, rhs = right.split(' ')
    rules << {left, lhs, rhs, build(op)}

    case op
    when "+" then rules << {lhs, left, rhs, build("-")} << {rhs, left, lhs, build("-")}
    when "-" then rules << {lhs, left, rhs, build("+")} << {rhs, lhs, left, build("-")}
    when "*" then rules << {lhs, left, rhs, build("/")} << {rhs, left, lhs, build("/")}
    when "/" then rules << {lhs, left, rhs, build("*")} << {rhs, lhs, left, build("/")}
    end
  end
end

puts solve(rules.dup, values.dup, "root")
puts solve(rules, values, "humn", true)
