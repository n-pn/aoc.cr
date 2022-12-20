require "http"
require "colorize"
require "option_parser"

def headers
  cookies = HTTP::Cookies{HTTP::Cookie.new("session", File.read("session"))}
  headers = HTTP::Headers.new
  cookies.add_request_headers(headers)
  headers
end

def init(out_dir : String)
  Dir.mkdir_p(out_dir)
  out_file = "#{out_dir}/solve.cr"
  return if File.file?(out_file)

  puts "Init file for #{out_dir}".colorize.green

  File.write(out_file, <<-DATA)
    require "../../aoc"

    Ctx = AOC.new __DIR__
    input = Ctx.input.lines.map(&.to_i)
    DATA
end

def fetch(year : Int32, day : Int32, out_dir : String)
  puts "Fetching input of year: #{year.colorize.yellow}, day: #{day.colorize.yellow}"
  puts

  link = "https://adventofcode.com/#{year}/day/#{day}/input"
  body = HTTP::Client.get(link, headers: headers).body

  file = "#{out_dir}/input.txt"
  File.write(file, body)

  puts body
end

def submit(year : Int32, day : Int32, answer : String, level : String)
  puts "Answering part #{level} of day #{day} year #{year}: #{answer}"

  form = {"level" => level, "answer" => answer}
  link = "https://adventofcode.com/#{year}/day/#{day.to_i}/answer"

  body = HTTP::Client.post(link, headers: headers, form: form).body

  found = body.match(/<article>(.+)<\/article>/)
  puts found.not_nil![1]
end

current = Time.local
year = current.year
day = current.day

args = [] of String

OptionParser.parse(ARGV) do |parser|
  parser.on("-y YEAR", "AOC year") { |y| year = y.to_i }
  parser.on("-d DAY", "AOC day") { |d| day = d.to_i }
  parser.unknown_args { |a| args = a }
end

out_dir = "#{year}/#{day.to_s.rjust(2, '0')}"

case args[0]
when "init"
  init(out_dir)
when "input"
  fetch(year, day, out_dir)
else
  args.shift if args[0].in?("submit", "answer")
  submit(year, day, args[0], args.fetch(1, "1"))
end
