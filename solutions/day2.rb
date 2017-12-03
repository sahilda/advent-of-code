data = []
File.open("../data/day2.txt", "r") do |f|
    f.each_line do |line|
        data << line
    end
end

def getLineMaxMinDiff(line)
    nums = line.split(" ")
    min = nums[0].to_i
    max = nums[0].to_i
    nums.each do |num|
        num = num.to_i
        if num > max
            max = num
        end
        if num < min
            min = num
        end
    end
    max - min
end

def getEvenlyDivisbleNumber(line)
    nums = line.split(" ")
    nums.each_with_index do |num1, idx1|
        num1 = num1.to_i
        for idx2 in (idx1 + 1)...nums.size
            num2 = nums[idx2].to_i
            if num1 % num2 == 0
                return num1 / num2
            elsif num2 % num1 == 0
                return num2 / num1
            end
        end
    end
    -1
end

def getChecksum(func, data)
    sum = 0
    data.each do |line|
        sum += func.call(line)
    end
    sum
end

puts getChecksum(method(:getLineMaxMinDiff), data)
puts getChecksum(method(:getEvenlyDivisbleNumber), data)
