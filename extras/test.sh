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
echo above: uv ; echo

luvit luvit.lua &
t
echo above: luvit ; echo

luvit coro-http.lua &
t
echo above: coro-http ; echo

luvit weblit.lua &
t
echo above: weblit ; echo
