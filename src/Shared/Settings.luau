local plugin = require(`../Core/Plugin`)()
local Functions = {}
local function GetIndex(category: number, order: number)
	return tonumber(`{category}000{order}`)
end
local Settings = setmetatable({
	CaretWidth = {
		Index = GetIndex(1, 1),
		Display = `Caret Width`,
		Default = 1,
	},
	CaretBlinking = {
		Index = GetIndex(1, 2),
		Display = `Caret Blinking`,
		Default = true,
	},
	CaretBlinkSpeed = {
		Index = GetIndex(1, 3),
		Display = `Caret Blink Interval`,
		Default = 0.5,
	},
	AnimatedCaret = {
		Index = GetIndex(1, 4),
		Display = `Caret Animation`,
		Default = false,
	},
	AnimatedCaretTime = {
		Index = GetIndex(1, 5),
		Display = `Caret Animation Interval`,
		Default = 0.05,
	},
	AnimatedLineHighlight = {
		Index = GetIndex(1, 6),
		Display = `Line Highight Animation`,
		Default = false,
	},
	AnimatedLineHighlightTime = {
		Index = GetIndex(1, 7),
		Display = `Line Highlight Animation Interval`,
		Default = 0.05,
	},
	
	CommandColor = {
		Index = GetIndex(2, 1),
		Display = `Command Color`,
		Default = Color3.fromRGB(85, 170, 255),
	},
	LabelColor = {
		Index = GetIndex(2, 2),
		Display = `Label Color`,
		Default = Color3.fromRGB(255, 170, 255),
	},
	PrivateColor = {
		Index = GetIndex(2, 3),
		Display = `Private Color`,
		Default = Color3.fromRGB(229, 192, 123),
	},
	PreprocessorColor = {
		Index = GetIndex(2, 4),
		Display = `Preprocessor Color`,
		Default = Color3.fromRGB(255, 85, 0),
	},
	StringColor = {
		Index = GetIndex(2, 6),
		Display = `String Color`,
		Default = Color3.fromRGB(0, 204, 150),
	},
	ExprColor = {
		Index = GetIndex(2, 7),
		Display = `Expr Color`,
		Default = Color3.fromRGB(173, 241, 132),
	},
	NumberColor = {
		Index = GetIndex(2, 8),
		Display = `Number Color`,
		Default = Color3.fromRGB(255, 198, 0),
	},
	BackgroundColor = {
		Index = GetIndex(2, 9),
		Display = `Background Color`,
		Default = Color3.fromRGB(37, 37, 37)
	},
	LineHighlightColor = {
		Index = GetIndex(2, 10),
		Display = `Line Highlight Color`,
		Default = Color3.fromRGB(45, 50, 65)
	},
	CommentColor = {
		Index = GetIndex(2, 11),
		Display = `Comment Color`,
		Default = Color3.fromRGB(104, 104, 104)
	},
	ExtensionCommandColor = {
		Index = GetIndex(2, 12),
		Display = `Extension Command Color`,
		Default = Color3.fromRGB(76, 207, 255)
	},
	TextColor = {
		Index = GetIndex(2, 13),
		Display = `Text Color`,
		Default = Color3.fromRGB(204, 204, 204)
	},
}, {__index = Functions})

local Encoder = require(`../Settings/Encoder`)
local Decoder = require(`../Settings/Decoder`)

function Functions:Save()
	local data = {}
	for settingName, setting in (self) do
		if setting.Value ~= setting.Default then
			data[settingName] = Encoder[typeof(setting.Default)](setting.Value)
		end
	end

	plugin:SetSetting(`EmeraldEditorSettings`, data)
end

function Functions:Load()
	local LoadedSettings = plugin:GetSetting(`EmeraldEditorSettings`) or {}
	for settingName, setting in (self) do
		setting.Value = if LoadedSettings[settingName] ~= nil then Decoder[typeof(setting.Default)](LoadedSettings[settingName]) else setting.Default
	end
end

function Functions:Get(setting: string)
	if not Settings[setting] then return end
	return if Settings[setting].Value ~= nil then Settings[setting].Value else Settings[setting].Default
end

function Functions:List()
	return Settings
end

function Functions:Set(setting: string, value: any)
	Settings[setting].Value = value
	self:Save()
end

Settings:Load()
return Settings