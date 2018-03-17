require_relative 'lib/file_reader.rb'

class Componenet
    attr_accessor :pins_a, :pins_b, :id

    def initialize(line, id)
        @id = id
        pins_a, pins_b = line.strip.split("/")
        @pins_a = pins_a.to_i
        @pins_b = pins_b.to_i
    end

    def pins
        [@pins_a, @pins_b]
    end

    def get_strength
        @pins_a + @pins_b
    end
end

class Program
    def initialize(file, part_b = false)
        @components = get_components(file)
        run
        if part_b
            p get_strongest_longest_bridge
        else
            p get_strongest_bridge    
        end
    end

    def get_components(file)
        data = read_file(file)
        components = []
        data.each_with_index do |line, idx|
            components << Componenet.new(line, idx)
        end
        components
    end

    def make_map
        @map = {}
        @components_map = {}
        @components.each do |component|
            @components_map[component.id] = component

            if @map.has_key?(component.pins_a)
                @map[component.pins_a] << component.id
            else
                @map[component.pins_a] = [component.id]
            end

            if @map.has_key?(component.pins_b)
                @map[component.pins_b] << component.id
            else
                @map[component.pins_b] = [component.id]
            end
        end
        @map
    end

    def run
        @bridges = []
        make_map
        helper(@map, 0, [], 0)
        @bridges
    end

    def helper(remaining, current_pin, current_bridge, level)
        possible_components = remaining[current_pin].clone     
        if possible_components == nil || possible_components.size == 0            
            @bridges << current_bridge
        else
            possible_components.each do |component_id|   
                new_remaining = remove_from_remaining(remaining.clone, component_id)
                new_pin = get_other_pin(component_id, current_pin)
                new_bridge = get_bridge(current_bridge, component_id)
                helper(new_remaining, new_pin, new_bridge, level + 1)
            end
        end
    end

    def remove_from_remaining(remaining, component_id)    
        component = @components_map[component_id]        
        new_remaining = Marshal.load(Marshal.dump(remaining))

        a = new_remaining[component.pins_a]
        a.delete_at(a.find_index(component.id))
        b = new_remaining[component.pins_b]
        b.delete_at(b.find_index(component.id))

        new_remaining
    end

    def get_other_pin(component_id, pin)
        component = @components_map[component_id]
        current_pins = component.pins
        current_pins.delete_at(current_pins.find_index(pin))
        current_pins[0]
    end

    def get_bridge(bridge, component_id)
        new_bridge = bridge.clone
        component = @components_map[component_id]
        new_bridge << component
    end
    
    def get_strongest_bridge
        strongest = 0
        @bridges.each do |bridge|
            strength = 0
            bridge.each do |component|
                strength += component.get_strength
            end
            strongest = [strongest, strength].max
        end
        strongest
    end

    def get_strongest_longest_bridge
        longest = 0
        strongest = 0
        @bridges.each do |bridge|
            strength = 0
            length = 0
            bridge.each do |component|
                strength += component.get_strength
                length += 1
            end
            if length == longest                
                strongest = [strongest, strength].max
            elsif length > longest
                longest = length
                strongest = strength
            end
        end
        strongest
    end
end

#part_a_test = Program.new('../data/day24_test.txt')
#part_a = Program.new('../data/day24.txt')
#part_b_test = Program.new('../data/day24_test.txt', true)
part_b = Program.new('../data/day24.txt', true)