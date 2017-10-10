# Just a couple of ways to do string interpolation in Ruby
bob = "Bob"
alice = "Alice"

puts 'My name is ' + bob + ', my wife is ' + alice
puts "My name is #{bob}, my wife is #{alice}"
puts "My name is %s, my wife is %s" % [bob, alice]
