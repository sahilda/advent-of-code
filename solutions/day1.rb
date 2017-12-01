data = []

File.open("../data/day1.txt", "r") do |f|
    f.each_line do |line|
        data << line
    end
end

def getInputSum(input, place)
    data = input.split("")
    sum = 0
    data.each_with_index do | num, idx |
        if (idx + place + 1 > data.size)
            if (num == data[idx + place - data.size])
                sum += num.to_i
            end
        else            
            if (num == data[idx + place])
                sum += num.to_i
            end
        end        
    end
    sum
end

puts getInputSum(data[0], 1)

def getHalf(input)
    data = input.split("")
    data.size / 2
end

puts getInputSum(data[0], getHalf(data[0]))
