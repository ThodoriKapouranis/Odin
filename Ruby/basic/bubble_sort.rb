#July 06 2020 11:13am
#Thodori Kapouranis

#Each iteration sort_done = nil. If values switched, sort_done=false
#If go through whole array with no needing to switch, i.e sort_done==nil
#Then it means it is completely sorted.
def bubble_sort(array)
    sort_done=false;
    until sort_done==true do
        sort_done=nil
        (array.length-1).times do |i|
            if (array[i]>array[i+1])
                array[i], array[i+1] = array[i+1], array[i]
                sort_done=false
            end
            sort_done=true if (i==array.length-2 && sort_done==nil)
        end
    end
    p array
end


test_array=[4,3,78,2,0,2,35,0,234,7,4,2,234,76,21,87,45,23,165,64]
bubble_sort(test_array)