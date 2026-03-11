#!/bin/sh
t() {
	sleep 0.5
	ab -dSSq -m GET -n 10000 http://127.1:32761/
	killall luvit
	echo
}

echo THIS SCRIPT WILL KILL ALL INSTANCES OF LUVIT

sleep 1

luvit uv.lua &
t
echo above: uv

luvit luvit.lua &
t
echo above: luvit

luvit coro-http.lua &
t
echo above: coro-http

luvit weblit.lua &
t
echo above: weblit
