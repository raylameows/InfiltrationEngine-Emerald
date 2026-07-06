local utf8lib = {}

function utf8lib.sub(str: string, first: number, last: number?)
	local len = utf8.len(str)
	if not len then
		return ``
	end

	first = math.max(first, 1)
	last = last or len
	last = math.min(last, len)

	if first > last then
		return ``
	end

	local startByte = utf8.offset(str, first)
	local endByte = utf8.offset(str, last + 1)
	if endByte then
		return string.sub(str, startByte, endByte - 1)
	else
		return string.sub(str, startByte)
	end
end

function utf8lib.len(str: string)
	return utf8.len(str)
end

function utf8lib.chars(str: string): {string}
	local chars = {}
	local i = 1
	local n = #str

	while i <= n do
		local start = i
		i = utf8.offset(str, 2, i) or (n + 1)
		chars[#chars + 1] = str:sub(start, i - 1)
	end

	return chars
end

return utf8lib