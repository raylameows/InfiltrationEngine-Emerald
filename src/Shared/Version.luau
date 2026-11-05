local HttpService = game:GetService("HttpService")

local CurrentVersion = require(`./CurrentVersion`)
local NewestVersion = nil
local Version = {}

function Version.getNewest(): string
	if NewestVersion then
		return NewestVersion
	end
	
	local success, result = pcall(function()
		return HttpService:GetAsync(`https://raw.githubusercontent.com/raylameows/InfiltrationEngine-Emerald/refs/heads/main/src/Shared/CurrentVersion.luau?t={os.clock()}`)
	end)
	
	if success then
		NewestVersion = result:match("return%s+[`\"]([^`\"]+)[`\"]")
	end
	
	return NewestVersion or `vX.X.X`
end

function Version.getCurrent(): string
	return CurrentVersion
end

function Version.isOutdated(): boolean
	return Version.getNewest() ~= Version.getCurrent()
end

type Version = typeof(Version)
return Version