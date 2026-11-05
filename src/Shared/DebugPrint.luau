local Settings = require(`./Settings`)

return function(message: string)
	if not Settings:Get(`DebugMessages`) then return end
	print(`Emerald :: {message}`)
end