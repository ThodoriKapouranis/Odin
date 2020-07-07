#July 6 2020 10:48am
#Thodori Kapouranis
def stock_picker(prices)
    best_range=[0,0]
    max_profit=0;
    (prices.length-1).times do |i| #no last day buy
        j=i+1
        until j==(prices.length)
            if (prices[j]-prices[i] > max_profit)
                best_range=[i,j]
                max_profit = prices[j]-prices[i]
            end
            j+=1
        end
    end
    best_range
end

test_prices=[17,3,6,9,15,8,6,1,10,8]
stock_picker(test_prices)