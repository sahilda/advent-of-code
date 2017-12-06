require_relative 'lib/file_reader.rb'
require 'set'

data = read_file("../data/day6.txt")

def redistribute(data)
    max = 0
    max_idx = 0
    data.each_with_index do |num,idx|
        num = num.to_i
        if num > max
            max = num
            max_idx = idx
        end
    end
    data[max_idx] = 0
    for idx in 0...max        
        data[(max_idx + idx + 1) % data.size] = data[(max_idx + idx + 1) % data.size].to_i + 1
    end
    data
end

def reallocate_memory(data, get_loop_size)
    data = data[0].split(" ")
    states = {data => 0}
    cycles = 1
    while true        
        data = redistribute(data)
        if (states.has_key?(data))
            if get_loop_size
                return cycles - states[data]
            end
            return cycles
        end
        states[data] = cycles
        cycles += 1
    end
end

puts reallocate_memory(data, false)
puts reallocate_memory(data, true)
