local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Settings = require(`../Shared/Settings`)

local Caret = {}
Caret.__index = Caret

type self = {

}
type Caret = setmetatable<self, typeof(Caret)>

local function NumInRange(min: number, num: number, max: number): boolean
	return num >= min and num <= max
end

function Caret.new(root: {[any]: any}): Caret
	local self = setmetatable({} :: self, Caret)
	self.Root = root

	self.AnimatedCaret = Settings:Get(`AnimatedCaret`)
	self.AnimatedLineHighlight = Settings:Get(`AnimatedLineHighlight`)
	self.CaretTweenInfo = TweenInfo.new(Settings:Get(`AnimatedCaretTime`), Enum.EasingStyle.Linear, Enum.EasingDirection.In)
	self.LineHighlightTweenInfo = TweenInfo.new(Settings:Get(`AnimatedLineHighlightTime`), Enum.EasingStyle.Linear, Enum.EasingDirection.In)

	self.Blinking = Settings:Get(`CaretBlinking`)
	self.BlinkSpeed = Settings:Get(`CaretBlinkSpeed`)
	
	root.Maid:Add(self.Root.Interface.Input:GetPropertyChangedSignal(`CursorPosition`):Connect(function()
		local keys = {}
		for _, key in (UserInputService:GetKeysPressed()) do
			keys[key.KeyCode] = true
		end

		self.Root.State.CursorKeys = keys
		self:Update()
		self.Root.Selection:Update()
		self.Root.State.PreviousCursorPosition = self.Root.Interface.Input.CursorPosition
	end))
	self:Update()
	
	if self.Blinking then
		task.spawn(function()
			while self.Root.Interface.Caret.Parent do
				self.Root.Interface.Caret.Visible = not self.Root.Interface.Caret.Visible
				task.wait(self.BlinkSpeed)
			end
		end)
	end
	
	return self
end

function Caret.Update(self: Caret)
	if self.Root.Interface.Input.CursorPosition == -1 then
		self.Root.Interface.Caret.Position = UDim2.fromScale(-1, -1)
		self.Root.Interface.LineHighlight.Position = UDim2.fromScale(-1, -1)
	else
		local pos = self:GetPosition()
		
		if not self.AnimatedCaret then
			self.Root.Interface.Caret.Position = UDim2.fromOffset(pos.X, pos.Y)
		else
			TweenService:Create(
				self.Root.Interface.Caret,
				self.CaretTweenInfo,
				{Position = UDim2.fromOffset(pos.X, pos.Y)}
			):Play()
		end
		
		if not self.AnimatedLineHighlight then
			self.Root.Interface.LineHighlight.Position = UDim2.fromOffset(0, pos.Y)
		else
			TweenService:Create(
				self.Root.Interface.LineHighlight,
				self.LineHighlightTweenInfo,
				{Position = UDim2.fromOffset(0, pos.Y)}
			):Play()
		end
	end
	
	if self.Root.Suggestions then
		self.Root.Suggestions:Update()
	end
end

function Caret.GetToken(self: Caret, cursor: number, tokens: {}?): number?
	for index, token in (tokens or self.Root.State.Tokens) do
		if NumInRange(token.Start, cursor - 1, token.End) then
			return index
		end
	end

	return nil
end

function Caret.GetPosition(self: Caret): Vector2
	local cursor = math.max(self.Root.Interface.Input.CursorPosition, 1)
	local beforeCursor = string.sub(self.Root.Interface.Input.Text, 1, cursor - 1)

	local lines = string.split(beforeCursor, `\n`)
	local currentLine = lines[#lines]
	local lineWidth = TextService:GetTextSize(
		currentLine,
		self.Root.Interface.Input.TextSize,
		self.Root.Interface.Input.Font,
		Vector2.new(math.huge, math.huge)
	).X

	local position = Vector2.new(
		self.Root.State.DefaultAbsolutePosition.X + lineWidth,
		self.Root.State.DefaultAbsolutePosition.Y + (#lines - 1) * self.Root.State.LineHeight
	)

	return position
end

return Caret