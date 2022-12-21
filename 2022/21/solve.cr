input = {{ read_file("2022/21/test0.txt").strip }}
input = {{ read_file("2022/21/input.txt").strip }}

DEPS = [] of {String, String, String, String}
NUMS = {} of String => Int64

input.each_line do |line|
  monkey, right = line.split(": ")
  next if monkey == "humn"

  if number = right.to_i64?
    NUMS[monkey] = number
  else
    left, operator, right = right.split(' ')
    DEPS << {monkey, left, right, operator}

    case operator
    when "+" then DEPS << {left, monkey, right, "-"} << {right, monkey, left, "-"}
    when "-" then DEPS << {left, monkey, right, "+"} << {right, left, monkey, "-"}
    when "*" then DEPS << {left, monkey, right, "/"} << {right, monkey, left, "/"}
    when "/" then DEPS << {left, monkey, right, "*"} << {right, left, monkey, "/"}
    end
  end
end

NUMS.delete("humn")

loop do
  changed = false

  DEPS.each_with_index do |(monkey, lh, rh, op), i|
    if monkey == "root"
      if num = NUMS[lh]? || NUMS[rh]?
        NUMS[lh] = NUMS[rh] = num
        changed = true
        DEPS.delete_at(i)
      end

      next
    end

    next unless (left = NUMS[lh]?) && (right = NUMS[rh]?)
    DEPS.delete_at(i)

    changed = true
    NUMS[monkey] =
      case op
      when "+" then left + right
      when "-" then left - right
      when "*" then left * right
      when "/" then left // right
      else          0_i64
      end
  end

  break unless changed
end

puts NUMS["humn"]?
