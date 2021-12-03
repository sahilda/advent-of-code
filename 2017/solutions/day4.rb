=begin
--- Day 4: High-Entropy Passphrases ---

A new system policy has been put in place that requires all accounts to use a passphrase instead of simply a password. A passphrase consists of a series of words (lowercase letters) separated by spaces.

To ensure security, a valid passphrase must contain no duplicate words.

For example:

aa bb cc dd ee is valid.
aa bb cc dd aa is not valid - the word aa appears more than once.
aa bb cc dd aaa is valid - aa and aaa count as different words.
The system's full passphrase list is available as your puzzle input. How many passphrases are valid?

Your puzzle answer was 455.

--- Part Two ---

For added security, yet another system policy has been put in place. Now, a valid passphrase must contain no two words that are anagrams of each other - that is, a passphrase is invalid if any word's letters can be rearranged to form any other word in the passphrase.

For example:

abcde fghij is a valid passphrase.
abcde xyz ecdab is not valid - the letters from the third word can be rearranged to form the first word.
a ab abc abd abf abj is a valid passphrase, because all letters need to be used when forming another word.
iiii oiii ooii oooi oooo is valid.
oiii ioii iioi iiio is not valid - any of these words can be rearranged to form any other word.
Under this new system policy, how many passphrases are valid?

Your puzzle answer was 186.
=end

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


