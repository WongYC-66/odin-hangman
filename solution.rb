require 'yaml'
require_relative('Game')

puts "Welcome to Hangman game, where user needs to guess correct words in 8 rounds"
puts "Enter"
puts "-- Y --  for new game"
puts "-- N --  for saved game"

user_input = gets.chomp.upcase
until user_input == 'Y' || user_input == 'N'
  puts "Invalid"
  user_input = gets.chomp.upcase
end

if user_input == 'Y'
  new_game = Game.new
  new_game.play
else
  if File.exist?("./saved/save.yaml")
    yaml_string = File.read("./saved/save.yaml")
    saved_game = Game.deserialize(yaml_string)
    saved_game.play
  else
    puts "No saved game, create new game instead."
    new_game = Game.new
    new_game.play
  end

end