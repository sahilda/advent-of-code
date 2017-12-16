=begin
--- Day 14: Disk Defragmentation ---
Suddenly, a scheduled job activates the system's disk defragmenter. Were the situation different, you might sit and watch it for a while, but today, you just don't have that kind of time. It's soaking up valuable system resources that are needed elsewhere, and so the only option is to help it finish its task as soon as possible.

The disk in question consists of a 128x128 grid; each square of the grid is either free or used. On this disk, the state of the grid is tracked by the bits in a sequence of knot hashes.

A total of 128 knot hashes are calculated, each corresponding to a single row in the grid; each hash contains 128 bits which correspond to individual grid squares. Each bit of a hash indicates whether that square is free (0) or used (1).

The hash inputs are a key string (your puzzle input), a dash, and a number from 0 to 127 corresponding to the row. For example, if your key string were flqrgnkx, then the first row would be given by the bits of the knot hash of flqrgnkx-0, the second row from the bits of the knot hash of flqrgnkx-1, and so on until the last row, flqrgnkx-127.

The output of a knot hash is traditionally represented by 32 hexadecimal digits; each of these digits correspond to 4 bits, for a total of 4 * 32 = 128 bits. To convert to bits, turn each hexadecimal digit to its equivalent binary value, high-bit first: 0 becomes 0000, 1 becomes 0001, e becomes 1110, f becomes 1111, and so on; a hash that begins with a0c2017... in hexadecimal would begin with 10100000110000100000000101110000... in binary.

Continuing this process, the first 8 rows and columns for key flqrgnkx appear as follows, using # to denote used squares, and . to denote free ones:

##.#.#..-->
.#.#.#.#   
....#.#.   
#.#.##.#   
.##.#...   
##..#..#   
.#...#..   
##.#.##.-->
|      |   
V      V   
In this example, 8108 squares are used across the entire 128x128 grid.

Given your actual key string, how many squares are used?

Your puzzle answer was 8230.

--- Part Two ---
Now, all the defragmenter needs to know is the number of regions. A region is a group of used squares that are all adjacent, not including diagonals. Every used square is in exactly one region: lone used squares form their own isolated regions, while several adjacent squares all count as a single region.

In the example above, the following nine regions are visible, each marked with a distinct digit:

11.2.3..-->
.1.2.3.4   
....5.6.   
7.8.55.9   
.88.5...   
88..5..8   
.8...8..   
88.8.88.-->
|      |   
V      V   
Of particular interest is the region marked 8; while it does not appear contiguous in this small view, all of the squares marked 8 are connected when considering the whole 128x128 grid. In total, in this example, 1242 regions are present.

How many regions are present given your key string?

Your puzzle answer was 1103.
=end

require_relative 'day10.rb'

def get_knot_hashes(data)
    knot_hashes = []
    for n in 0..127
        input = "#{data}-#{n}"
        knot_hashes << get_hash(input)
    end
    knot_hashes
end

def convert_knot_hash_to_bits(knot_hash)
    output = []
    knot_hash.each_char do |c|
        bit = c.hex.to_s(2)
        while bit.size < 4
            bit = "0" + bit
        end
        output << bit
    end
    output.join("")
end

def convert_bits_to_print(bits)
    output = []
    bits.each_char do |c|
        if c == "1"
            output << "#"
        elsif c == "0"
            output << "."
        end
    end
    output.join("")
end

def convert_string_to_square_grid(input)
    grid = []
    knot_hashes = get_knot_hashes(input)
    knot_hashes.each do |kh|
        bits = convert_knot_hash_to_bits(kh)
        line = convert_bits_to_print(bits)
        grid << line
    end
    grid
end

def count_regions(grid)
    regions = 0
    max_y = grid.size
    max_x = grid[0].size
    for y in 0...max_y
        for x in 0...max_x        
            if grid[y][x] == "#"                
                regions += 1
                grid = map_out_region(grid, x, y, ".")                
            end
        end
    end
    regions
end

def map_out_region(grid, x, y, num)
    if x < 0 || x >= grid[0].size || y < 0 || y >= grid.size || grid[y][x] != "#"
        return grid
    end
    grid[y][x] = "#{num}"
    grid = map_out_region(grid, x + 1, y, num)
    grid = map_out_region(grid, x - 1, y, num)
    grid = map_out_region(grid, x, y + 1, num)
    grid = map_out_region(grid, x, y - 1, num)
    return grid
end

def get_part_1(input)
    grid = convert_string_to_square_grid(input)
    squares = 0
    grid.each do |line|
        line.each_char do |c|
            if c == "#"
                squares += 1
            end
        end
    end
    puts squares
end

def get_part_2(input)
    grid = convert_string_to_square_grid(input)
    regions = count_regions(grid)    
    puts regions
end

test_input = "flqrgnkx"
input = "hfdlxzhv"

get_part_1(input)
get_part_2(input)