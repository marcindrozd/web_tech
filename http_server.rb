require 'socket'

server = TCPServer.open('localhost', 2000)
puts "HTTP Server ready to accept requests!"

loop do
  connection = server.accept
  puts "Opening a connection for request:"
  message_line = connection.gets
  path = message_line.split[1]
  requested_file = "documents#{path}"

  while message_line = connection.gets
    puts message_line
    break if message_line.chomp == ""
  end

  extension = requested_file.split(".")[-1]
  content_type = case extension
    when 'html' then 'text/html'
    when 'css' then 'text/css'
    when 'jpg' then 'image/jpeg'
  end

  puts "Sending response.."

  if File.exist?(requested_file)
    connection.puts "HTTP/1.1 200 OK"
    connection.puts "Date: #{Time.now.ctime}"
    connection.puts "Content-Type: #{content_type}"
    connection.puts "Server: My Http Server"
    connection.puts

    File.open(requested_file, "r") do |file|
      file.each do |line|
        connection.puts line
      end
    end
  else
    connection.puts "HTTP/1.1 404 Not Found"
    connection.puts "Date: #{Time.now.ctime}"
    connection.puts "Content-Type: #{content_type}"
    connection.puts "Server: My Http Server"
    connection.puts
    connection.puts "<html><body><h1>This file does not exist!</h1></body></html>"
  end

  connection.close
  puts "Response sent and connection closed."
end
