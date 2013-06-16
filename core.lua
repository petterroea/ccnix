--DOC ON RUNLEVELS
--1 - Not logged in
--2 - Terminal functionality
--3 - Running a shell
--Static variables
version = "0.1"
local session = "null"
local runlevel = 1
local shellFunction = nil
local workingPath = "/"
local homePath = "/"
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
--Reads a line of text
function readLine()
	return read()
end
function setShell(Shell)
	shellFunction = Shell
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
		toReturn = toReturn .. pressed
	end
	return toReturn
end
--Checks if the user is root
function isRoot()
	return session == "root"
end
--Checks login
local function checkLogin()
	return true --Temp
end
--Startup block
term.clear()
term.setCursorPos(1,1)
log("ccnix "..version)
log("Loading user list")
os.loadAPI("/bin/usr")
for key,value in pairs(usr.userDatabase) do print(key,value) end
if os.getComputerLabel() == nil then
	log("This computer has no label! Setting default label...")
	os.setComputerLabel("ccnix")
end
local i = 0
while runlevel > 0 do
	if runlevel == 1 then
		printText(os.getComputerLabel() .. " login: ")
		local username = readLine()
		printLine("")
		printText(username .. "@" .. os.getComputerLabel() .. "'s password:")
		local pass = readPassword()
		if checkLogin(username, pass) then
			session = username
			runlevel = 2
		else
			printLine("Incorrect password!")
		end
	end
	if runLevel == 2 then
		local pathString = workingPath
		if pathString == homePath then pathString = "~" end
		printText(username .. "@" .. os.getComputerLabel() .. ":" .. pathString .. ":")
	end
	if runlevel == 3 then
		shellFunction()
	end
end
log("Halting...")
os.shutdown()