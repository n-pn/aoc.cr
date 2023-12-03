class AOC
  class_property last_answer : {Int32, Int32, Int32, String}? = nil

  at_exit do
    @@last_answer.try do |(year, day, part, answer)|
      `./bin/cli submit #{answer}} #{part} -y #{year} -d #{day}`
    end
  end

  getter year : Int32, day : Int32
  getter input : String

  getter tests = [] of {String, String?, String?}

  def initialize(@dir : String)
    @year, @day = @dir.split("/").last(2).map(&.to_i)
    @input = read_input("#{@dir}/input.txt")
  end

  def test(id = 0)
    File.read("#{@dir}/test#{id}.txt")
  end

  def answer(answer, part = 1)
    @@last_answer = {@year, @day, part, answer.to_s}
  end

  private def read_input(ipath : String)
    File.read(ipath)
  rescue
    `./bin/cli f -y #{@year} -d #{@day}`
    File.read(ipath)
  end
end
