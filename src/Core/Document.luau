local Maid = require(`../Util/Maid`)

local Interface = require(`../Editor/Interface`)
local Caret = require(`../Editor/Caret`)
local State = require(`../Editor/State`)
local Suggestions = require(`../Editor/Suggestions`)
local Renderer = require(`../Editor/Renderer`)
local Selection = require(`../Editor/Selection`)
local Writer = require(`../Editor/Writer`)

local Document = {}
Document.__index = Document

type self = {
	Object: Instance,
	Language: string,
	Maid: {Maid.Maid}
}
type Document = setmetatable<self, typeof(Document)>

function Document.new(object: Instance, language: string, office: {Maid.Maid}): Document
	local self = setmetatable({} :: self, Document)
	self.Object = object
	self.Language = language
	self.Maid = Maid.new()
	table.insert(office, self.Maid)
	
	self.Interface = Interface.new(self)
	self.State = State.new(self)
	self.Caret = Caret.new(self)
	self.Suggestions = Suggestions.new(self)
	self.Renderer = Renderer.new(self)
	self.Selection = Selection.new(self)
	self.Writer = Writer.new(self)

	return self
end

-- For future multi-tab support
--function Document.Open(self: Document)

--end

--function Document.Close(self: Document)

--end

function Document.Destroy(self: Document)
	self.Maid:Destroy()
	self = nil
end

return Document