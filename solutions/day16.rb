require_relative 'lib/file_reader.rb'

class Program
    attr_accessor :name, :position
    def initialize(name, position)
        @name = name
        @position = position
    end
end

class Instructions    
    def initialize(data)
        @instructions = []
        @swap_names = []
        @spins_and_swaps = []
        process_instructions(data)
    end

    def process_instructions(data)
        instructions = data.split(",")
        instructions.each do |instruction|
            process_instruction(instruction)
        end        
    end

    def process_instruction(instruction)
        if instruction.include?("s")
            i = Spin.new(instruction)
            @instructions << i
            @spins_and_swaps << i
        elsif instruction.include?("x")
            i = Swap.new(instruction)
            @instructions << i
            @spins_and_swaps << i
        elsif instruction.include?("p")
            i = SwapName.new(instruction)
            @instructions << i
            @swap_names << i         
        end
    end

    def run(programs, programs_map)
        @instructions.each do |instruction|
            programs, programs_map = instruction.do_action(programs, programs_map)
        end
        return programs, programs_map
    end
end

class Spin
    def initialize(instruction)
        @num = instruction.split("s")[1].strip.to_i
        @programs_size = nil
    end

    def do_action(programs, programs_map)
        if !@programs_size
            @programs_size = programs.size
        end
        programs = programs[(-1 * @num)..-1] + programs[0...(@programs_size - @num)]
        programs.each_with_index do |program, idx|
            program.position = idx
        end
        return programs, programs_map
    end
end

class Swap
    def initialize(instruction)
        @num1 = instruction.split("x")[1].split("/")[0].strip.to_i
        @num2 = instruction.split("x")[1].split("/")[1].strip.to_i
    end

    def do_action(programs, programs_map)  
        p1 = programs[@num1]
        p2 = programs[@num2]
        p1.position = @num2
        p2.position = @num1
        programs[@num1] = p2
        programs[@num2] = p1
        return programs, programs_map
    end
end

class SwapName
    def initialize(instruction)
        @char1 = instruction.split("p",2)[1].split("/")[0].strip
        @char2 = instruction.split("p",2)[1].split("/")[1].strip
    end

    def do_action(programs, programs_map)
        p1 = programs_map[@char1]
        p2 = programs_map[@char2]
        programs[p1.position] = p2
        programs[p2.position] = p1
        temp = p1.position
        p1.position = p2.position
        p2.position = temp           
        return programs, programs_map
    end
end

class Group
    def initialize(custom, data)
        @programs = []
        @programs_map = {}
        if custom
            for i in 0...custom
                char = (i + 97).chr
                p = Program.new(char, i)
                @programs << p
                @programs_map[char] = p
            end
        else
            for i in 0..15
                char = (i + 97).chr
                p = Program.new(char, i)
                @programs << p
                @programs_map[char] = p
            end
        end
        @instructions = Instructions.new(data)
    end

    def process_instructions()
        @programs, @programs_map = @instructions.run(@programs, @programs_map)
    end

    def get_output
        output = ""
        @programs.each do |program|
            output += program.name
        end        
        output
    end
end

def test_part1    
    instructions = "s1,x3/4,pe/b"
    group = Group.new(5, instructions)    
    programs = group.process_instructions()
    output = group.get_output    
    if output != "baedc"
        puts "ERROR"
    end
end

def part1
    data = read_file('../data/day16.txt')
    group = Group.new(nil, data[0])
    programs = group.process_instructions()
    puts group.get_output
end

def test_part2
    instructions = "s1,x3/4,pe/b"
    group = Group.new(5, instructions)    
    for i in 1..1000        
        group.process_instructions()
    end
    output = group.get_output
    puts output    
end

def part2
    data = read_file('../data/day16.txt')
    group = Group.new(nil, data[0])
    for i in 1..1000000000
        puts i
        group.process_instructions()
    end
    puts group.get_output
end

test_part1
part1
part2