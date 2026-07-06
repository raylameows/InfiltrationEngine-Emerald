local TextService = game:GetService("TextService")

local State = {}
State.__index = State

type self = {
	DefaultAbsolutePosition: number,
	LineHeight: number,
	CursorKeys: {[Enum.KeyCode]: boolean},
	CurrentInput: string,
	SelectedSuggestion: TextButton,
	PreviousCursorPosition: number,
	PreviousSelectionStart: number,
	Tokens: {unknown},
}
type State = setmetatable<self, typeof(State)>

function State.new(root: {[any]: any}): State
	local self = setmetatable({} :: self, State)
	self.Root = root
	
	self.DefaultAbsolutePosition = self.Root.Interface.DefaultAbsolutePosition
	self.LineHeight = TextService:GetTextSize(
		`A`,
		self.Root.Interface.Input.TextSize,
		self.Root.Interface.Input.Font,
		Vector2.new(math.huge, math.huge)
	).Y
	self.CursorKeys = {}
	self.CurrentInput = nil
	self.SelectedSuggestion = nil
	self.PreviousCursorPosition = 0
	self.PreviousSelectionStart = 0

	self.Root.Interface.Caret.Size = UDim2.fromOffset(self.Root.Interface.Caret.Size.X.Offset, self.LineHeight)
	self.Root.Interface.LineHighlight.Size = UDim2.new(1, 0, 0, self.LineHeight)

	return self
end

return State