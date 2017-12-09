require_relative 'lib/file_reader.rb'

class Program
    attr_accessor :name, :weight, :children, :parent, :children_weight
    def initialize(name, weight, children_string)
        @name = name
        @weight = weight
        @children_string = children_string
        @children = []
        @parent = nil
        @children_weight = []
    end

    def process_children(programs_map)
        if @children_string
            children = @children_string.strip.split(",")
            children.each do |child|
                child = child.strip
                child_program = programs_map[child]
                child_program.add_parent(self)
                self.add_child(child_program)            
            end
        end
    end

    def add_child(child)
        @children << child
    end

    def add_parent(parent)
        @parent = parent
    end

    def has_parent
        if @parent == nil
            return false
        end
        return true
    end

    def print_program
        output = "#{name} (#{weight})"
        if children.size > 0
            output += " ->"
            children.each_with_index do |child, idx|                
                if idx > 0
                    output += ","
                end
                output += " #{child.name}"
            end            
        end
        puts output
    end

    def get_total_weight
        weight = @weight + get_children_weight
        weight
    end

    def get_children_weight
        weight = @weight        
        if @children_weight.size > 0
            return @children_weight.inject(0) {|sum, x| sum + x }
        end
        children.each do |child|
            child_weight = child.get_weight
            @children_weight << child.get_weight
            weight += child_weight
        end
        weight
    end

    def is_children_weight_balanced?
        self.get_children_weight        
        if @child_weight.size > 0
            w = @children_weight[0]
            @children_weight.each do |weight|
                if w != weight
                    return false
                end
            end
        end
        true
    end
end

def get_programs
    programs = []
    programs_map = {}
    data = read_file('../data/day7.txt')
    data.each do |program|
        children = program.split("->")[1]
        parent = program.split("->")[0]
        weight = parent.split("(")[1].split(")")[0].to_i
        name = parent.split("(")[0].strip
        program = Program.new(name, weight, children)        
        programs_map[name] = program
        programs << program
    end

    programs.each do |program|
        program.process_children(programs_map)
    end

    programs
end

def get_original_parent_program(programs)
    programs.each do |program|
        if !program.has_parent            
            return program
        end
    end
end

def get_unbalanced_program(programs)
    programs.each do |program|
                   
    end
end

def find_problem_program(program)
    if program.is_children_weight_balanced?
        return nil
    end

    program.children do |child|

    end
end

programs = get_programs
get_original_parent_program(programs).print_program


