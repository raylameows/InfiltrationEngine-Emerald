return {
	Instances = {
		{
			{`Attribute`, `Type`, `StateScript`},
			{`Property`, `ClassName`, `BoolValue`}
		},
		{
			{`Property`, `Name`, `StateScriptPart`},
			{`Check`, `IsA`, `BasePart`}
		},
	},
	Tokens = {
		`Preprocessor`,
		`String`,
		`Expr`,
		`Private`,
		`Command`,
		`Label`,
		`Whitespace`,
		`Newline`,
		`Number`,
		`Base`,
		`Comment`,
		`ExtensionCommand`
	},
	Rules = function(chars: {string}, ReadUntil: ({string}, number, {string}?, boolean?) -> (string, number))
		return function(index: number)
			local char = chars[index]
			local prev = chars[index - 1]
			local next = chars[index + 1]
			
			if char == `*` then
				index += 1
				return `Preprocessor`, char, index
			elseif char == `:` then
				local full
				full, index = ReadUntil(chars, index)
				return `Label`, full, index
			elseif char == `#` and prev ~= `\n` then
				local full
				full, index = ReadUntil(chars, index)
				return `Private`, full, index
			elseif char == `[` and next == `[` then
				local full
				full, index = ReadUntil(chars, index, {`]]`}, true)
				return `Expr`, full, index
			elseif char == `[` then
				local full
				full, index = ReadUntil(chars, index, {`]`}, true)
				return `String`, full, index
			elseif char == "{" then
				local full
				full, index = ReadUntil(chars, index, {`}`}, true)
				return `Expression`, full, index
			elseif char == `\n` then
				index += 1
				return `Newline`, char, index
			elseif char == ` ` then
				index += 1
				return `Whitespace`, char, index
			elseif tonumber(char) then
				local full
				full, index = ReadUntil(chars, index)
				return `Number`, full, index
			elseif (prev == `\n` or index == 1) and char == `;` then
				local full
				full, index = ReadUntil(chars, index, {`\n`})
				return `Comment`, full, index
			elseif (prev == `\n` or index == 1) and char == `#` then
				local full
				full, index = ReadUntil(chars, index)
				return `ExtensionCommand`, full, index
			elseif prev == `\n` or prev == `*` or index == 1 then
				local full
				full, index = ReadUntil(chars, index)
				return `Command`, full, index
			else
				local full
				full, index = ReadUntil(chars, index)
				return `Base`, full, index
			end
		end
	end,
	Commands = {
		[`INIT`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`KILL`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`INC`] = {
			Aliases = {`INCREMENT`},
			Arguments = {},
			Style = `CommandColor`
		},
		[`DEC`] = {
			Aliases = {`DECREMENT`},
			Arguments = {},
			Style = `CommandColor`
		},
		[`SET`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`ALLOC`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`ALLOCARRAY`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`GOTO`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`CALL`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`CALLIF`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`RETURN`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`THREAD`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`PUSH`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`POP`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`PEEK`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`WAIT`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`WAITHEARTBEAT`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`WAITFOR`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`WAITFORCHANGE`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`SHUFFLE`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`GUID`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`LERP`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`CFR`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`CFRANGLES`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`CFRDEGREES`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`CFRINV`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`CFRCOPY`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`MOVETO`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`ANIMATE`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`ANIMATECUBIC`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`COPYTO`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`DELETE`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`DELETEALL`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`SPAWNBOT`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`INITSTATECOMP`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`SCRIPTHASH`] = {
			Arguments = {},
			Style = `CommandColor`
		},
	}
}