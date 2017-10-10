puts "Numbers between 1 and 100, devisible by 2,3,4"
(1...100).each do |num|
    div = num % 2 == 0 && num % 3 == 0 && num % 4 == 0; 
    if !div
        next
    end
    puts "#{num}"
end
