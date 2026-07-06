local utf8lib = require(`../Util/utf8lib`)
local sub, len = utf8lib.sub, utf8lib.len

local Languages = {}
for _, language in (script.Parent.Languages:GetChildren()) do
	Languages[language.Name] = require(language)
end

local Tokenizer = {}

local function ReadUntil(chars: {string}, start: number, terminators: {string}?, includeTerminator: boolean?): (string, number)
	if not terminators then terminators = {` `, `\n`, "{"} end

	local full = ``
	local index = start
	local source = table.concat(chars)
	while chars[index] do
		local matched
		for _, term in terminators do
			if utf8lib.sub(source, index, index + utf8lib.len(term) - 1) == term then
				matched = term
				break
			end
		end

		if matched then
			if includeTerminator then
				full ..= matched
				index += utf8lib.len(matched)
			end
			return full, index
		end

		full ..= chars[index]
		index += 1
	end

	return full, index
end

function Tokenizer.FromSource(self: Tokenizer, language: string, source: string): {string}
	local tokens = {}
	local data = {}
	local chars = utf8lib.chars(source)
	local iter = Languages[language].Rules(chars, ReadUntil)
	
	local index = 1
	local function Push(tokenType: string, token: string)
		table.insert(tokens, {
			Type = tokenType,
			Token = token,
			Start = index - len(token),
			End = index - 1
		})
	end
	
	while chars[index] do
		local tokenType, token
		tokenType, token, index = iter(index)
		Push(tokenType, token)
	end
	
	return tokens, data
end

function Tokenizer.ToSource(self: Tokenizer, tokens: {string}): string
	local result = ``
	for index, token in (tokens) do
		result ..= token.Rich or token.Token
	end

	return result
end

type Tokenizer = typeof(Tokenizer)
return Tokenizer