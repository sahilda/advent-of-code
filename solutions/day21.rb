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
        input = rotate(input)        
        book[input] = output
        book[flip(input)] = output
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
        output << row
        output << '/'
    end
    output.join()[0...-1]
end

def generate_art(file, repeat)
    book = build_book(file)
    pattern = '.#./..#/###'
    repeat.times do
        pattern = pattern.split('/')        
        output = []
        size = pattern[0].size % 2 == 0 ? 2 : 3
        cur_x = 0
        cur_y = 0        
        while cur_y < pattern[0].size
            while cur_x < pattern[0].size
                block = []
                for x in cur_x...(cur_x + size)
                    puts x           
                    block << pattern[x][cur_y...cur_y+size]
                end
                new_block = book[block.join('/')].split('/')
                i = 0
                for x in cur_x...(cur_x + size)
                    if output[x] == nil
                        output[x] = []
                    end
                    output[x] << new_block[i]
                    i += 1
                end
                cur_x += size
            end
            cur_y += size
        end
        pattern = output.join('/')
    end
    pattern
end

test = generate_art('../data/day21_test.txt', 2)
puts test
#generate_art('../data/day21.txt', 5)
