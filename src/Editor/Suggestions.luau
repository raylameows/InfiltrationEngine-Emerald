local UserInputService = game:GetService("UserInputService")

local Autocomplete = require(`../Language/Autocomplete`)
local Create = require(`../UI/Create`)

local Suggestions = {}
Suggestions.__index = Suggestions

type self = {
	
}
type Suggestions = setmetatable<self, typeof(Suggestions)>

local function ModifyString(str: string, insert: string, position: number): string
	return string.sub(str, 1, position - 1).. insert.. string.sub(str, position)
end

local function StripPreviousCharacters(str, position, amount)
	return string.sub(str, 1, position - amount - 1) .. string.sub(str, position)
end

function Suggestions.new(root: {[any]: any}): Suggestions
	local self = setmetatable({} :: self, Suggestions)
	self.Root = root
	
	root.Maid:Add(UserInputService.InputBegan:Connect(function(input: InputObject, gpe: boolean)
		local current = self.Root.State.SelectedSuggestion
		if current and current.Parent then
			local cursorPos = self.Root.Interface.Input.CursorPosition
			local search

			if input.KeyCode == Enum.KeyCode.Down then
				search = current.LayoutOrder + 1
			elseif input.KeyCode == Enum.KeyCode.Up then
				search = current.LayoutOrder - 1
			elseif input.KeyCode == Enum.KeyCode.Escape then
				self.Root.Interface.SuggestionFrame.Visible = false
				self.Root.State.SelectedSuggestion = nil
				task.wait()
				self.Root.Interface.Input:CaptureFocus()
				self.Root.Interface.Input.CursorPosition = self.PreviousCursorPosition
			elseif input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.Tab then
				local remove = #self.Root.State.CurrentInput
				local add = current.Text

				self.Root.Interface.Input.TextEditable = false
				self.Root.Interface.Input.Text = ModifyString(StripPreviousCharacters(self.Root.Interface.Input.Text, cursorPos, remove), add, cursorPos - remove)
				task.wait()
				self.Root.Interface.Input.TextEditable = true
				self.Root.Interface.Input.CursorPosition = cursorPos - remove + #add
			end

			if search then
				local match = self.Root.Interface.SuggestionFrame:QueryDescendants(`>TextButton[LayoutOrder = {search}]`)[1]
				if match then
					current.BackgroundTransparency = 1
					match.BackgroundTransparency = 0
					self.Root.State.SelectedSuggestion = match

					self.Root.Interface.SuggestionFrame.CanvasPosition += Vector2.new(0, (match.AbsolutePosition.Y + match.AbsoluteSize.Y) - (self.Root.Interface.SuggestionFrame.AbsolutePosition.Y + self.Root.Interface.SuggestionFrame.AbsoluteSize.Y))
					--if (match.AbsolutePosition.Y + match.AbsoluteSize.Y) > (self.SuggestionFrame.AbsolutePosition.Y + self.SuggestionFrame.AbsoluteSize.Y) then
					--	repeat task.wait()
					--		self.SuggestionFrame.CanvasPosition += Vector2.new(0, match.AbsoluteSize.Y / 2)
					--	until (match.AbsolutePosition.Y + match.AbsoluteSize.Y) <= (self.SuggestionFrame.AbsolutePosition.Y + self.SuggestionFrame.AbsoluteSize.Y)
					--end
				end
			end
		end
	end))

	return self
end

function Suggestions.Update(self: Suggestions)
	if self.Root.State.SelectedSuggestion and (self.Root.State.CursorKeys[Enum.KeyCode.Up] or self.Root.State.CursorKeys[Enum.KeyCode.Down] or self.Root.State.CursorKeys[Enum.KeyCode.Escape]) then
		self.Root.Interface.Input.CursorPosition = self.Root.State.PreviousCursorPosition
		return
	end

	local tokens = self.Root.State.Tokens
	local cursorToken = self.Root.Caret:GetToken(self.Root.Interface.Input.CursorPosition)

	local currentToken = tokens[cursorToken]
	local previousToken = tokens[(cursorToken or 0) - 1]
	local currentInput = currentToken and currentToken.Token
	local suggestions = currentInput and Autocomplete:Get(self.Root.Language, currentInput)
	self.Root.State.CurrentInput = currentInput

	if suggestions and #suggestions ~= 0 and suggestions[1] ~= currentInput and (not previousToken or previousToken.Type == `Newline`) then
		local pos = self.Root.Caret:GetPosition()
		local suggestionHeight = self.Root.Interface.SuggestionFrame.AbsoluteSize.Y
		local offsetY = pos.Y + self.Root.State.LineHeight
		if offsetY + suggestionHeight > self.Root.Interface.Input.AbsoluteSize.Y then
			offsetY = pos.Y - suggestionHeight
		end
		
		if self.Root.Interface.SuggestionFrame.Visible == false then
			self.Root.Interface.SuggestionFrame.CanvasPosition = Vector2.new()
			self.Root.Interface.SuggestionFrame.Visible = true
		end
		
		self.Root.Interface.SuggestionFrame.Position = UDim2.fromOffset(pos.X, offsetY)

		for index, frame in (self.Root.Interface.SuggestionFrame:QueryDescendants(`>TextButton`)) do
			if table.find(suggestions, frame.Name) then continue end
			frame:Destroy()
		end

		for index, suggestion in (suggestions) do
			local button = self.Root.Interface.SuggestionFrame:FindFirstChild(suggestion)
			if not button then
				button = Create "TextButton" {
					Name = suggestion,
					Text = suggestion,
					TextScaled = true,
					FontFace = Font.fromEnum(Enum.Font.Code),
					TextColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundColor3 = Color3.fromRGB(85, 170, 255),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 150,

					Parent = self.Root.Interface.SuggestionFrame
				}
			end

			button.LayoutOrder = index
			if index == 1 then
				button.BackgroundTransparency = 0
				self.Root.State.SelectedSuggestion = button
			else
				button.BackgroundTransparency = 1
			end
		end
	else
		self.Root.Interface.SuggestionFrame.Visible = false
		self.Root.State.SelectedSuggestion = nil
	end
end

return Suggestions