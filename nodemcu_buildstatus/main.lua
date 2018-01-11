-- globals section
ssid       = "" --TODO: Fill in wireless SSID
pass       = "" --TODO: Fill in wireless password
num_leds   = 12
buffer     = ws2812.newBuffer(num_leds, 3)
url        = "http://www.kfk4ever.com/~griffon26/buildlightstatus.txt"
poll_delay = 15


-- all/string.lua (all.string)
-- A Lua Library (ALL) - string utility functions.
-- This is compatible with Lua 5.1.
-- Licensed under the same terms as Lua itself.--DavidManura
-- remove trailing and leading whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(programming)
function trim(s)
    -- from PiL2 20.4
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- setup the network connection
function init_network()
    set_ledstrip_color(0,0,255)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(ssid,pass)

    tmr.alarm(0, 1000, 1,
        function()
            if wifi.sta.getip() == nil then
                print("Connecting to AP...\n")
            else
                ip, nm, gw=wifi.sta.getip()
                print("IP Info: \nIP Address: ",ip)
                tmr.stop(0)
                set_ledstrip_color(255,255,0)
            end
        end)
end

-- setup the ws2812 driver
function init_ws2812()
    ws2812.init()
end

-- set color function, expects r,g,b value as arguments
function set_ledstrip_color(r, g, b)
    buffer:fill(g, r, b)
    ws2812.write(buffer)
end

function get_build_status()
    body,c,l,h = http.request(url, "GET", "","",
        function(code, body)
            body = trim(body)
            print("Status: ", body)

            if body == 'G' then
                set_ledstrip_color(0,255,0)
            elseif body == 'R' then
                set_ledstrip_color(255,0,0)
            else
                set_ledstrip_color(255,255,255)
            end
        end)
end

function poll_build_status()
    tmr.alarm(0, poll_delay*1000, 1, get_build_status)
end


-- execute section
init_ws2812()
init_network()
poll_build_status()
