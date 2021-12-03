=begin
--- Day 8: I Heard You Like Registers ---

You receive a signal directly from the CPU. Because of your recent assistance with jump instructions, it would like you to compute the result of a series of unusual register instructions.

Each instruction consists of several parts: the register to modify, whether to increase or decrease that register's value, the amount by which to increase or decrease it, and a condition. If the condition fails, skip the instruction without modifying the register. The registers all start at 0. The instructions look like this:

b inc 5 if a > 1
a inc 1 if b < 5
c dec -10 if a >= 1
c inc -20 if c == 10
These instructions would be processed as follows:

Because a starts at 0, it is not greater than 1, and so b is not modified.
a is increased by 1 (to 1) because b is less than 5 (it is 0).
c is decreased by -10 (to 10) because a is now greater than or equal to 1 (it is 1).
c is increased by -20 (to -10) because c is equal to 10.
After this process, the largest value in any register is 1.

You might also encounter <= (less than or equal to) or != (not equal to). However, the CPU doesn't have the bandwidth to tell you what all the registers are named, and leaves that to you to determine.

What is the largest value in any register after completing the instructions in your puzzle input?

Your puzzle answer was 4832.

--- Part Two ---

To be safe, the CPU also needs to know the highest value held in any register during this process so that it can decide how much memory to allocate to these operations. For example, in the above instructions, the highest value ever held was 10 (in register c after the third instruction was evaluated).

Your puzzle answer was 5443.
=end

require_relative 'lib/file_reader.rb'

class Register
    attr_accessor :name, :value
    def initialize(name)
        @name = name
        @value = 0
    end

    def print
        puts "#{@name} #{@value}"
    end
end

class Instruction
    attr_accessor :current_max

    def initialize(instruction, registers)
        @current_max = nil
        self.process_instruction(instruction, registers)
    end

    def process_instruction(instruction, registers)
        self.read_instruction(instruction)
        if self.valid_condition?(registers)
            self.apply_effect(registers)
        end
        self.set_max(registers)
    end

    def read_instruction(instruction)
        out = []
        @effect = instruction.split("if")[0].split(" ")
        @condition = instruction.split("if")[1].split(" ")
    end

    def valid_condition?(registers)        
        register = registers[@condition[0].strip]
        value = @condition[2].strip.to_i
        action = @condition[1].strip
        if action == ">"
            return register.value > value
        elsif action == ">="
            return register.value >= value
        elsif action == "<"
            return register.value < value
        elsif action == "<="
            return register.value <= value
        elsif action == "=="
            return register.value == value
        elsif action == "!="
            return register.value != value
        else
            return false
        end
    end

    def apply_effect(registers)
        register = registers[@effect[0].strip]
        action = @effect[1].strip
        value = @effect[2].strip.to_i
        if action == "inc"
            register.value = register.value + value
        elsif action == "dec"
            register.value = register.value - value
        end
    end

    def set_max(registers)
        registers.each_key do |name|
            register = registers[name]
            if @current_max == nil || register.value > @current_max
                @current_max = register.value
            end
        end
    end
        
end

def get_registers(data)
    registers = {}
    data.each do |line|
        register_name = line.split(" ")[0].strip
        register = Register.new(register_name)
        registers[register_name] = register
    end
    registers
end

def run_instructions(data)
    registers = get_registers(data)
    max_memory = nil
    data.each do |line|
        instruction = Instruction.new(line, registers)
        if max_memory == nil || instruction.current_max > max_memory
            max_memory = instruction.current_max
        end
    end
    puts "Max memory: #{max_memory}"
    registers
end

def find_largest_register(registers)
    max = nil
    registers.each_key do |name|
        register = registers[name]
        if max == nil || register.value > max.value
            max = register
        end
    end
    max
end

data = read_file('../data/day8.txt')
registers = run_instructions(data)
register = find_largest_register(registers)
register.print