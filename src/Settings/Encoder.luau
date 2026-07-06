local Encoder = {}

function Encoder.Color3(value: Color3): string
	return `{math.round(value.R * 255)}, {math.round(value.G * 255)}, {math.round(value.B * 255)}`
end

function Encoder.number(value: number): string
	return tostring(value)
end

function Encoder.boolean(value: boolean): string
	return value and `true` or `false`
end

return Encoder