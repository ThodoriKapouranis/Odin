class Game
    def initialize 
        @game_board = Board.new
    end

    public
    def play
        puts ("Instead of 6 colors, use digits 1-6")
        puts ("colored key x, white key o")
        print ("Does human want to be code_breaker? (y/n) ")
        input = gets.chop
        # Human code_breaker
        case input
        when "y"
            @human = Human.new(true,false)
            @ai    = Ai.new(false,true)
            @game_board.add_code( @ai.generate_code )
            while @game_board.game_done==false
                @game_board.display
                @game_board.add_guess( @human.request_guess )
            end

        when "n"
            @human = Human.new(false,true)
            @ai    = Ai.new(true,false)
            @game_board.add_code( @human.request_code )
            while @game_board.game_done==false
                @game_board.display
                @game_board.add_guess( @ai.generate_guess)
            end
        end
    end

    private
    def make_guess
        
    end
    
end

class Player
    def initialize(is_breaker, is_maker)  #Expecting bool
        @code_breaker=is_breaker
        @code_maker=is_maker
    end
end

class Human < Player
    public
    def request_guess
        print "Write a guess (ex: 4243): " # No checking for proper input
        guess = gets.chop
    end

    def request_code
        print "Write a code (ex: 4243): " # No checking for proper input
        code = gets.chop
    end
end

class Ai < Player
    public
    def generate_code
        random_4_digit
    end

    def generate_guess
        random_4_digit
    end
    private
    def random_4_digit
        rand(1..6)*1000+rand(1..6)*100+rand(1..6)*10+rand(1..6)
    end
end

class Board
    attr_reader :code, :guesses, :keys, :game_done
    def initialize
        @code=Array.new(4,'?')
        @guesses= Array.new(8,Array.new(4,','))
        @keys= Array.new(8,Array.new(4,','))
        @guess_count=0
        @hide_code=false
        @game_done=false
    end

    public
    def display
        puts ""
        puts @code.join
        @guesses.each_index {|i| puts "#{@guesses[7-i].join}\t#{@keys[7-i].join}"}
        puts ""
        end_game if @guess_count==8
    end

    def add_guess(player_guess) # 1234 -> ['1','2','3','4']
        player_guess = player_guess.to_s.split("")
        @guesses[@guess_count]=player_guess
        check_guess(player_guess)
        @guess_count+=1
    end

    def add_code(player_code) # 1234-> ['1','2','3','4']
        @code=player_code.to_s.split("")
    end

    private 
    def check_guess(player_guess) # Coming in as ['1','2','3','4']
        temp_code = @code       #Same spot+color check
        temp_code2 = Array.new  #Same color check
        result = Array.new
        player_guess2= Array.new #same color check
            
        ## Colored key
        player_guess.each_index do |i|
            if player_guess[i]==temp_code[i]
                result.push("x")
            else
                player_guess2.push(player_guess[i].to_i)
                temp_code2.push(temp_code[i].to_i)
            end
        end

        ## White key
        temp_code2.each {|num| result.push("o") if player_guess2.include?(num)}
        
        if result.length<4
            result.push(',') until result.length==4
        end
        @keys[@guess_count]=result
        
        if result==["x","x","x","x"]
            display            
            end_game 
        end
    end

    def end_game
        puts "Game has ended"
        @game_done=true
    end

end

new_game = Game.new
new_game.play