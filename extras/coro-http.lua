local ch = require "coro-http"

ch.createServer("::", 32761, function(req, _, socket)
	local ip = socket:getpeername().ip
	ip = ip:match("::ffff:(%d+%.%d+%.%d+%.%d+)") or ip
	return {
		code = 200,
		{"Connection", "Close"},
		{"Server", "nilfinx/datsyourip"},
		{"Content-Length", tostring(ip:len())}
	}, ip
end)