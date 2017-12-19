require_relative 'lib/file_reader.rb'

class Register
    attr_accessor :name, :value
    def initialize(name, value)
        @name = name
        @value = value
    end
end

class Registers
    def initialize(data)
        @registers = {}
        @last_sound = nil
        @current = 0
        @data = data
    end

    def run()
        while true
            if @current < 0 || @current >= @data.size
                return @last_sound
            end
            line = @data[@current]
            out = process(line)
            if out
                return @last_sound
            end
        end
    end

    def process(line)        
        line = line.split(" ")
        instruction = line[0].strip
        register = get_register(line[1].strip)
        value = get_value(line[2])
        if instruction == "snd"            
            @last_sound = register.value
            @current = @current + 1
        elsif instruction == "set"
            register.value = value
            @current = @current + 1
        elsif instruction == "add"
            register.value = register.value + value
            @current = @current + 1
        elsif instruction == "mul"
            register.value = register.value * value
            @current = @current + 1
        elsif instruction == "mod"
            register.value = register.value % value
            @current = @current + 1
        elsif instruction == "rcv"            
            if register.value != 0
                return true
            end
            @current = @current + 1
        elsif instruction == "jgz"
            if register.value > 0
                @current = @current + value
            else
                @current = @current + 1
            end
        end
        return false
    end

    def get_register(register)
        if @registers[register] == nil
            reg = Register.new(register, 0)
            @registers[register] = reg
            return reg
        end
        return @registers[register]
    end

    def get_value(value)
        if value == nil
            return nil
        end        
        if value.match(/\d+/) == nil
            return get_register(value).value
        else
            return value.to_i
        end
    end
end

def part1
    data = read_file('../data/day18.txt')
    registers = Registers.new(data)
    sound = registers.run
    puts sound
end

part1

