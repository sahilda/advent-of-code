require_relative 'lib/file_reader.rb'

class Layer
    def initialize(depth, range)
        @depth = depth
        @range = range
        @current = 0
        @forward = true
    end

    def get_current
        @current
    end

    def at_zero?
        return @current == 0
    end

    def get_severity
        @depth * @range
    end

    def move
        if @forward
            @current += 1
            if @current == @range - 1
                @forward = false
            end
        else
            @current -= 1
            if @current == 0
                @forward = true
            end
        end
    end

    def reset
        @current = 0
        @forward = true
    end
end

class Game
    def initialize(data)
        @current_position = -1
        @max_depth = 0  
        @severity = 0
        @caught = false  
        @layers = []
        @layers_map = {}        
        data.each do |line|
            depth, range = parse_line(line)
            if depth > @max_depth 
                @max_depth = depth
            end
            layer = Layer.new(depth, range)
            @layers << layer
            @layers_map[depth] = layer
        end
    end

    def parse_line(line)
        line = line.split(":")
        depth = line[0].strip.to_i
        range = line[1].strip.to_i
        return depth, range
    end

    def run_round
        @current_position += 1
        if @layers_map[@current_position] != nil
            layer = @layers_map[@current_position]
            if layer.at_zero?
                @caught = true  
                @severity += layer.get_severity
            end            
        end
        move_all_layers        
    end

    def move_all_layers
        @layers.each do |layer|
            layer.move
        end
    end

    def end_game?
        if @current_position > @max_depth
            return true
        end
        false
    end

    def run_game_caught
        while !end_game?
            run_round
            if @caught == true
                return true
            end
        end
        false
    end

    def run_game
        while !end_game?
            run_round
        end
        @severity
    end

    def reset
        @current_position = -1        
        @severity = 0
        @caught = false
        @layers.each do |layer|
            layer.reset
        end
    end        

    def find_optimal_delay
        current_delay = 0
        bad_states = []        
        while true
            reset
            current_delay.times do |n|
                move_all_layers
            end
            if !run_game_caught
                break
            end            
            current_delay += 1
            puts current_delay
        end
        current_delay        
    end
end

data = read_file("../data/day13.txt")
game = Game.new(data)
puts game.run_game
puts game.find_optimal_delay