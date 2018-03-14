require_relative 'lib/file_reader.rb'
require 'prime'

class Register
    attr_accessor :name, :value
    def initialize(name, value)
        @name = name
        @value = value
    end
end

class Program
    attr_accessor :waiting, :current, :data
    def initialize(data, value)
        @registers = {}
        @last_sound = nil
        @current = 0
        @data = data
        @waiting = false
        @mul_count = 0
        @a_value = value
        @primes = 0
    end

    def run
        while true
            if @current < 0 || @current >= @data.size
                return @mul_count
            end
            line = @data[@current]
            process(line)            
        end
    end

    def run2
        while true
            if @current < 0 || @current >= @data.size
                return @registers['h'].value - @primes
            end
            line = @data[@current]            
            process(line)   
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
        elsif instruction == "sub"
            register.value -= value
            if register.name == "b" && register.value.prime?
                @primes += 1
            end
            @current = @current + 1
        elsif instruction == "add"
            register.value += value
            @current = @current + 1
        elsif instruction == "mul"
            register.value = register.value * value
            @mul_count += 1
            @current = @current + 1
        elsif instruction == "mod"
            register.value = register.value % value
            @current = @current + 1
        elsif instruction == "rcv"
            @current = @current + 1
        elsif instruction == "jgz"
            if register.value > 0
                @current = @current + value
            else
                @current = @current + 1
            end
        elsif instruction == "jnz"
            if register.value != 0
                @current = @current + value
            else
                @current = @current + 1
            end
        end
    end

    def get_register(register)
        if register.match(/\d+/) == nil
            if @registers[register] == nil
                value = 0
                if register == "a"
                    value = @a_value
                end
                reg = Register.new(register, value)
                @registers[register] = reg
                return reg
            end
            return @registers[register]
        else
            return Register.new(register, register.to_i)
        end
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

def part1(file)
    data = read_file(file)
    program = Program.new(data, 0)
    count = program.run
    puts count
end

def part2(file)
    data = read_file(file)
    program = Program.new(data, 0)
    h = program.run2
    puts h
end

#part1 '../data/day23.txt'
part2 '../data/day23_b.txt'
