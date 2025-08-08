local component = require("component")
local sides = require("sides")
local term = require("term")
local os = require("os")

-- its all about the game

-- init the time vars
local bigP = 0
local midP = 0
local lilP = 0
-- hehehe its lilpip

term.clear()

print("")
print("▄▖         ▄▖    ▗     ▜   ▄▖    ▗      ")
print("▙▌▌▌▛▛▌▛▌  ▌ ▛▌▛▌▜▘▛▘▛▌▐   ▚ ▌▌▛▘▜▘█▌▛▛▌")
print("▌ ▙▌▌▌▌▙▌  ▙▖▙▌▌▌▐▖▌ ▙▌▐▖  ▄▌▙▌▄▌▐▖▙▖▌▌▌")
print("       ▌                     ▄▌         ")
print("")
print("Max 99k mB - Min 100 mB")
print("Amount of fluid in mB:")
local num = term.read()

-- html like linebreak because I am lazy
local function BR()
  print("")
end
 

-- split the user defined amount into nice groups
-- credits to IntellectualPotato for this
-- also sry to I.P for butchering the code..

local function splitnum(num)
  local num_str = tostring(num)
  
  local finalnums = {}
  
  for i = 1, #num_str do
      local digit = string.sub(num_str, i, i)
      local numbsleft = #num_str - i
      local zeroes = ""
      for z = 1, numbsleft do
          zeroes = zeroes.."0"
      end
      table.insert(finalnums, tonumber(digit..zeroes))
  end
  
  return finalnums
end

for _, splitnum in pairs(splitnum(num)) do
  -- celestia please forgive me for this
  spig = splitnum//10
  if spig ~= 0 then
    print(_, spig)
  end
  -- big pump
  if spig > 9999 then
    bigP = spig//10000
  end
  -- if more than 1k mB then use the 1k mB/s pump
  if spig > 999 and spig < 10000 then 
    midP = spig//1000 
  end
  -- otherwise use the slow one
  if spig < 1000 and spig > 10 then 
    lilP = spig//100
  end

  -- yes this does bottleneck the throughput if you are trying to 
  -- put a metric fuck ton of fluid into smth, but also the container
  -- probably wont be able to hold all of it, so like.. its a feature :3

end

print("---")
print("Wait Time in Seconds: ", lilP - 0.2 + midP - 0.2 + bigP - 0.2)
print("---")

-- pretty self explanatory (sic), let liquid through, sleep so enough can get through, and then close
if bigP > 0 then
  print("BP Input: ", bigP)
  component.redstone.setOutput(sides.up,15)
  os.sleep(bigP - 0.2)
  component.redstone.setOutput(sides.up,0)
end
-- 1k - 10k pump
if midP > 0 then
  print("MP Input: ", midP)
  component.redstone.setOutput(sides.east,15)
  os.sleep(midP - 0.2)
  component.redstone.setOutput(sides.east,0)
end
-- sub 1k pump, and even more lilpip
if lilP > 0 then
  print("LP Input: ", lilP)
  component.redstone.setOutput(sides.south,15)
  os.sleep(lilP - 0.2)
  component.redstone.setOutput(sides.south,0)
end
-- dont ask why the -0.2 seconds is needed, it just is
BR()
print("---===---")
print("Operation Complete")
print("Output amount:", bigP*10000+midP*1000+lilP*100)
print("---===---")
BR()
