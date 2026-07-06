local Maid = require(`../Util/Maid`)

local Interface = require(`../Settings/Interface`)
local Encoder = require(`../Settings/Encoder`)
local Decoder = require(`../Settings/Decoder`)

local Settings = {}
Settings.__index = Settings

type self = {
	Object: Instance,
	Language: string,
	Maid: {Maid.Maid}
}
type Settings = setmetatable<self, typeof(Settings)>

function Settings.new(): Settings
	local self = setmetatable({} :: self, Settings)
	self.Maid = Maid.new()

	self.Encoder = Encoder
	self.Decoder = Decoder
	self.Interface = Interface.new(self)

	return self
end

function Settings.Destroy(self: Settings)
	self.Maid:Destroy()
	self = nil
end

return Settings