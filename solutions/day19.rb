=begin
--- Day 19: A Series of Tubes ---
Somehow, a network packet got lost and ended up here. It's trying to follow a routing diagram (your puzzle input), but it's confused about where to go.

Its starting point is just off the top of the diagram. Lines (drawn with |, -, and +) show the path it needs to take, starting by going down onto the only line connected to the top of the diagram. It needs to follow this path until it reaches the end (located somewhere within the diagram) and stop there.

Sometimes, the lines cross over each other; in these cases, it needs to continue going the same direction, and only turn left or right when there's no other option. In addition, someone has left letters on the line; these also don't change its direction, but it can use them to keep track of where it's been. For example:

     |          
     |  +--+    
     A  |  C    
 F---|----E|--+ 
     |  |  |  D 
     +B-+  +--+ 

Given this diagram, the packet needs to take the following path:

Starting at the only line touching the top of the diagram, it must go down, pass through A, and continue onward to the first +.
Travel right, up, and right, passing through B in the process.
Continue down (collecting C), right, and up (collecting D).
Finally, go all the way left through E and stopping at F.
Following the path to the end, the letters it sees on its path are ABCDEF.

The little packet looks up at you, hoping you can help it find the way. What letters will it see (in the order it would see them) if it follows the path? (The routing diagram is very wide; make sure you view it without line wrapping.)

Your puzzle answer was PBAZYFMHT.

--- Part Two ---
The packet is curious how many steps it needs to go.

For example, using the same routing diagram from the example above...

     |          
     |  +--+    
     A  |  C    
 F---|--|-E---+ 
     |  |  |  D 
     +B-+  +--+ 

...the packet would go:

6 steps down (including the first line at the top of the diagram).
3 steps right.
4 steps up.
3 steps right.
4 steps down.
3 steps right.
2 steps up.
13 steps left (including the F it stops on).
This would result in a total of 38 steps.

How many steps does the packet need to go?

Your puzzle answer was 16072.
=end

require_relative 'lib/file_reader.rb'

def clean_maze(input)
    maze = []
    input.each do |line|
        l = line.split("")
        maze << l
    end
    maze
end

def find_start(maze)
    top = maze[0]
    top.each_with_index do |char, idx|
        if char == "|"
            return idx, 0, "s"
        end
    end
end

def get_char(maze, x, y)
    return maze[y][x]
end

def on_maze?(maze, x, y)
    if x < 0 || y < 0 || x >= maze[0].size || y >= maze.size
        return false
    end
    true
end

def maze_solved?(maze, x, y)
    if !on_maze?(maze, x, y)
        return true
    elsif get_char(maze, x, y) == " "
        return true
    end
end

def get_next_straight_position(x, y, dir)
    if dir == "s"
        return x, y + 1, "s"
    elsif dir == "n"
        return x, y - 1, "n"
    elsif dir == "w"
        return x - 1, y, "w"
    elsif dir == "e"
        return x + 1, y, "e"
    end
end

def get_next_turn_position(maze, x, y, dir)
    if dir == "s" || dir == "n"
        wx, wy, wdir = get_next_straight_position(x, y, "w")
        if on_maze?(maze, wx, wy) && get_char(maze, wx, wy) == "-"
            return wx, wy, wdir
        end
        ex, ey, edir = get_next_straight_position(x, y, "e")
        if on_maze?(maze, ex, ey) && get_char(maze, ex, ey) == "-"
            return ex, ey, edir
        end
    elsif dir == "w" || dir == "e"
        nx, ny, ndir = get_next_straight_position(x, y, "n")
        if on_maze?(maze, nx, ny) && get_char(maze, nx, ny) == "|"
            return nx, ny, ndir
        end
        sx, sy, sdir = get_next_straight_position(x, y, "s")
        if on_maze?(maze, sx, sy) && get_char(maze, sx, sy) == "|"
            return sx, sy, sdir
        end
    end
end

def solve_maze(input)
    maze = clean_maze(input)
    x, y, dir = find_start(maze)
    letters = []
    steps = 0
    while true
        current = get_char(maze, x, y)
        steps += 1
        puts "#{x}, #{y}, #{dir}, #{current}"
        if !current.match(/[A-Za-z]/).nil?
            letters << current
        end
        if current == "|" || current == "-" || !current.match(/[A-Za-z]/).nil?
            x, y, dir = get_next_straight_position(x, y, dir)
        elsif current == "+"
            x, y, dir = get_next_turn_position(maze, x, y, dir)
        end
        if maze_solved?(maze, x, y)
            break
        end
    end
    return letters, steps
end

def part_1_and_2
    input = read_file('../data/day19.txt')
    letters, steps = solve_maze(input)
    puts letters.join("")
    puts steps
end

part_1_and_2