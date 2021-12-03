=begin
--- Day 3: Spiral Memory ---

You come across an experimental new kind of memory stored on an infinite two-dimensional grid.

Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and then counting up while spiraling outward. For example, the first few squares are allocated like this:

17  16  15  14  13
18   5   4   3  12
19   6   1   2  11
20   7   8   9  10
21  22  23---> ...
While this is very space-efficient (no squares are skipped), requested data must be carried back to square 1 (the location of the only access port for this memory system) by programs that can only move up, down, left, or right. They always take the shortest path: the Manhattan Distance between the location of the data and square 1.

For example:

Data from square 1 is carried 0 steps, since it's at the access port.
Data from square 12 is carried 3 steps, such as: down, left, left.
Data from square 23 is carried only 2 steps: up twice.
Data from square 1024 must be carried 31 steps.
How many steps are required to carry the data from the square identified in your puzzle input all the way to the access port?

Your puzzle answer was 552.

--- Part Two ---

As a stress test on the system, the programs here clear the grid and then store the value 1 in square 1. Then, in the same allocation order as shown above, they store the sum of the values in all adjacent squares, including diagonals.

So, the first few squares' values are chosen as follows:

Square 1 starts with the value 1.
Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
Square 4 has all three of the aforementioned squares as neighbors and stores the sum of their values, 4.
Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.
Once a square is written, its value does not change. Therefore, the first few squares would receive the following values:

147  142  133  122   59
304    5    4    2   57
330   10    1    1   54
351   11   23   25   26
362  747  806--->   ...
What is the first value written that is larger than your puzzle input?

Your puzzle answer was 330785.
=end

def get_square_before(num)
    root = Math.sqrt(num).to_i
    if (root % 2 == 0)
        return root - 1
    end
    return root
end

def get_square_after(num)
    root = Math.sqrt(num)
    if root % 2 != 0 && root == root.to_i
        return root
    end
    root = root.to_i
    if (root % 2 == 0)
        return root + 1
    else
        return root + 2
    end
end

def get_position_in_square(num)
    if num == 1
        return 0
    end
    b = get_square_before(num)
    a = get_square_after(num)
    x = (a - 1) / 2
    y = (b - 1) / 2 * -1
    cur = b ** 2 + 1
    dir = "up"    
    while cur != num        
        if dir == "up"
            y += 1
            if y == (a - 1) / 2
                dir = "left" 
            end
        elsif dir == "left"
            x -= 1
            if x == (a - 1) / 2 * -1
                dir = "down"
            end
        elsif dir == "down"
            y -= 1
            if y == (a - 1) / 2 * -1
                dir = "right"
            end
        else dir == "right"
            x += 1
        end
        cur += 1
    end
    x.abs + y.abs
end

Point = Struct.new(:x, :y)
def make_grid_up_to(num)    
    map = {}
    square = 1
    point = Point.new(0,0)
    while true
        point = draw_square(map, square, point)
        if map[Point.new(point.x - 1, point.y)] > num
            return find_next_val(map, num)
        end
        square += 1
    end
    map
end

def draw_square(map, square, point)
    if (map.size == 0)
        map[point]=1
        point = Point.new(point.x + 1, point.y)
    else
        side_size = square * 2 - 1
        for up in 1...(side_size-1)
            val = get_value(map, point)
            map[point] = val
            point = Point.new(point.x, point.y + 1)
        end

        for left in 1...side_size
            val = get_value(map, point)
            map[point] = val
            point = Point.new(point.x - 1, point.y)
        end

        for down in 1...side_size
            val = get_value(map, point)
            map[point] = val
            point = Point.new(point.x, point.y - 1)
        end

        for right in 1...(side_size+1)
            val = get_value(map, point)
            map[point] = val
            point = Point.new(point.x + 1, point.y)
        end
    end
    point
end

def get_value(map, point)
    x = point.x
    y = point.y
    if x == 0 && y == 0
        return 1
    end
    val = get_point_val(map, x - 1, y) + get_point_val(map, x - 1, y - 1) + get_point_val(map, x - 1, y + 1) + 
    get_point_val(map, x + 1, y) + get_point_val(map, x + 1, y - 1) + get_point_val(map, x + 1, y + 1) +
    get_point_val(map, x, y - 1) + get_point_val(map, x, y + 1)
    val
end

def get_point_val(map, x, y)
    point = Point.new(x,y)
    if map[point].nil?
        return 0
    end
    map[point]
end

def print_map(map)
    output = []
    map.each_key do |point|
        output << map[point]
    end
    puts output.sort.join(" ")
end

def find_next_val(map, val)
    output = []
    map.each_key do |point|
        output << map[point]
    end
    output.sort.each do |num|
        if num > val
            return num
        end
    end
end

puts get_position_in_square(325489)
puts make_grid_up_to(325489)
