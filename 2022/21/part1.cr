# input = {{ read_file("2022/21/test0.txt").strip }}
input = {{ read_file("2022/21/input.txt").strip }}

DEPS = [] of {String, String, String, String}
NUMS = {} of String => Int64

input.each_line do |line|
  monkey, right = line.split(": ")

  if number = right.to_i64?
    NUMS[monkey] = number
  else
    left, operator, right = right.split(' ')
    DEPS << {monkey, left, right, operator}
  end
end

loop do
  changed = false

  DEPS.each_with_index do |(monkey, left, right, operator), i|
    next unless (lval = NUMS[left]?) && (rval = NUMS[right]?)

    DEPS.delete_at(i)
    changed = true

    NUMS[monkey] =
      case operator
      when "+" then lval + rval
      when "-" then lval - rval
      when "*" then lval * rval
      when "/" then lval // rval
      else          raise "Invalid!"
      end
  end

  break unless changed
end

puts NUMS["root"]?
