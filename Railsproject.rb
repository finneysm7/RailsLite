require 'WEBrick'
server = WEBrick::HTTPServer.new(:Port => 3000)

server.mount_proc("/") do |request, response|
  response.body = "#{request.path}"
end

trap('INT') do
  server.shutdown
end

server.start