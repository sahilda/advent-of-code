=begin
--- Day 2: Corruption Checksum ---

As you walk through the door, a glowing humanoid shape yells in your direction. "You there! Your state appears to be idle. Come help us repair the corruption in this spreadsheet - if we take another millisecond, we'll have to display an hourglass cursor!"

The spreadsheet consists of rows of apparently-random numbers. To make sure the recovery process is on the right track, they need you to calculate the spreadsheet's checksum. For each row, determine the difference between the largest value and the smallest value; the checksum is the sum of all of these differences.

For example, given the following spreadsheet:

5 1 9 5
7 5 3
2 4 6 8
The first row's largest and smallest values are 9 and 1, and their difference is 8.
The second row's largest and smallest values are 7 and 3, and their difference is 4.
The third row's difference is 6.
In this example, the spreadsheet's checksum would be 8 + 4 + 6 = 18.

What is the checksum for the spreadsheet in your puzzle input?

Your puzzle answer was 44216.

--- Part Two ---

"Great work; looks like we're on the right track after all. Here's a star for your effort." However, the program seems a little worried. Can programs be worried?

"Based on what we're seeing, it looks like all the User wanted is some information about the evenly divisible values in the spreadsheet. Unfortunately, none of us are equipped for that kind of calculation - most of us specialize in bitwise operations."

It sounds like the goal is to find the only two numbers in each row where one evenly divides the other - that is, where the result of the division operation is a whole number. They would like you to find those numbers on each line, divide them, and add up each line's result.

For example, given the following spreadsheet:

5 9 2 8
9 4 7 3
3 8 6 5
In the first row, the only two numbers that evenly divide are 8 and 2; the result of this division is 4.
In the second row, the two numbers are 9 and 3; the result is 3.
In the third row, the result is 2.
In this example, the sum of the results would be 4 + 3 + 2 = 9.

What is the sum of each row's result in your puzzle input?

Your puzzle answer was 320.
=end
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
