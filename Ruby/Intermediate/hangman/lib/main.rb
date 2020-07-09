require "json"

class Game
  def initialize(dict="dictionary.txt", target=nil, state=nil)
    if (target==nil and state==nil)
      dictionary  =   File.readlines(dict)
      @target =   pick_word(dictionary,5,12)            
      @state  =   Array.new(@target.length,"_").join  
    else
      p "I should be loading"
      @target=target
      @state=state  
    end
  end

  public 
  def play
    until game_end?(@state)
    display(@state)
    check_guess( prompt_guess(), @target, @state )
    end
  end

  def save
    p "Saving"
    File.open("Saved-game.txt", "w") do |f|
      f.write JSON.dump({
        :target => @target,
        :state => @state
      })
      end
  end

  def self.load()
    load_string = File.open("Saved-game.txt", "r").read
    load_JSON   = JSON.load(load_string)
    self.new("dictionary.txt", load_JSON['target'], load_JSON['state'])
  end
  
  private
  def pick_word(dict, upper, lower)
    dict.each {|word| word.delete_suffix!("\r\n")} #Change to correct formatting if not already
    filtered_dict = dict.select {|x| x.length>=lower && x.length<=lower }
    filtered_dict.sample.downcase
  end

  def prompt_guess
    guess=""
    until (guess=="save" || guess.length==1)
    print "\nGuess a letter or \"save\": "
    guess = gets.chop 
    end
    guess
  end

  def check_guess(guessed,target,state)
    if guessed=="save"
      save() 
    else
      target.split("").each_with_index {|c,i| state[i]=c if c==guessed}
    end
  end

  def game_end?(word_state) # Returns bool
    if not word_state.include?("_")
    print "\nCorrectly guessed"
    display(word_state)
    true
    end
  end

  def display(word_state) #Expecting formatting "h_ll_"
    puts "\n\n #{word_state} \n\n"
  end

end

print:"Input command: \"load\" or \"new\" "
ans= gets.chop

case ans
when "load"
  Game.load.play
when "new"
  Game.new("dictionary.txt").play 
end