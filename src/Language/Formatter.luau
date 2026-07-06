local Tokenizer = require(`./Tokenizer`)
local utf8lib = require(`../Util/utf8lib`)
local Settings = require(`../Shared/Settings`)
local sub, len = utf8lib.sub, utf8lib.len

local Languages = {}
for _, language in (script.Parent.Languages:GetChildren()) do
	Languages[language.Name] = require(language)
end

local function Style(style: string, text: string): string
	return style:gsub(`TEXT`, text)
end

local function Color(color: Color3, text: string): string
	local style = `<font color="rgb({math.round(color.R * 255)},{math.round(color.G * 255)},{math.round(color.B * 255)})">TEXT</font>`
	return style:gsub(`TEXT`, text)
end

return function(language: string, tokens: {})
	local commands = Languages[language].Commands
	for index, token in (tokens) do
		local newToken = token.Token

		local setting = (token.Type == `Command` and commands[token.Token]) and commands[token.Token].Style or (token.Type ~= `Command` and `{token.Type}Color`)
		local color = Settings:Get(setting)
		if color then
			newToken = Color(color, newToken)
		end

		token.Rich = newToken
	end

	return Tokenizer:ToSource(tokens)
end