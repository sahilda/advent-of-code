=begin
--- Day 11: Hex Ed ---

Crossing the bridge, you've barely reached the other side of the stream when a program comes up to you, clearly in distress. "It's my child process," she says, "he's gotten lost in an infinite grid!"

Fortunately for her, you have plenty of experience with infinite grids.

Unfortunately for you, it's a hex grid.

The hexagons ("hexes") in this grid are aligned such that adjacent hexes can be found to the north, northeast, southeast, south, southwest, and northwest:

  \ n  /
nw +--+ ne
  /    \
-+      +-
  \    /
sw +--+ se
  / s  \
You have the path the child process took. Starting where he started, you need to determine the fewest number of steps required to reach him. (A "step" means to move from the hex you are in to any adjacent hex.)

For example:

ne,ne,ne is 3 steps away.
ne,ne,sw,sw is 0 steps away (back where you started).
ne,ne,s,s is 2 steps away (se,se).
se,sw,se,sw,sw is 3 steps away (s,s,sw).
Your puzzle answer was 824.

--- Part Two ---

How many steps away is the furthest he ever got from his starting position?

Your puzzle answer was 1548.
=end

require_relative 'lib/file_reader.rb'

def get_total_distance_traveled(movement)
    net_north = 0
    net_east = 0
    max_distance = 0
    movement.split(",").each do |move|
        if move == "ne"
            net_north += 0.5
            net_east += 1
        elsif move == "n"
            net_north += 1            
        elsif move == "nw"
            net_north += 0.5
            net_east -= 1
        elsif move == "sw"
            net_north -= 0.5
            net_east -= 1
        elsif move == "se"
            net_north -= 0.5
            net_east += 1
        elsif move == "s"
            net_north -= 1            
        end        
        if get_distance_to_travel(net_north, net_east) > max_distance
            max_distance = get_distance_to_travel(net_north, net_east)
        end        
    end
    return net_north, net_east, max_distance
end

def get_distance_to_travel(north, east)
    if east.abs >= north.abs
        return east.abs
    else
        return east.abs + north.abs - east.abs * 0.5
    end
end

def part_1(movement)
    north, east, max_distance = get_total_distance_traveled(movement)
    distance = get_distance_to_travel(north, east)
    distance
end

def part_2(movement)
    north, east, max_distance = get_total_distance_traveled(movement)
    max_distance    
end

data = read_file("../data/day11.txt")
puts part_1(data[0])
puts part_2(data[0])