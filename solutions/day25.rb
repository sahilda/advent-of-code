class Run
    attr_accessor :tape

    def initialize
        @state = :a
        @tape = [0]
        @cursor = 0
    end

    def do_move
        if @tape[@cursor] == 0
            @tape[@cursor] = 1
            case @state
            when :a
                go_right
                @state = :b            
            when :b
                go_left
                @state = :a
            when :c
            when :d
            when :e
            when :f
            end
        else
            case @state
            when :a
                @tape[@cursor] = 0
                go_left
                @state = :b
            when :b
                @tape[@cursor] = 1
                go_right
                @state = :a
            when :c
            when :d
            when :e
            when :f
            end
        end
    end

    def go_right
        @tape << 0 if @cursor == @tape.size - 1            
        @cursor += 1
    end

    def go_left
        if @cursor == 0
            @tape.unshift(0)
        else
            @cursor -= 1
        end
    end

    def move(moves)
        moves.times do |i|
            do_move
        end
    end

    def get_checksum
        @tape.inject(0){|sum,x| sum + x }
    end
end

p1 = Run.new
p1.move(6)
p p1.tape
p p1.get_checksum