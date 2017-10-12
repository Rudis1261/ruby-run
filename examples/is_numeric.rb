class String
  def is_number?
    true if Float(self) rescue false
  end
end

class String
  def numeric?
    return true if self =~ /\A\d+\Z/
    true if Float(self) rescue false
  end
end

class Fixnum
  def is_number?
    true if Float(self) rescue false
  end
end

class Fixnum
  def numeric?
    return true if self =~ /\A\d+\Z/
    true if Float(self) rescue false
  end
end

puts "This is all about testing for numbers"
puts "====================================="
numbers = ['12', 100, '1a', '500', -10, '-200', 'hello']

numbers.each do |test|
    puts "Testing to see if #{test} is a number:"
    puts "Using .is_number?: #{test.is_number?}"
    puts "Using .numeric?: #{test.numeric?}"
    puts "Using regex?: #{test =~ /^[0-9]+$/}"
    puts "-------------------------------------\n"
end