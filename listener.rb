require "redis"
require "hiredis"
require "json"
require "open5"

redis = Redis.new(host: "127.0.0.1", port: 6379, :driver => :hiredis)
subChannel = "rubycon"
pubChannel = "rubycon-resp"

puts "Listening to any commands passed on"

# Subscribe to all messages
redis.subscribe(subChannel) do |on|
  on.subscribe do |channel, subscriptions|
    puts "Subscribed to ##{channel} (#{subscriptions} subscriptions)"
  end
  on.message do |channel, message|
    data = JSON.parse(message)

    if data["uuid"].empty? || data["body"].empty?
      puts "INVALID DATA RECEIVED"
      redis.publish(pubChannel, JSON.stringify({ uuid: false }))
    end

    puts "UUID: #{data['uuid']}"
    redis2 = Redis.new(host: "127.0.0.1", port: 6379, :driver => :hiredis)
    response = "Something went wrong, couldn't complete your request"

    # Write a ruby file to be run
    if data["type"] == "ruby"
      scriptName = "#{data["uuid"]}.rb";
      puts "WRITING SCRIPT: #{scriptName}"
      script = open("src/" + scriptName, 'w')
      script.write(data["body"])
      script.close()

      Open3.popen3("./ruby.sh", scriptName) do |stdin, stdout, stderr, wait_thr|
        response = stdout.read
      end

      redis2.publish(pubChannel, JSON.generate({
        :uuid => data["uuid"],
        :body => response,
        :type => data["type"]
      }))

      # Move the file after running
      File.rename "src/" + scriptName, "old/" + scriptName
    end

    # Publish that something went wrong
    redis2.publish(pubChannel, JSON.generate({
        :uuid => data["uuid"],
        :body => "Something went wrong",
        :type => data["type"]
      }))
  end
end
