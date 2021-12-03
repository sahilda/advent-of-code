=begin
--- Day 16: Permutation Promenade ---
You come upon a very unusual sight; a group of programs here appear to be dancing.

There are sixteen programs in total, named a through p. They start by standing in a line: a stands in position 0, b stands in position 1, and so on until p, which stands in position 15.

The programs' dance consists of a sequence of dance moves:

Spin, written sX, makes X programs move from the end to the front, but maintain their order otherwise. (For example, s3 on abcde produces cdeab).
Exchange, written xA/B, makes the programs at positions A and B swap places.
Partner, written pA/B, makes the programs named A and B swap places.
For example, with only five programs standing in a line (abcde), they could do the following dance:

s1, a spin of size 1: eabcd.
x3/4, swapping the last two programs: eabdc.
pe/b, swapping programs e and b: baedc.
After finishing their dance, the programs end up in order baedc.

You watch the dance for a while and record their dance moves (your puzzle input). In what order are the programs standing after their dance?

Your puzzle answer was kpfonjglcibaedhm.

--- Part Two ---
Now that you're starting to get a feel for the dance moves, you turn your attention to the dance as a whole.

Keeping the positions they ended up in from their previous dance, the programs perform it again and again: including the first dance, a total of one billion (1000000000) times.

In the example above, their second dance would begin with the order baedc, and use the same dance moves:

s1, a spin of size 1: cbaed.
x3/4, swapping the last two programs: cbade.
pe/b, swapping programs e and b: ceadb.
In what order are the programs standing after their billion dances?

Your puzzle answer was odiabmplhfgjcekn.
=end

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
        elsif instruction.include?("x")
            i = Swap.new(instruction)
            @instructions << i            
        elsif instruction.include?("p")
            i = SwapName.new(instruction)
            @instructions << i                   
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
    end

    def do_action(programs, programs_map)        
        programs = programs[(-1 * @num)..-1] + programs[0...(programs.size - @num)]
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
    group.process_instructions()
    output = group.get_output    
    if output != "baedc"
        puts "ERROR"
    end
end

def part1
    data = read_file('../data/day16.txt')
    group = Group.new(nil, data[0])     
    group.process_instructions()
    puts group.get_output
end

def part2
    data = read_file('../data/day16.txt')
    group = Group.new(nil, data[0])
    memory = {}    
    for i in 1..1000000000
        if memory[group.get_output] == nil                
            key = group.get_output
            programs, programs_map = group.process_instructions()
            memory[key] = group.get_output
        else
            cycle = i - 1
            next_group = group.get_output            
            for j in 1..(1000000000 % cycle)                
                next_group = memory[next_group]
            end
            puts next_group
            break
        end
    end    
end

test_part1
part1
part2