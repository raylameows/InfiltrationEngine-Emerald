local pluginGiven = nil

return function(pluginSource: Plugin?): Plugin?
	if pluginSource then
		pluginGiven = pluginSource
	end
	
	return pluginGiven
end