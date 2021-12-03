def insert(nums, cur_pos, steps, num)
    next_pos = (cur_pos + steps) % num + 1
    nums.insert(next_pos, num)
    return nums, next_pos
end

def run(step, runs)
    nums = [0]
    cur_pos = 0
    for i in 1...runs        
        nums, cur_pos = insert(nums, cur_pos, step, i)
    end
    nums
end

def get_answer(nums, key)
    nums[nums.index(key) + 1]
end

def insert2(cur_pos, steps, num)
    next_pos = (cur_pos + steps) % num + 1
    return next_pos
end

def run2(step, runs)    
    cur_pos = 0
    answer = 0
    for i in 1...runs                       
        cur_pos = insert2(cur_pos, step, i)
        if cur_pos == 1
            puts i
            answer = i
        end        
    end
    answer
end

puts get_answer(run(3,2018), 2017)
puts get_answer(run(337,2018), 2017)
puts run2(337,50000000)
