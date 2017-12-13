=begin
--- Day 7: Recursive Circus ---

Wandering further through the circuits of the computer, you come upon a tower of programs that have gotten themselves into a bit of trouble. A recursive algorithm has gotten out of hand, and now they're balanced precariously in a large tower.

One program at the bottom supports the entire tower. It's holding a large disc, and on the disc are balanced several more sub-towers. At the bottom of these sub-towers, standing on the bottom disc, are other programs, each holding their own disc, and so on. At the very tops of these sub-sub-sub-...-towers, many programs stand simply keeping the disc below them balanced but with no disc of their own.

You offer to help, but first you need to understand the structure of these towers. You ask each program to yell out their name, their weight, and (if they're holding a disc) the names of the programs immediately above them balancing on that disc. You write this information down (your puzzle input). Unfortunately, in their panic, they don't do this in an orderly fashion; by the time you're done, you're not sure which program gave which information.

For example, if your list is the following:

pbga (66)
xhth (57)
ebii (61)
havc (66)
ktlj (57)
fwft (72) -> ktlj, cntj, xhth
qoyq (66)
padx (45) -> pbga, havc, qoyq
tknk (41) -> ugml, padx, fwft
jptl (61)
ugml (68) -> gyxo, ebii, jptl
gyxo (61)
cntj (57)
...then you would be able to recreate the structure of the towers that looks like this:

                gyxo
              /     
         ugml - ebii
       /      \     
      |         jptl
      |        
      |         pbga
     /        /
tknk --- padx - havc
     \        \
      |         qoyq
      |             
      |         ktlj
       \      /     
         fwft - cntj
              \     
                xhth
In this example, tknk is at the bottom of the tower (the bottom program), and is holding up ugml, padx, and fwft. Those programs are, in turn, holding up other programs; in this example, none of those programs are holding up any other programs, and are all the tops of their own towers. (The actual tower balancing in front of you is much larger.)

Before you're ready to help them, you need to make sure your information is correct. What is the name of the bottom program?

Your puzzle answer was azqje.

--- Part Two ---

The programs explain the situation: they can't get down. Rather, they could get down, if they weren't expending all of their energy trying to keep the tower balanced. Apparently, one program has the wrong weight, and until it's fixed, they're stuck here.

For any program holding a disc, each program standing on that disc forms a sub-tower. Each of those sub-towers are supposed to be the same weight, or the disc itself isn't balanced. The weight of a tower is the sum of the weights of the programs in that tower.

In the example above, this means that for ugml's disc to be balanced, gyxo, ebii, and jptl must all have the same weight, and they do: 61.

However, for tknk to be balanced, each of the programs standing on its disc and all programs above it must each match. This means that the following sums must all be the same:

ugml + (gyxo + ebii + jptl) = 68 + (61 + 61 + 61) = 251
padx + (pbga + havc + qoyq) = 45 + (66 + 66 + 66) = 243
fwft + (ktlj + cntj + xhth) = 72 + (57 + 57 + 57) = 243
As you can see, tknk's disc is unbalanced: ugml's stack is heavier than the other two. Even though the nodes above ugml are balanced, ugml itself is too heavy: it needs to be 8 units lighter for its stack to weigh 243 and keep the towers balanced. If this change were made, its weight would be 60.

Given that exactly one program is the wrong weight, what would its weight need to be to balance the entire tower?

Your puzzle answer was 646.
=end

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
        weight = @weight + self.get_children_weight
        weight
    end

    def get_children_weight
        weight = 0        
        if @children_weight.size > 0
            return @children_weight.inject(0) {|sum, x| sum + x }
        end
        children.each do |child|
            child_weight = child.get_total_weight
            @children_weight << child_weight
            weight += child_weight
        end
        weight
    end

    def is_children_weight_balanced?
        self.get_children_weight        
        if @children_weight.size > 0
            w = @children_weight[0]
            @children_weight.each do |weight|
                if w != weight
                    return false
                end
            end
        end
        true
    end

    def get_odd_child
        if is_children_weight_balanced?
            return nil
        end    
        @children_weight.each_with_index do |weight, idx|
            if idx == @children_weight.size - 1
                return @children[idx]
            else
                if idx == 0 && @children_weight[idx] != @children_weight[idx+1]
                    if @children_weight[idx] == @children_weight[idx+2]
                        return @children[idx+1]
                    else
                        return @children[idx]
                    end
                elsif idx != 0 && @children_weight[idx] != @children_weight[idx-1]
                    return @children[idx]
                end
            end
        end
        nil
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
    problem_program = nil
    current = get_original_parent_program(programs)
    while true
        if current.is_children_weight_balanced?
            problem_program = current
            break
        end        
        current = current.get_odd_child
    end
    parent = current.parent
    target_weight = 0
    parent.children.each do |child|
        if child != current
            target_weight = child.get_total_weight
            break
        end
    end
    puts target_weight - (current.get_total_weight - current.weight)
    current
end

programs = get_programs
get_original_parent_program(programs).print_program
get_unbalanced_program(programs).print_program
