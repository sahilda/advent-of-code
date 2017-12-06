require_relative 'lib/file_reader.rb'
require 'set'

data = read_file("../data/day4.txt")

def valid_passphrase_with_no_repeat_words?(passphrase)
    passphrase = passphrase.split(" ")
    passphrase.size == passphrase.to_set.size
end

def valid_passphrase_with_no_anagrams?(passphrase)
    passphrase = passphrase.split(" ")
    passphrase.each_with_index do |word1, idx1|
        for idx2 in (idx1+1)...passphrase.size            
            if is_anagram?(word1, passphrase[idx2])
                return false
            end
        end
    end
    true
end

def is_anagram?(word1, word2)    
    if word1.size != word2.size
        return false
    end

    chars = []
    word1.each_char do |char|
        if chars[char.ord - "a".ord] == nil
            chars[char.ord - "a".ord] = 1
        else
            chars[char.ord - "a".ord] += 1
        end
    end

    word2.each_char do |char|
        if chars[char.ord - "a".ord] == nil
            return false
        else
            chars[char.ord - "a".ord] -= 1
            if chars[char.ord - "a".ord] < 0
                return false
            end
        end        
    end
    true
end

def get_count_of_valid_passphrases(data, func)
    count = 0
    data.each do |passphrase|
        if (func.call(passphrase))
            count += 1
        end
    end
    count
end

puts get_count_of_valid_passphrases(data, method(:valid_passphrase_with_no_repeat_words?))
puts get_count_of_valid_passphrases(data, method(:valid_passphrase_with_no_anagrams?))


