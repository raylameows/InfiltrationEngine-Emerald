return function(language: string)
	local module = require(script.Parent.Languages[language])
	for command, data in (module.Commands) do
		if data.Aliases then
			for index, alias in (data.Aliases) do
				module.Commands[alias] = data
			end
		end
	end
end