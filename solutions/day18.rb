require_relative 'lib/file_reader.rb'

class Register
    attr_accessor :name, :value
    def initialize(name, value)
        @name = name
        @value = value
    end
end

class Program
    attr_accessor :waiting, :current, :data, :id, :queue
    def initialize(data, id)
        @id = id
        @registers = {}
        @last_sound = nil
        @current = 0
        @data = data
        @waiting = false
        @queue = []
    end

    def run
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
            register.value += value
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

    def process_with_other(duet)
        line = @data[@current] 
        line = line.split(" ")        
        instruction = line[0].strip  
        register = get_register(line[1].strip)      
        value = get_value(line[2])
        puts "#{@id}: #{@current} #{instruction} #{register} #{value} #{@queue.size}"
        if instruction == "snd"            
            duet.send_message(self, register.value)
            @current = @current + 1
        elsif instruction == "set"
            register.value = value
            @current = @current + 1
        elsif instruction == "add"
            register.value += value
            @current = @current + 1
        elsif instruction == "mul"
            register.value = register.value * value
            @current = @current + 1
        elsif instruction == "mod"
            register.value = register.value % value
            @current = @current + 1
        elsif instruction == "rcv"            
            if @queue.size > 0                            
                register.value = @queue.shift
                @current = @current + 1
            else                               
                @waiting = true
            end                               
        elsif instruction == "jgz"
            if register.value > 0
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
                if register == "p"
                    value = @id
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

class Duet
    attr_accessor :programs
    def initialize(data)
        @p1 = Program.new(data, 0)
        @p2 = Program.new(data, 1)
        @programs = {}
        @programs[@p1.id] = @p1
        @programs[@p2.id] = @p2
        @messages_sent = {}
        @messages_sent[@p1.id] = 0
        @messages_sent[@p2.id] = 0        
    end

    def send_message(p, value) 
        @messages_sent[p.id] += 1
        @programs.each_key do |key|
            if key != p.id
                @programs[key].queue << value
                @programs[key].waiting = false
            end
        end
    end

    def run
        while true            
            p1_run = p2_run = false
            while !@p1.waiting && @p1.current >= 0 && @p1.current < @p1.data.size
                p1_run = true                
                @p1.process_with_other(self)             
            end            
            while !@p2.waiting && @p2.current >= 0 && @p2.current < @p2.data.size                
                p2_run = true
                @p2.process_with_other(self)                
            end
            if p1_run == false && p2_run == false
                puts @messages_sent  
                return @messages_sent[@p2.id]
            end
        end
    end

end

def part1
    data = read_file('../data/day18.txt')
    program = Program.new(data, 0)
    sound = program.run
    puts sound
end

def part2(file)
    data = read_file(file)
    duet = Duet.new(data)
    messages = duet.run
    puts messages    
end

#part1
#part2 '../data/day18_test.txt'
part2 '../data/day18.txt'

