require('weblit-app')

	.bind({
		host = "::",
		port = 32761
	})

	.route({
		method = "GET",
		path = "/"
	}, function (req, res, go)
		local ip = req.socket:getpeername().ip
		ip = ip:match("::ffff:(%d+%.%d+%.%d+%.%d+)") or ip
		res.headers.Connection = "Close"
		res.headers.Server = "nilfinx/datsyourip"
		res.body = ip
	end)

	.start()