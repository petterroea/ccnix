--Setup program
--Color palette
local bgColor = 1024
local fgColor = 256
local textColor = 32768
local selectedColor = 16384
local progressBarBg = 128
function setColor(Color)
	if term.isColor() then
		term.setTextColor(Color)
	end
end
function setBgColor(Color)
	if term.isColor() then
		term.setBackgroundColor(Color)
	end
end
function repeatChar(Char, Times)
	for i=0,Times,1 do
		term.write(Char)
	end
end
function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
local width, height = term.getSize()
function renderDialog(Text, Title)
	term.setCursorPos(1,height-1)
	setBgColor(bgColor)
	term.scroll(3)
	local blankDialogText = ""
	for i=0,width-5,1 do
		blankDialogText = blankDialogText .. " "
	end
	for i=0,height-5,1 do
		setBgColor(bgColor)
		term.write("  ")
		setBgColor(fgColor)
		term.write(blankDialogText)
		setBgColor(bgColor)
		print("")
	end
	term.scroll(1)
	--Draw details
	setColor(textColor)
	setBgColor(fgColor)
	term.setCursorPos(3,3)
	term.write("+")
	term.setCursorPos(3,height-2)
	term.write("+")
	term.setCursorPos(width-2,height-2)
	term.write("+")
	term.setCursorPos(width-2,3)
	term.write("+")
	term.setCursorPos(4,3)
	repeatChar("-", width-7)
	term.setCursorPos(4,height-2)
	repeatChar("-", width-7)
	for i=0,height-7,1 do
		term.setCursorPos(3,i+4)
		term.write("|")
	end
	for i=0,height-7,1 do
		term.setCursorPos(width-2,i+4)
		term.write("|")
	end
	--Draw text
	if Title == nil then
	else
		setColor(selectedColor)
		setBgColor(fgColor)
		term.setCursorPos((width/2)-(string.len(Title)/2), 3)
		term.write(Title)
	end
	setColor(textColor)
	for i=1,tablelength(Text),1 do
		term.setCursorPos((width/2)-(string.len(Text[i])/2), 5+i)
		term.write(Text[i])
	end
end
function renderOkDialog(Text, Title)
	renderDialog(Text, Title)
	setBgColor(selectedColor)
	setColor(textColor)
	term.setCursorPos((width/2)-2, height-4)
	term.write("<OK>")
	while true do
		event, number = os.pullEvent("key")
		if number == 28 then break end
	end
end
function renderProgressDialog(Text, Title, Precentage)
	renderDialog(Text, Title)
	local len = width-12
	local toDraw = round((Precentage/100.0)*len, 0)
	term.setCursorPos(6, height-4)
	setBgColor(selectedColor)
	for i=0,toDraw,1 do
		term.write(" ")
	end
	setBgColor(progressBarBg)
	for i=0,len-toDraw,1 do
		term.write(" ")
	end
end
function renderPromptDialog(Text, Title)
	renderDialog(Text, Title)
	setBgColor(bgColor)
	setColor(fgColor)
	local markerAt = 1
	local returnable = ""
	while true do
		term.setCursorPos(6, height-4)
		for i=0,width-12,1 do
			if i == markerAt then 
				setBgColor(textColor) 
			else 
				setBgColor(bgColor) 
			end
			if string.len(returnable) >= i then
				term.write(string.sub(returnable,i,i))
			else
				term.write("_")
			end
		end
		event, param1 = os.pullEvent()
		if event == "key" then
			if param1 == 28 then
				break
			end
			if param1 == 14 then
				if string.len(returnable)>0 then
					returnable = string.sub(returnable,0,string.len(returnable)-1)
					markerAt = markerAt - 1
				end
			end
		elseif (event == "char") and (markerAt<16) then
			returnable = returnable .. param1
			markerAt = markerAt + 1
		end
	end
	return returnable
end
function downloadFile(Url, To)

	local fileHandle = fs.open(To, "w")
	local httpHandle = http.get(Url)
	fileHandle.write(httpHandle.readAll())
	fileHandle.close()
	httpHandle.close()
end
function makeDir(dir)
	if fs.exists(dir) == true then
		fs.delete(dir)
	end
	fs.makeDir(dir)
end
renderDialog({"Checking requirements", "", "Please wait..."}, "ccnix") -- Placeholder
sleep(3)
username = renderPromptDialog({"What do you want your username to be?"}, "Username")
renderOkDialog({"ccnix will now be installed"}, "Notice")
renderProgressDialog({"Creating filesystem", "please wait..."}, "Installing", 0)
makeDir("/home")
makeDir("/home/" .. username)
makeDir("/bin")
makeDir("/usr")
makeDir("/lib")
renderProgressDialog({"Downloading core files", "please wait..."}, "Installing", 50)
downloadFile("https://raw.github.com/petterroea/ccnix/master/core.lua", "/bin/core")
downloadFile("https://raw.github.com/petterroea/ccnix/master/startup.lua", "/startup")