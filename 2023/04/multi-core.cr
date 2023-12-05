require "bit_array"

time = Time.measure do
  text = File.read_lines "#{__DIR__}/bigboy.txt"
  workers = Channel({Array(String), Int32}).new(text.size)

  threads = (ENV["CRYSTAL_WORKERS"]? || "4").to_i
  results = Channel({Array(Int32), Int32}).new(threads)

  threads.times do
    spawn do
      arr, idx = workers.receive
      res = arr.map do |txt|
        set = BitArray.new(100)
        win, you = txt.split(':', 2).last.split('|', 2)

        win.split { |i| set[i.to_i] = true }
        you.split.count { |i| set[i.to_i] }
      end

      results.send({res, idx})
    end
  end

  text.each_slice(text.size // threads + 1).with_index { |txt, idx| workers.send({txt, idx}) }

  data = Array({Array(Int32), Int32}).new
  threads.times { data << results.receive }

  data = data.sort_by!(&.[1]).flat_map(&.[0])

  puts data.sum { |x| 1 << x - 1 }
  puts data.map { 1 }.tap { |a| data.each_with_index { |c, i| 1.upto(c) { |j| a[i + j] += a[i] } } }.sum
end

puts time
