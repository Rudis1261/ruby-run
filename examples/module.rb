module Logging 
    def self.info(info)
        now = Time.now.strftime("%d/%m/%Y %H:%M")
        puts "#{now}: #{info}"
    end 
end

Logging.info("Helloo");
