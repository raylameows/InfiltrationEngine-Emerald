local Toolbar: PluginToolbar = plugin:CreateToolbar(`EmeraldEditor`)
local Button = Toolbar:CreateButton(`Emerald`, `Allows you to easily edit state-scripts and custom behaviors directly in Studio`, `rbxassetid://134453877661191`)
local Plugin = require(`./Core/Plugin`)(plugin)
local Manager = require(`./Core/Manager`)
local EmeraldSettings = require(`./Core/Settings`).new()
Manager:Init()

Button.Click:Connect(function()
	EmeraldSettings.Interface.Widget.Enabled = not EmeraldSettings.Interface.Widget.Enabled
end)