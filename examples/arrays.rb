# Just a function to string the array togheter
def join_numbers(numbers)
    output = ""
    numbers.each { |num| output += " #{num}" }
    return output;
end

numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
numbers_2 = (1...9) # Defining with a range for numbers
numbers_3 = [1, 2, 4]

# Removing elements 
numbers_3.pop # Pop the last item off
numbers_3.push(6) # Push method 1
numbers_3 << 8 # Push method 2

puts "Numbers 1: " + join_numbers(numbers)
puts "Numbers 2: " + join_numbers(numbers_2)
puts "Numbers 3: " + join_numbers(numbers_3)
