# July 6 2020 10:15am
# Done July 6 2020 10:27am
# Thodori Kapouranis

def substrings(sentence, dictionary)
    hash_to_return = Hash.new(0)
    to_parse = sentence.downcase.split
    to_parse.each do |word|
        dictionary.each do |sub|
            hash_to_return[sub]+=1 if word.include?(sub)
        end
    end
    hash_to_return
end

test_sentence="Howdy partner, sit down! How's it going?"
test_dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
substrings(test_sentence, test_dictionary)

