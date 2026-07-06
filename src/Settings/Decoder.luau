local Decoder = {}

function Decoder.Color3(value: string): Color3
	return Color3.fromRGB(unpack(value:split(`, `)))
end

function Decoder.number(value: string): number
	return tonumber(value)
end

function Decoder.boolean(value: string): number
	return value == `true` and true or false
end

return Decoder