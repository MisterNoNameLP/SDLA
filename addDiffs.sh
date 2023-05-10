#!/usr/bin/pleal5.3
local version = "1"

package.path = package.path .. ";libs/?.lua"

local ut = require("UT")
local lfs = require("lfs")
local xml = require("xml2lua")
local xmlHandler = require("xmlhandler.tree")

local diffLockAddonSocket = {
	_attr = {DefaultAddon = "zikz_5368_diff_lock_default"},
	Socket = {
		_attr = {
			Names = "ZiKZ5368DiffLock",
			Offset = "(0; 0; 0)",
			ParentFrame = "BoneChassis_cdt"
		}
	}
}

local function copyTable(org)
	local copy
	if type(org) == "table" then
		copy = {}
		for key, value in pairs(org) do
			copy[key] = copyTable(value)
		end
	else
		copy = org
	end
	return copy
end

local function addDiff(path)
	print("Load file: $path")
	local truckHandler = xmlHandler:new()
	local xmlParser = xml.parser(truckHandler)
	xmlParser:parse(xml.loadFile(path))
	local _, name, ending = ut.seperatePath(path)
	local hasDifflock

	do
		if truckHandler.root.Truck.TruckData._attr.DiffLockType == "Always" then
			hasDifflock = true
		else
			for i, v in pairs(truckHandler.root.Truck.GameData.AddonSockets) do
				if v._attr and v._attr.DefaultAddon and v._attr.DefaultAddon:find("diff_lock") then
					hasDifflock = true
				end
			end
		end
	end
	
	if not hasDifflock then
		print("Adding difflock to: $name")

		if truckHandler.root.Truck.TruckData._attr.DiffLockType == "None" then
			truckHandler.root.Truck.TruckData._attr.DiffLockType = "Uninstalled"
		end

		table.insert(truckHandler.root.Truck.GameData.AddonSockets, copyTable(diffLockAddonSocket))
	end

	return xml.toXml(truckHandler.root)
end

local function addDir(path)
	local len = path:find("/")
	local outputPath = "output/" .. path:sub(len + 1)
	local outputString 
	
	do 
		local currentPath = ""
		for segment in outputPath:gmatch("[^/]+") do
			currentPath = "$currentPath$segment/"
			lfs.mkdir(currentPath)
		end
	end

	for file in lfs.dir(path) do
		if file:sub(1, 1) ~= "." then
			if lfs.attributes("$path/$file").mode == "file" then
				local path, name, ending = ut.seperatePath("$path/$file")
				local fileHandler = io.open("$outputPath/$name$ending", "w")

				outputString = addDiff("$path/$file")				
				fileHandler:write(outputString)
				fileHandler:flush()
			end
		end
	end
end

local function parseInitial(path)
	print("Parse dir: $path")
	for file in lfs.dir(path) do
		if file:sub(1, 1) ~= "." then
			if lfs.attributes("$path/$file").mode == "directory" then
				if file == "trucks" then
					addDir("$path/$file")
				else
					parseInitial("$path/$file")
				end
			end
		end
	end
end

print("Starting difflock adder v$version")

parseInitial("initial")
parseInitial("mods")

print("Done!")