require_relative 'lib/file_reader.rb'

class Directions
    def initialize
        @dirs = [:north, :east, :south, :west]
        @cur_dir = 0
    end

    def change_direction(pos)
        if pos == "#"
            @cur_dir = (@cur_dir + 1) % 4
        else
            @cur_dir = (@cur_dir - 1) % 4
        end
    end

    def move
        case @dirs[@cur_dir]
        when :north
            [0, 1]
        when :east
            [1, 0]
        when :south
            [0, -1]
        when :west
            [-1, 0]
        end
    end
end

class Game
    def initialize(file)
        @dir = Directions.new
        @infections = 0
        get_map(file)        
    end

    def get_map(file)
        input = read_file(file)
        @cur_pos = get_start(input)
        @map = {}
        input.each_with_index do |line, y|
            line.strip.split("").each_with_index do |char, x|
                @map[[x, -y]] = char
            end
        end        
    end

    def get_start(input)
        y = (input.size - 1) / 2
        x = (input[0].size - 1) / 2
        [x, -y]
    end

    def do_turn
        @map[@cur_pos] = @map[@cur_pos] || "."
        pos = @map[@cur_pos]
        @dir.change_direction(pos)
        if @map[@cur_pos] == "."
            @infections += 1
            @map[@cur_pos] = "#"
        else
            @map[@cur_pos] = "."
        end
        move_pos         
    end

    def move_pos
        move = @dir.move
        new_pos = @cur_pos.zip(move).map { |a1, a2| a1 + a2 }
        @cur_pos = new_pos
    end

    def do_game(moves)
        moves.times do
            do_turn
        end
        @infections
    end
end

class DirectionsPart2 < Directions
    def change_direction(pos)
        case pos
        when '.'
            @cur_dir = (@cur_dir - 1) % 4
        when 'W'
            # do nothing
        when '#'
            @cur_dir = (@cur_dir + 1) % 4
        when 'F'
            @cur_dir = (@cur_dir + 2) % 4
        end
    end
end

class GamePart2 < Game
    def initialize(file)
        @dir = DirectionsPart2.new
        @infections = 0
        get_map(file)        
    end

    def do_turn
        @map[@cur_pos] = @map[@cur_pos] || "."
        pos = @map[@cur_pos]
        @dir.change_direction(pos)
        case @map[@cur_pos]
        when "."
            @map[@cur_pos] = "W"
        when "W"
            @infections += 1
            @map[@cur_pos] = "#"
        when "#"
            @map[@cur_pos] = "F"
        when "F"
            @map[@cur_pos] = "."
        end        
        move_pos         
    end
end

test_game = Game.new('../data/day22_test.txt')
#puts test_game.do_game(10000)

part1 = Game.new('../data/day22.txt')
#puts part1.do_game(10000)

part2_test = GamePart2.new('../data/day22_test.txt')
#puts part2_test.do_game(100)

part2 = GamePart2.new('../data/day22.txt')
puts part2.do_game(10000000)
