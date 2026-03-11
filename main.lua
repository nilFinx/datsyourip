local uv = require "luv"

local cfg = require "cfg"
assert(type(cfg) == "table", "cfg.lua does not return table (is it an empty file?)")

local port = cfg.port or 32761
local hostmatch = cfg.hostmatch or false

local h =	"Connection: Close\r\n"..
			"Server: nilfinx/datsyourip\r\n"


local mna = "HTTP/1.1 405 Method Not Allowed\r\n"..
				h..
				"\r\n"

local mdr = "HTTP/1.1 421 Misdirected Request\r\n"..
				h..
				"\r\n"

local dos = cfg.domains

local assert, select = assert, select

local server = uv.new_tcp()
assert(server:bind("::", port))
assert(server:listen(128, function (err)
	local suc, e = pcall(function()
		assert(not err, err)
		local c = uv.new_tcp()
		server:accept(c)
		local buf = ""
		local state = 1
		local method, path, host
		local function cb(err, chunk)
			assert(not err, err)
			if chunk then
				if state == 1 then
					method, path = (buf..chunk):match("^(%u+) (%S+) HTTP/%d%.?%d?\r?\n")
					if not (method and path) then
						buf = buf..chunk return
					end
					if method ~= "GET" then
						c:write(mna)
						c:shutdown() c:close() return
					end
					buf = (buf..chunk):sub(select(2, (buf..chunk):find("HTTP/%d%.?%d?\r?\n"))+1)
					state = (hostmatch and 2 or 3) cb(nil, "")
				elseif state == 2 then
					for match in (buf..chunk):gmatch("([^\r\n]+)\r?\n") do
						if match:sub(1, 6) == "Host: " then
							host = match:sub(7)
							if host and host ~= "" then
								state = 3 cb(nil, "") return
							end
						end
					end
					if (buf..chunk) == "\r\n" or (buf..chunk) == "\n" or (buf..chunk):find("\r?\n\r?\n$") then
						if hostmatch then
							c:write(mdr)
							c:shutdown() c:close() return
						else
							state = 3 cb(nil, "") return
						end
					end
					buf = (buf..chunk):match(".+\r?\n(.-)") or (buf..chunk)
				elseif state == 3 then
					local s = false
					if hostmatch then
						for _, h in pairs(dos) do
							if h == host then
								s = true
							end
						end
					end
					if hostmatch and not s then
						print("Misdirected: "..host)
						c:write(mdr)
						c:shutdown() c:close() return
					end
					buf = buf .. chunk
					if buf:find("\r?\n\r?\n") then
						local ip = c:getpeername().ip
						ip = ip:match("::ffff:(%d+%.%d+%.%d+%.%d+)") or ip
						c:write(
							"HTTP/1.1 200 OK\r\n"..
							h..
							"Content-Length: "..tostring(ip:len()).."\r\n"..
							"\r\n"..ip)
						c:shutdown() c:close() return
					end
				end
			else
				c:shutdown() c:close()
			end
		end
		c:read_start(cb)
	end)
	if not suc then
		print("error: "..(e or "no error, but failed regardless"))
	end
end))

print(("Should be listening now... (port %i)"):format(port))
uv.run()