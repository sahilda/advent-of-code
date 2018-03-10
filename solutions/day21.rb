require_relative 'lib/file_reader.rb'

def build_book(file)
    input = read_file(file)
    book = {}
    input.each do |line|
        read_line(book, line)
    end
    book
end

def read_line(book, line)
    input = line.split("=>")[0].strip
    output = line.split("=>")[1].strip
    book = get_flips_and_rotates(book, input, output)    
    book
end

def get_flips_and_rotates(book, input, output)    
    4.times do        
        book[input] = output        
        book[flip(input)] = output
        input = rotate(input)
    end
    book
end

def flip(pattern)
    split = pattern.split('/')
    flip = []
    split.each do |s|
        flip << s.reverse
    end
    flip.join('/')
end

def rotate(input)     
    split = input.split('/')
    size = split[0].size
    output = []    
    0.upto(size-1) do |x|
        row = []
        (size-1).downto(0) do |y|
            row << split[y][x]
        end      
        output << row.join('')
    end
    output.join('/')
end

def count_on(pattern)
    count = 0
    pattern.split('').each { |l| count += 1 if l == "#" }
    count
end

def generate_art(file, repeat)
    book = build_book(file)
    pattern = '.#./..#/###'
    repeat.times do
        pattern = pattern.split('/')    
        size = pattern[0].size    
        new_pattern = []
        break_size = pattern[0].size % 2 == 0 ? 2 : 3
        cur_x = 0

        while cur_x < size
            cur_y = 0
            temp = []
            while cur_y < size
                block = []
                for x in cur_x...(cur_x + break_size)
                    block << pattern[x][cur_y...cur_y + break_size]
                end
                new_block = book[block.join('/')].split('/')
                #p new_block
                temp << new_block
                cur_y += break_size
            end
            new_pattern << temp.transpose.map { |x| x.reduce(:+) }
            cur_x += break_size
        end
        pattern = new_pattern.join('/')
    end
    pattern
    count_on(pattern)
end

test = generate_art('../data/day21_test.txt', 2)
puts test
part1 = generate_art('../data/day21.txt', 5)
puts part1
part2 = generate_art('../data/day21.txt', 18)
puts part2
