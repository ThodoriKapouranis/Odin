#Thodori Kapouranis
#Jul 5 2020
#I did a left shift without realizing, technically requires a right shift but meh

def caesar_cipher(sentence, shift)
    #Setting up hashtable for letter shift
    alphabet=[*("a".."z")]
    hash = Hash.new
    hash[" "]=" "
    alphabet.each_with_index do |c,i|
        redirect_i = 26+i-shift if i<shift
        redirect_i = i-shift    if i>=shift
        hash[c]=alphabet[redirect_i]
        hash[c.upcase]=alphabet[redirect_i].upcase
    end
     puts sentence.split("").map {|c| hash[c]}.join
end

caesar_cipher("Heres a decently long sentence for you to cipher",3)