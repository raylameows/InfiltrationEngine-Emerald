local Languages = {}
for _, language in (script.Parent.Languages:GetChildren()) do
	Languages[language.Name] = require(language)
end

local Autocomplete = {}

function Autocomplete.Get(self: Autocomplete, language: string, text: string): {[number]: string}
	text = string.upper(text)

	local commands = Languages[language].Commands
	local suggestions = {}
	for command, data in (commands) do
		local startIndex, endIndex = string.find(command, text, nil, true)
		if startIndex then
			suggestions[command] = #command - #text
		end
	end
	
	local ordered = {}
	for command, points in (suggestions) do
		table.insert(ordered, {
			Command = command,
			Points = points
		})
	end
	
	table.sort(ordered, function(a, b)
		return a.Points < b.Points
	end)
	
	local result = {}
	for index, data in (ordered) do
		table.insert(result, data.Command)
	end
	
	return result
end

type Autocomplete = typeof(Autocomplete)
return Autocomplete