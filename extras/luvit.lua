---@type luvit.http
local http = require "http"

http.createServer(function(req, res)
	local ip = req.socket._handle:getpeername().ip
	ip = ip:match("::ffff:(%d+%.%d+%.%d+%.%d+)") or ip
	res:setHeader("Connection", "Close")
	res:setHeader("Server", "nilfinx/datsyourip")
	res:setHeader("Content-Length", tostring(ip:len()))
	res:finish(ip)
end):listen(32761)

print "start"