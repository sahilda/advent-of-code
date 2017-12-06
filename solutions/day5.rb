require_relative 'lib/file_reader.rb'

def follow_instructions(data, part2)
    current = 0
    steps = 0
    while current >= 0 && current < data.size
        steps += 1
        prev = current
        current += data[current].to_i
        if part2 && data[prev].to_i >= 3
            data[prev] = data[prev].to_i - 1
        else
            data[prev] = data[prev].to_i + 1
        end        
    end
    steps
end

data = read_file("../data/day5.txt")
puts follow_instructions(data, false)
data = read_file("../data/day5.txt")
puts follow_instructions(data, true)
