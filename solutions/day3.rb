def getSquareBefore(num)
    root = Math.sqrt(num).to_i
    if (root % 2 == 0)
        return root - 1
    end
    return root
end

def getSquareAfter(num)
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

def getPositionInSquare(num)
    if num == 1
        return 0
    end
    b = getSquareBefore(num)
    a = getSquareAfter(num)
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

puts getPositionInSquare(325489)

class Point
    attr_reader :x, :y
    def initialize(x, y)  
        @x = x
        @y = y
    end
end

def makeSquareUpTo(num)
    map = {}
    start = Point.new(0, 0)
    map[start, 1]
    cur = 1
    x = 0
    y = 0
    while num < cur
        point = Point.new(x,y)
        map