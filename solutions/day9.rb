require_relative 'lib/file_reader.rb'

data = read_file("../data/day9.txt")

def remove_garbage(data, get_count)
    output = ""
    garbage = false
    ignore_next = false
    garbage_count = 0
    data.each_char do |char|
        if ignore_next
            ignore_next = false
        elsif !garbage && char == "<"
            garbage = true
        elsif garbage && char == "!"
            ignore_next = true
        elsif garbage && char == ">"
            garbage = false
        elsif garbage
            garbage_count += 1
        else
            output += char
        end
    end
    if get_count
        return garbage_count
    end
    output
end

def count_group_scores(data)
    score = 0
    current = 0
    data.each_char do |char|
        if char == "{"
            current += 1
        elsif char == "}"
            score += current
            current -= 1
        end
    end
    score
end

def get_group_score(data)
    data = remove_garbage(data, false)
    score = count_group_scores(data)
    score
end

puts get_group_score(data[0])
puts remove_garbage(data[0], true)