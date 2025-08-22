local serialization = require("serialization")
local component = require("component")
local event = require("event")
local term = require("term")
local os = require("os")


local sm = component.tunnel
local tape = component.tape_drive
local chatbox = component.chat_box
component.gpu.setResolution(25,25)


t = {}

sm.setWakeMessage("mnmn")

function initprog()
    -- send start signal
    print("sending wake sig")
    sm.send("mnmn")
    -- wait for a response
    event.pull("modem_message")
    sm.send("ack")

    
end

function networkHandler()
    local _, _, _, _, _, msg = event.pull("modem_message")
    
    if msg == "png" then
        sm.send("ack")
    else
        unser = serialization.unserialize(msg)
        -- assign the table variable
        t = unser
    end
end

-- display the stats to a screen
-- make some nice graphics pls <3
function dispstat()
    term.clear()
    print("")
    print("Heat",  "", t[1])
    print("Depletion", t[2])
    print("Power", "", t[3])
    print("")
    print("-------------------------")
    print("")
    print("Replace fuel rods at")
    print(">1MHe power generation")
    print("")
    print("Last GPC roll:")
    print(gpc)
    print("")

    if treatime == true then
        print("[[[[ CLICK DISPENSED ]]]]")
    end

end

-- dont ask why this is here
-- or do, I aint your mom
function goodpuppyclickies()
    gpc = math.random(1, 22)
    if gpc == 1 then
        tape.play()
        treatime = true
        os.sleep(3)
    end

end

initprog()

while true do
    -- request data
    sm.send("req")
    networkHandler()

    goodpuppyclickies()
    dispstat()

    if treatime == true then
        os.sleep(7)
        tape.stop()
        tape.seek(-tape.getSize())
        treatime = false
    else
        local _, _, plym, chatm = event.pull(10, "chat_message")
        if chatm == "click click" then
            tape.play()
            treatime = true
        end
    end

end
