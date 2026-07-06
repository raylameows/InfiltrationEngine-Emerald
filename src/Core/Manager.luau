local Selection = game:GetService("Selection")

local plugin = require(`./Plugin`)()
local Document = require(`./Document`)
local Initiator = require(`../Language/Initiator`)

local Languages = {}
for _, language in (script.Parent.Parent.Language.Languages:GetChildren()) do
	Languages[language.Name] = require(language)
end

local Manager = {}
Manager.Current = nil :: number
Manager.Tabs = {} :: {unknown}
Manager.SelectConnection = nil :: RBXScriptConnection
Manager.Maids = {}

local function ValidateInstance(instance: Instance, rulesets: {}): boolean
	for _, ruleset in (rulesets) do
		local valid = true
		for _, rule in (ruleset) do
			local ruleType, key, expected = unpack(rule)
			if ruleType == `Attribute` then
				if instance:GetAttribute(key) ~= expected then
					valid = false
					break
				end
			elseif ruleType == `Property` then
				if instance[key] ~= expected then
					valid = false
					break
				end
			elseif ruleType == `Check` then
				if key == `IsA` then
					if not instance:IsA(expected) then
						valid = false
						break
					end
				else
					valid = false
					break
				end
			else
				valid = false
				break
			end
		end

		if valid then
			return true
		end
	end

	return false
end

function Manager.Init(self: Manager)
	for _, language in (script.Parent.Parent.Language.Languages:GetChildren()) do
		Initiator(language.Name)
	end
	
	self.SelectConnection = Selection.SelectionChanged:Connect(function()
		local fullSelection = Selection:Get()
		local selected = fullSelection[1]
		if self.Current and self.Current ~= selected then
			self:DestroyTab(self.Current)
			self.Current = nil
		end
		
		if not selected or fullSelection[2] then return end
		
		local language = self:GetLanguage(selected)
		if language then
			local tabId = self:GetTab(selected)
			if not tabId then
				tabId = self:CreateTab(selected, language)
				self.Current = tabId
			else
				self:OpenTab(tabId)
			end
		end
	end)
end

function Manager.GetLanguage(self: Manager, object: Instance)
	if ValidateInstance(object, Languages.StateScript.Instances) then
		return `StateScript`
	elseif ValidateInstance(object, Languages.CustomBehavior.Instances) then
		return `CustomBehavior`
	end
	
	--if (object:IsA(`BoolValue`) and object:GetAttribute(`Type`) == `StateScript`) or (object:IsA(`BasePart`) and object.Name == `StateScriptPart`) then
	--	return `StateScript`
	--elseif (object:IsA(`BoolValue`) and object:GetAttribute(`Type`) == `CustomBehaviorCondition`) then
	--	return `CustomBehavior`
	--end
end

function Manager.CreateTab(self: Manager, object: Instance, language: string)
	table.insert(self.Tabs, {
		Object = object,
		Tab = Document.new(object, language, self.Maids)
	})

	return #self.Tabs
end

function Manager.GetTab(self: Manager, object: Instance): number?
	for index, tab in (self.Tabs) do
		if tab.Object == object then
			return index
		end
	end

	return false
end

function Manager.DestroyTab(self: Manager, id: number)
	self.Tabs[id].Tab:Destroy()
	table.remove(self.Tabs, id)
end

function Manager.Clean(self: Manager)
	for index, maid in (self.Maids) do
		maid:Destroy()
	end
	
	self.SelectConnection:Disconnect()
	self.SelectConnection = nil
end

plugin.Unloading:Connect(function()
	Manager:Clean()
end)

export type Manager = typeof(Manager)
return Manager