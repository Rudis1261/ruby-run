mapping = {
    1 => "A",
    2 => "B",
    3 => "C",
    4 => "D",
    5 => "E",
    6 => "F",
    7 => "G",
    8 => "H"
}

header = []
(1..8).reverse_each do |row|
    blocks = []
    (1..8).each do |column|
        if (row == 8)
            header << mapping[column]
        end
        blocks << ((row + column) % 2 == 0 ? "B": "W")
    end

    puts "#{row} | #{blocks.join('.')}"
    if (row == 1)
        puts "   ----------------"
        puts "    #{header.join('.')}"
    end
end