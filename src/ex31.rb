puts "You enter a dark room with two doors. Do you go through door #1 or door #2, or door #3?"
puts "> "
door = $stdin.gets.chomp

if door == "1"
    puts "There's a giant bear eating a cheese cake. What do you do?"
    puts "1. Take the cake."
    puts "2. Scream at the bear"
    print "> "
    bear = $stdin.gets.chomp

    if bear == "1"
        puts "The bear eats your face off. Good job!"
    elsif bear == "2"
        puts "The bear eats your legs off. Good job!"
    else
        puts "Well, doing %s is probably better. Bear runs away." % bear
    end

elsif door == "2"
    puts "You stare into the endless abyss at Cthulhu's retina."
    puts "1. Blueberries."
    puts "2. Yellow jacket clothespins."
    puts "3. Understanding revolvers yelling melodies."
    print "> "
    insanity = $stdin.gets.chomp

    if insanity == "1" || insanity == "2"
        puts "Your body survives powered by a mind of jello. Good job!"
    else
        puts "The insanity rots your eyes into a pool of muck. Good job!"
    end

elsif door == "3"
    puts "You arrive at an abandoned western tavern what do you do?"
    puts "1. You enter, grab a bottle and pour yourself a drink"
    puts "2. You look through the window, checking if anyone is in"
    puts "3. You look around for something else"

    print "> "
    resolve = $stdin.gets.chomp

    if resolve == 1 || resolve == 2
        puts "You find the tavern not as abandoned as you though, sadly for you. You did this by getting yourself killed with a shotgun"
    else
        puts "You find a oasis, with mermaids calling out your name. What do you do?"
        puts "1. You let them seduce you, and pull you in with their song"
        puts "2. You look the other way, and run"
        puts "3. You take a drink of water to sate your unending thirst"

        print "> "
        resolve = $stdin.gets.chomp
        puts "The mermaids grab you, pulling you in and drowning you, no longer to be part of this life"
    end
else
    puts "You stumble around and fall on a knife and die. Good job!"
end