local Maid = {}
Maid.__index = Maid

type self = {
	Jobs: {RBXScriptConnection | Instance}
}
export type Maid = setmetatable<self, typeof(Maid)>

function Maid.new(root: {[any]: any}): Maid
	local self = setmetatable({} :: self, Maid)
	self.Jobs = {}

	return self
end

function Maid.Add(self: Maid, object: Instance | RBXScriptConnection)
	table.insert(self.Jobs, object)
end

function Maid.Clean(self: Maid)
	for index, object in (self.Jobs) do
		local objectType = typeof(object)
		if objectType == `RBXScriptConnection` then
			object:Disconnect()
		elseif objectType == `Instance` then
			object:Destroy()
		end
		
		object = nil
	end
end

function Maid.Destroy(self: Maid)
	self:Clean()
	self = nil
end

return Maid