require_relative 'lib/file_reader.rb'

class Values
    attr_accessor :x, :y, :z
    def initialize(x, y, z)
        @x = x.to_i
        @y = y.to_i
        @z = z.to_i
    end

    def get_values
        [@x, @y, @z]
    end

    def get_distance
        @x + @y + @z
    end

    def add(values)
        @x += values.x
        @y += values.y
        @z += values.z
    end

    def add_n_times(values, n)
        temp = []
        temp << @x + n * values.x
        temp << @y + n * values.y
        temp << @z + n * values.z
        temp
    end
end

class Particle
    attr_accessor :name
    def initialize(name, line)
        @name = name
        digits = line.scan(/-?\d+/)
        @position = Values.new(digits[0], digits[1], digits[2])
        @velocity = Values.new(digits[3], digits[4], digits[5])
        @acceleration = Values.new(digits[6], digits[7], digits[8])
    end

    def get_position
        @position.get_values
    end

    def get_distance
        @position.get_distance
    end

    def increment
        @velocity.add(@acceleration)
        @position.add(@velocity)
    end

    def get_distance_after_increment
        increment
        get_distance
    end

    def get_accel_distance
        @acceleration.get_distance
    end

    def increment_vel_n_times_and_get_vel_distance(n)
        temp = @velocity.add_n_times(@acceleration, n)
        temp.inject(0){|sum,x| sum + x }        
    end
end

class Particles
    attr_accessor :particles

    def initialize(input)
        @particles = []
        input.each_with_index do |line, idx|
            p = Particle.new(idx, line)
            @particles << p
        end
    end

    def get_smallest_vel(n)
        slowest = nil
        slowest_dist = nil
        @particles.each do |p|
            dist = p.increment_vel_n_times_and_get_vel_distance(n)
            if slowest == nil || dist < slowest_dist
                slowest_dist = dist
                slowest = p
            end
        end
        slowest
    end

    def movement_with_collisions(n)        
        particles = @particles

        n.times do |i|        
            position_map = {}
            particles.each do |p|
                cur_pos = p.get_position
                if position_map.has_key?(cur_pos)
                    position_map[cur_pos] << p
                else
                    position_map[cur_pos] = [p]
                end
            end            

            next_set = []
            position_map.each_key do |key|       
                if position_map[key].size == 1
                    next_set += position_map[key]
                end
            end

            particles = next_set
            particles.each do |p|
                p.increment
            end
        end               
        particles
    end

end

def part1
    input = read_file('../data/day20.txt')
    particles = Particles.new(input)    
    puts particles.get_smallest_vel(10000000).name
end

def part2(file)
    input = read_file(file)
    particles = Particles.new(input)        
    p = particles.movement_with_collisions(1000)
    puts particles.particles.size
    puts p.size
end

part2('../data/day20.txt')


