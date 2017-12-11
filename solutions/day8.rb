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