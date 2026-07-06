-- // hi

local Tokenizer = require(`../Language/Tokenizer`)
local Formatter = require(`../Language/Formatter`)

local Renderer = {}
Renderer.__index = Renderer

type self = {

}
type Renderer = setmetatable<self, typeof(Renderer)>

function Renderer.new(root: {[any]: any}): Renderer
	local self = setmetatable({} :: self, Renderer)
	self.Root = root
	
	root.Maid:Add(self.Root.Interface.Input:GetPropertyChangedSignal(`Text`):Connect(function()
		self:Render()
	end))
	self:Render()

	return self
end

function Renderer.Render(self: Renderer)
	self.Root.Interface:UpdateCanvas()
	
	local tokens = Tokenizer:FromSource(self.Root.Language, self.Root.Interface.Input.Text)
	self.Root.State.Tokens = tokens
	self.Root.Interface.Text.Text = Formatter(self.Root.Language, tokens)
	self.Root.Interface.LinesDisplay.Text = ``
	for index, line in (string.split(self.Root.Interface.Input.Text, `\n`)) do
		self.Root.Interface.LinesDisplay.Text ..= index.. `\n`
	end

	self.Root.Suggestions:Update()
end

return Renderer