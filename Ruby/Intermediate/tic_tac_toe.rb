#Tic tac toe
class Board

    def initialize
        @players = Array.new
        @tile_space = Array.new
        print "First player's name?: "
        p1_name = gets.chomp
        print "Second player's name?: "
        p2_name = gets.chomp
        @players[0] = Player.new(p1_name,"O")
        @players[1] = Player.new(p2_name,"X")
        3.times { @tile_space.push([Tile.new,Tile.new,Tile.new]) }
        @done=false
        @whose_turn=0 #alt between p1 (0) and p2 (1) with self.change_turn
    end

    public
    def play
        while @done==false
            display_board
            play_turn # =>change_tile => check_win
            change_turn
        end
        display_board
        puts "Game finished . . . Program terminating"
    end

    private
    def display_board
        print "\n"
        @tile_space.each do |row|
            print "\t\t"
            row.each do |tile|
                print tile.char
            end
            print "\n"
        end
        print "\n"
    end

    def play_turn()
        current_player = @players[@whose_turn]
        puts "It's #{current_player.name} turn!"
        print "Which tile do you choose? (ex: 0,0 or 2,2) : "
        pos = gets.chomp.split(',')
        change_tile(pos[0].to_i,pos[1].to_i,current_player.char)
    end

    def change_tile(row, col, char) #Called by play_turn
        if (row>2 || col>2 || row<0 || col<0)
            puts "Invalid tile! try again!"
            play_turn()
            return
        end
        if @tile_space[row][col].empty?
            @tile_space[row][col].char=char
            @tile_space[row][col].empty=false
            check_win(row,col,char)
        else
            puts "That tile is occupied!"
            play_turn()
        end
    end

    def check_win(row, col, char) #Called by change_tile
        cur_row = @tile_space[row]
        cur_col = [@tile_space[0][col],@tile_space[1][col],@tile_space[2][col]]
        cur_diag = [Tile.new,Tile.new,Tile.new]
        #check if on diagonal
        cur_diag = [@tile_space[0][0],@tile_space[1][1],@tile_space[2][2]] if row==col
        cur_diag = [@tile_space[2][0],@tile_space[1][1],@tile_space[0][2]] if row+col==2
        
        if (cur_row.all? {|x| x.char==char} or cur_col.all? {|x| x.char==char} or cur_diag.all? {|x| x.char==char})
            puts "WINNER: #{@players[@whose_turn].name}!"
            @done=true
        end
    end

    def change_turn()
        if @whose_turn==0 
            @whose_turn=1 
        else
            @whose_turn=0
        end
    end
end

class Player
    attr_reader :name, :char
    def initialize(name, char)
        @name=name
        @char=char
    end
end

class Tile
    attr_accessor :char, :empty
    def initialize()
        @char=","
        @empty=true
    end

    public
    def empty?
        @empty #redundant...but
    end
end

game = Board.new()
game.play()