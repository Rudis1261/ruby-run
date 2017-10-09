require 'fileutils'
# REQUIRES
# require "redis"
# require "hiredis"
# require "json"
# require "open5"
# REQUIRES
class Server

  #==========================================================================

  VERSION = "1.0.0"

  def self.run!(options)
    Server.new(options).run!
  end

  #==========================================================================

  attr_reader :options, :quit

  def initialize(options)
    @options = options
    options[:logfile] = File.expand_path(logfile) if logfile?   # daemonization might change CWD so expand any relative paths in advance
    options[:pidfile] = File.expand_path(pidfile) if pidfile?   # (ditto)
  end

  def daemonize?
    options[:daemonize]
  end

  def logfile
    options[:logfile]
  end

  def working_dir
    options[:working_dir]
  end

  def working_dir?
    !working_dir.nil?
  end

  def change_working_dir
    info "Setting working directory #{working_dir}"
    Dir.chdir working_dir
  end

  def pidfile
    options[:pidfile]
  end

  def logfile?
    !logfile.nil?
  end

  def pidfile?
    !pidfile.nil?
  end

  def info(msg)
    puts "[#{Process.pid}] [#{Time.now}] #{msg}"
  end

  #--------------------------------------------------------------------------

  def run!

    check_pid
    daemonize if daemonize?
    change_working_dir if working_dir?
    write_pid
    trap_signals

    if logfile?
      redirect_output
    elsif daemonize?
      suppress_output
    end

    while !quit
      info "Starting server"
      sleep(1)  # in real life, something productive would happen here
      redis = Redis.new(host: "127.0.0.1", port: 6379, :driver => :hiredis)
      redis2 = Redis.new(host: "127.0.0.1", port: 6379, :driver => :hiredis)

      subChannel = "rubycon"
      pubChannel = "rubycon-resp"

      info "Listening to any commands passed on"
      # Subscribe to all messages
      redis.subscribe(subChannel) do |on|
        on.subscribe do |channel, subscriptions|
          info "Subscribed to ##{channel} (#{subscriptions} subscriptions)"
        end
        on.message do |channel, message|
          data = JSON.parse(message)

          if data["uuid"].to_s.empty? || data["body"].to_s.empty?
            info "INVALID DATA RECEIVED"
            redis2.publish(pubChannel, JSON.generate({
              :uuid => data["uuid"],
              :body => false,
              :type => data["type"]
            }))
          end

          info "TYPE: #{data['type']}, UUID: #{data['uuid']}"
          response = "Something went wrong, couldn't complete your request"

          # Write a ruby file to be run
          if data["type"] == "ruby"
            scriptName = "#{data["uuid"]}.rb";
            info "WRITING SCRIPT: #{scriptName}"
            script = open("src/" + scriptName, 'w')
            script.write(data["body"])
            script.close()

            Open3.popen3("./ruby.sh", scriptName) do |stdin, stdout, stderr, wait_thr|
              response = stdout.read

              error = stderr.read
              if !error.empty?
                response += error
              end
            end

            redis2.publish(pubChannel, JSON.generate({
              :uuid => data["uuid"],
              :body => response,
              :type => data["type"]
            }))

            # Remove file
            if File.exists "src/" + scriptName
              File.delete "src/" + scriptName
            end

            # Move the file after running
            #File.rename "src/" + scriptName, "old/" + scriptName
          end

          # Run the RI
          if data["type"] == "ri"
            info "Running Documentation"

            Open3.popen3("./ri.sh", "#{data['body']}") do |stdin, stdout, stderr, wait_thr|
              response = stdout.read

              error = stderr.read.to_s
              if !error.empty?
                response += error.to_s
              end
            end

            redis2.publish(pubChannel, JSON.generate({
              :uuid => data["uuid"],
              :body => response,
              :type => data["type"]
            }))
          end

          # health check, ping pong
          if data["type"] == "ping"
            redis2.publish(pubChannel, JSON.generate({
              :uuid => data["uuid"],
              :body => "pong",
              :type => data["type"]
            }))
          end

          # Publish that something went wrong
          redis2.publish(pubChannel, JSON.generate({
            :uuid => data["uuid"],
            :body => "Something went wrong",
            :type => data["type"]
          }))
        end
      end

    end
    info "Finished"
  end

  #==========================================================================
  # DAEMONIZING, PID MANAGEMENT, and OUTPUT REDIRECTION
  #==========================================================================

  def daemonize
    exit if fork
    Process.setsid
    exit if fork
  end

  def redirect_output
    FileUtils.mkdir_p(File.dirname(logfile), :mode => 0755)
    FileUtils.touch logfile
    File.chmod(0644, logfile)
    $stderr.reopen(logfile, 'a')
    $stdout.reopen($stderr)
    $stdout.sync = $stderr.sync = true
  end

  def suppress_output
    $stderr.reopen('/dev/null', 'a')
    $stdout.reopen($stderr)
  end

  def write_pid
    if pidfile?
      begin
        File.open(pidfile, ::File::CREAT | ::File::EXCL | ::File::WRONLY){|f| f.write("#{Process.pid}") }
        at_exit { File.delete(pidfile) if File.exists?(pidfile) }
      rescue Errno::EEXIST
        check_pid
        retry
      end
    end
  end

  def check_pid
    if pidfile?
      case pid_status(pidfile)
      when :running, :not_owned
        puts "A server is already running. Check #{pidfile}"
        exit(1)
      when :dead
        File.delete(pidfile)
      end
    end
  end

  def pid_status(pidfile)
    return :exited unless File.exists?(pidfile)
    pid = ::File.read(pidfile).to_i
    return :dead if pid == 0
    Process.kill(0, pid)
    :running
  rescue Errno::ESRCH
    :dead
  rescue Errno::EPERM
    :not_owned
  end

  #==========================================================================
  # SIGNAL HANDLING
  #==========================================================================

  def trap_signals
    trap(:QUIT) do   # graceful shutdown
      @quit = true
    end
  end

  #==========================================================================

end