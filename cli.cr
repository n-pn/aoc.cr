require "http"
require "colorize"
require "option_parser"

HEADERS = HTTP::Headers{"Cookie" => "session=#{File.read("session").strip}"}

def fetch(year : Int32, day : Int32, out_dir : String)
  solve_file = "#{out_dir}/solve.cr"

  unless File.file?(solve_file)
    puts "Init file for #{out_dir}".colorize.green
    File.write solve_file, File.read("dummy.cr")
  end

  puts "Fetching input of year: #{year.colorize.yellow}, day: #{day.colorize.yellow}"
  puts

  link = "https://adventofcode.com/#{year}/day/#{day}/input"
  body = HTTP::Client.get(link, headers: HEADERS, &.body_io.gets_to_end)

  file = "#{out_dir}/input.txt"
  Dir.mkdir_p(File.dirname(file))
  File.write(file, body)

  puts body
end

def answer(year : Int32, day : Int32, answer : String, level : Int32 | String)
  puts "Answering part #{level} of day #{day} year #{year}: #{answer}"

  form = {"level" => level.to_s, "answer" => answer}
  link = "https://adventofcode.com/#{year}/day/#{day.to_i}/answer"

  body = HTTP::Client.post(link, headers: HEADERS, form: form).body

  found = body.match(/<article>(.+)<\/article>/)
  puts found.not_nil![1]
end

current = Time.local
year, day = current.year, current.day
args = [] of String

OptionParser.parse(ARGV) do |parser|
  parser.on("-y YEAR", "AOC year") { |y| year = y.to_i }
  parser.on("-d DAY", "AOC day") { |d| day = d.to_i }
  parser.unknown_args { |a| args = a }
end

out_dir = "#{year}/#{day.to_s.rjust(2, '0')}"
Dir.mkdir_p(out_dir)

case args[0]?
when "1" then answer(year, day, args[1], "1")
when "2" then answer(year, day, args[1], "2")
else          fetch(year, day, out_dir)
end
