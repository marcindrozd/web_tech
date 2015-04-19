require 'socket'

server = TCPServer.open('localhost', 2000)
puts "HTTP Server ready to accept requests!"

loop do
  connection = server.accept
  puts "Opening a connection for request:"

  while message_line = connection.gets
    request_line = message_line.split if message_line =~ /GET/
    puts message_line
    break if message_line.chomp == ""
  end

  puts "Sending response.."
  connection.puts "HTTP/1.1 200 OK"
  connection.puts "Date: #{Time.now.ctime}"
  connection.puts "Content-Type: text/html"
  connection.puts "Server: My Http Server"
  connection.puts

  requested_document = request_line[1]

  File.open("documents#{requested_document}", "r") do |f|
    f.each_line do |line|
      connection.puts line
    end
  end

  connection.close
  puts "Response sent and connection closed."
end
