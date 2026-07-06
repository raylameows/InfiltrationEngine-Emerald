local Writer = {}
Writer.__index = Writer

type self = {
	
}
type Writer = setmetatable<self, typeof(Writer)>

function Writer.new(root: {[any]: any}): Writer
	local self = setmetatable({} :: self, Writer)
	self.Root = root
	
	root.Maid:Add(self.Root.Interface.Input:GetPropertyChangedSignal(`Text`):Connect(function()
		self:Write()
	end))
	
	return self
end

function Writer:Write()
	self.Root.Object:SetAttribute(self.Root.Language == `StateScript` and `ScriptSource` or `CustomBehavior`, self.Root.Interface.Input.Text)
end

return Writer