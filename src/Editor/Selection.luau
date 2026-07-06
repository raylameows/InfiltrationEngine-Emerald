local Selection = {}
Selection.__index = Selection

type self = {
	
}
type Selection = setmetatable<self, typeof(Selection)>

function Selection.new(root: {[any]: any}): Selection
	local self = setmetatable({} :: self, Selection)
	self.Root = root

	return self
end

-- WHY is this not a feature of TextBoxes
function Selection.Update(self: Selection)
	local keys = self.Root.State.CursorKeys
	if keys[Enum.KeyCode.LeftShift] and (keys[Enum.KeyCode.Up] or keys[Enum.KeyCode.Down]) then
		--self.Root.Interface.Input.SelectionStart = self.Root.Interface.Input.SelectionStart == -1 and self.Root.State.PreviousCursorPosition or self.Root.State.PreviousSelectionStart
		self.Root.Interface.Input.SelectionStart = self.Root.State.PreviousSelectionStart == -1 and self.Root.State.PreviousCursorPosition or self.Root.State.PreviousSelectionStart
	end
	
	self.Root.State.PreviousSelectionStart = self.Root.Interface.Input.SelectionStart
end

return Selection