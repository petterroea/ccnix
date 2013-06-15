--Static variables
version = "0.1"
local session = "null"

--Logs some text
function log(String)
	print("["..os.clock().."]"..String)
end
--Prints a line
function printLine(String)
	print(String)
end
--Prints text
function printText(String)
	term.write(String)
end
--Sets cursor position
function setCursorPos(x,y)
	term.setCursorPos(x,y)
end
--Changes Background color
function setBgColor(Color)
	term.setBackgroundColor(Color)
end
--Converts cc color to ccnix color
function toCcnixColor(Col)
	if Col == 1 then return 0 end
	if Col == 2 then return 1 end
	if Col == 4 then return 2 end
	if Col == 8 then return 3 end
	if Col == 16 then return 4 end
	if Col == 32 then return 5 end
	if Col == 64 then return 6 end
	if Col == 128 then return 7 end
	if Col == 256 then return 8 end
	if Col == 512 then return 9 end
	if Col == 1024 then return 10 end
	if Col == 2048 then return 11 end
	if Col == 4096 then return 12 end
	if Col == 8192 then return 13 end
	if Col == 16384 then return 14 end
	if Col == 32768 then return 15 end
end
--Promt for passwords
function readPassword()
	local toReturn = ""
	while true do
		local pressed = os.pullEvent("char")
		if pressed == "\n" then break end
		toReturn = toReturn + pressed
	end
	return toReturn
end
function isRoot()
	return session == "root"
end

log("ccnix "..version)
printLine(os.getComputerLabel() .. " login: ")
local username = read()