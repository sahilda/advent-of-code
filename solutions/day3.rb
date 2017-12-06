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
