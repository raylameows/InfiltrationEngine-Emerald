local Tokenizer = require(`../../Language/Tokenizer`)
local Formatter = require(`../../Language/Formatter`)
local utf8lib = require(`../../Util/utf8lib`)

local Renderer = {}
Renderer.__index = Renderer

type self = {
	Root: {[any]: any},
	Initialized: boolean,

	Lines: {string},
	FormattedLines: {string},
	TokensByLine: {{any}},
}
type Renderer = setmetatable<self, typeof(Renderer)>

function Renderer.new(root: {[any]: any}): Renderer
	local self = setmetatable({} :: self, Renderer)

	self.Root = root
	self.Initialized = false

	self.Lines = {}
	self.FormattedLines = {}
	self.TokensByLine = {}

	root.Maid:Add(self.Root.Interface.Input:GetPropertyChangedSignal(`Text`):Connect(function()
		self:Render()
	end))

	self:Render()

	return self
end

function Renderer.IsSameLine(self: Renderer, oldIndex: number, newIndex: number, oldLines: {string}, newLines: {string}): boolean
	local oldLine = oldLines[oldIndex]
	local newLine = newLines[newIndex]
	if oldLine ~= newLine then return false end

	local oldHasNewline = oldIndex < #oldLines
	local newHasNewline = newIndex < #newLines
	return oldHasNewline == newHasNewline
end

function Renderer.TokenizeLine(self: Renderer, lineNumber: number, lines: {string}): ({any}, string)
	local line = lines[lineNumber] or ``
	if lineNumber < #lines then
		line ..= `\n`
	end

	local tokens = Tokenizer:FromSource(self.Root.Language, line)
	local formatted = Formatter(self.Root.Language, tokens)
	return tokens, formatted
end

function Renderer.UpdateLines(self: Renderer, lines: {string})
	local oldLines = self.Lines
	local oldTokens = self.TokensByLine
	local oldFormatted = self.FormattedLines

	local oldCount = #oldLines
	local newCount = #lines

	local prefix = 0
	while prefix < math.min(oldCount, newCount) do
		local index = prefix + 1
		if not self:IsSameLine(index, index, oldLines, lines) then break end
		prefix += 1
	end

	local oldEnd = oldCount
	local newEnd = newCount
	while oldEnd > prefix and newEnd > prefix do
		if not self:IsSameLine(oldEnd, newEnd, oldLines, lines) then break end
		oldEnd -= 1
		newEnd -= 1
	end

	local tokensByLine = {}
	local formattedLines = {}
	for index = 1, prefix do
		tokensByLine[index] = oldTokens[index]
		formattedLines[index] = oldFormatted[index]
	end

	for index = prefix + 1, newEnd do
		local tokens, formatted = self:TokenizeLine(index, lines)
		tokensByLine[index] = tokens
		formattedLines[index] = formatted
	end

	local suffixCount = oldCount - oldEnd
	for offset = 1, suffixCount do
		local oldIndex = oldEnd + offset
		local newIndex = newEnd + offset
		tokensByLine[newIndex] = oldTokens[oldIndex]
		formattedLines[newIndex] = oldFormatted[oldIndex]
	end

	self.Lines = lines
	self.TokensByLine = tokensByLine
	self.FormattedLines = formattedLines
end

function Renderer.GetLineStart(self: Renderer, lineNumber: number): number
	local position = 1
	
	for index = 1, lineNumber - 1 do
		position += utf8lib.len(self.Lines[index]) + 1
	end

	return position
end

function Renderer.RebuildTokens(self: Renderer)
	local tokens = {}

	for lineNumber = 1, #self.Lines do
		local lineTokens = self.TokensByLine[lineNumber]
		local lineStart = self:GetLineStart(lineNumber)
		for _, originalToken in (lineTokens) do
			local token = table.clone(originalToken)
			token.Start += lineStart - 1
			token.End += lineStart - 1
			table.insert(tokens, token)
		end
	end

	self.Root.State.Tokens = tokens
end

function Renderer.RebuildFormattedText(self: Renderer)
	self.Root.Interface.Text.Text = table.concat(self.FormattedLines, ``)
end

function Renderer.RebuildLineNumbers(self: Renderer)
	self.Root.Interface.LinesDisplay.Text = ``

	for index in (self.Lines) do
		self.Root.Interface.LinesDisplay.Text ..= index.. `\n`
	end
end

function Renderer.Render(self: Renderer)
	self.Root.Interface:UpdateCanvas()

	local text = self.Root.Interface.Input.Text
	local lines = string.split(text, `\n`)

	if not self.Initialized then
		self.Lines = {}
		self.TokensByLine = {}
		self.FormattedLines = {}

		for index = 1, #lines do
			local tokens, formatted = self:TokenizeLine(index, lines)
			self.TokensByLine[index] = tokens
			self.FormattedLines[index] = formatted
		end

		self.Lines = lines
		self.Initialized = true
	else
		self:UpdateLines(lines)
	end

	self:RebuildTokens()
	self:RebuildFormattedText()
	self:RebuildLineNumbers()
	self.Root.Suggestions:Update()
end

return Renderer