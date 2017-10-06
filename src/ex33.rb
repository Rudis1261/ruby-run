#i = 0
#numbers = []

# while i < 6
#     puts "At the top i is #{i}"
#     numbers << i

#     i += 1
#     puts "Numbers now: ", numbers
#     puts "At the bottom i is #{i}"
# end

def loopNumbers(amount=6, increment=1)
    numbers = []
    (0...amount).step(increment) { |num| numbers << num }
    return numbers
end

puts "The numbers: "

# remember you can write this 2 other ways?
loopNumbers(99, 3).each { |num| puts num }