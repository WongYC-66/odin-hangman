require 'yaml'

class Game

  def initialize(remain_guess = 8, secret_code = "", curr_code = "")
    @remain_guess = remain_guess
    @secret_code = secret_code
    @curr_code = curr_code
    
    # if new game
    @secret_code = generate_secrect_code() if secret_code == ""
    @curr_code = Array.new(@secret_code.length, "_").join('') if curr_code == ""
  end

  def generate_secrect_code
    words = File.readlines("english-10000-words.txt")
      .filter_map do |w|
        if w.chomp.length.between?(5, 12)
          w.chomp
        else
          false
        end
      end
    words.sample
  end

  def play
    puts "#################################"
    while(@remain_guess > 0)

      print_game_status()
      user_input = get_user_input()
      if user_input == 'save'
        serialize()
        next
      else
        update_game(user_input)
      end

      if @curr_code == @secret_code
        print_game_status()
        print_win_res()
        return
      end
    end

    # out of guesses
    print_game_status()
    print_lose_res()
  end

  def update_game(user_input)
    if @secret_code.include?(user_input)
      # correct guess
      @curr_code = @curr_code.split('')
      .each_with_index.map do |char, index|
        if char != '_'  || user_input != @secret_code[index]
          char
        else
          @secret_code[index]
        end
      end
      .join('')
    else
      # incorrect guess
      @remain_guess -= 1
    end
  end

  def get_user_input
    puts "Please enter your guess. a~z. OR enter \"save\" to save your progress."
    input = gets.chomp.downcase
    until input.length == 1 && (input >= 'a' && input <= 'z')
      return input if input == 'save'
      puts "Please enter your guess. a~z"
      input = gets.chomp.downcase
    end
    return input
  end

  def serialize
    yaml_string = YAML.dump({
      :remain_guess => @remain_guess,
      :secret_code => @secret_code,
      :curr_code => @curr_code
    })
    File.write('./saved/save.yaml', yaml_string)
    puts "######### Game saved #########"
  end

  def self.deserialize(yaml_string)
    data = YAML.load(yaml_string)
    self.new(data[:remain_guess], data[:secret_code], data[:curr_code])
  end
  
  def print_game_status
    expanded_string = @curr_code.split('').join(' ')
    puts "#{expanded_string}      remain:  #{@remain_guess}"
  end

  def print_win_res
    puts "You won!"
    puts "secret code was \"#{@secret_code}\""
  end

  def print_lose_res
    puts "Ooops, out of guesses, You Lost!"
    puts "secret code was #{@secret_code}"
  end

end