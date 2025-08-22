local serialization = require("serialization")
local component = require("component")
local event = require("event")

local cm = component.tunnel
local fr = {}

cm.setWakeMessage("mnmn")

-- test values for the love of celestia change this to the actual proxies when you push to prod
local avgtemp = 0
local avgdepl = 0
local avgpowe = 0



function initprog()
    -- networking :(
    print("pinging the server")
    cm.send("png")
    local _, _, _, _, _, message = event.pull("modem_message")
    -- if client started before server, this puts everything back on track
    if message == "mnmn" then
        cm.send("png")
        event.pull("modem_message")
    end
    print("server acknowledged!")

    for k, v in component.list("fuel_rod") do
        table.insert(fr, component.proxy(k))
        print("found fuel rod", component.proxy(k).getCoordinates())
    end

    -- youll never see this but like, ily corpy <3
    for love, you in component.list("gauge") do
        corpy = component.proxy(love)
    end
    -- platonic? romantic? twin fantasy? who knows
end

function mainloop()

    -- add the individual values together so we can avg them l8r
    for key, val in pairs(fr) do
        avgtemp = avgtemp + val.getHeat()
        avgdepl = avgdepl + val.getDepletion() * 100
            
        print("b4", avgtemp, avgdepl)
    end

    _, avgpowe = corpy.getTransfer()

    avgtemp = avgtemp / 4
    avgdepl = 100 - (avgdepl / 4)


    avgtemp = math.floor(avgtemp * 100) / 100
    avgdepl = math.floor(avgdepl * 100) / 100

    print(avgtemp, avgdepl, avgpowe)


    -- pack the values into a table so you can send them to the svr
    local tran = {
    [1]=avgtemp,
    [2]=avgdepl,
    [3]=avgpowe
    }

    serout = serialization.serialize(tran, false)

    -- void the vals because I cant think of any other way :3
    avgtemp = 0
    avgdepl = 0
    avgpowe = 0
end
function start()

initprog()

    while true do
        -- wait for ping
        event.pull("modem_message")

        mainloop()

        cm.send(serout)
        print("statistics sent!")

        print(serout)
    end

end