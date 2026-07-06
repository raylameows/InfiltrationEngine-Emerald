return {
	Instances = {
		{
			{`Property`, `Name`, `DynamicNode`},
			{`Check`, `IsA`, `BasePart`}
		},
		{
			{`Attribute`, `Type`, `AlarmedBehaviorOverride`},
			{`Property`, `ClassName`, `BoolValue`}
		},
		{
			{`Attribute`, `Type`, `ConversationResponseCustomBehavior`},
			{`Property`, `ClassName`, `BoolValue`}
		},
		{
			{`Attribute`, `Type`, `CustomBehaviorCondition`},
			{`Property`, `ClassName`, `BoolValue`}
		},
		{
			{`Attribute`, `Type`, `CustomBehaviorCondition`},
			{`Property`, `ClassName`, `BoolValue`}
		},
	},
	Tokens = {
		`String`,
		`Expr`,
		`Command`,
		`Whitespace`,
		`Newline`,
		`Number`,
		`Base`,
	},
	Rules = function(chars: {string}, ReadUntil: ({string}, number, {string}?, boolean?) -> (string, number))
		return function(index: number)
			local char = chars[index]
			local prev = chars[index - 1]
			local next = chars[index + 1]

			if char == `[` and next == `[` then
				local full
				full, index = ReadUntil(chars, index, {`]]`}, true)
				return `Expr`, full, index
			elseif char == `[` then
				local full
				full, index = ReadUntil(chars, index, {`]`}, true)
				return `String`, full, index
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
			elseif prev == `\n` or index == 1 then
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
		[`AUTOCLEANUP`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`CHAT`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`CHECKPOINT`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`CROSSARMS`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`END`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`ENTERCOMBAT`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`FOLLOW`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`GOTO`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`HEADTRACKING`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`ONCLEANUP`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`PHONE`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`RADIO`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`MOVETODYNAMIC`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`SETFASTWALK`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`SETRUNNING`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`SET`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`SETFACE`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`TAKEDOWNIMMUNE`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`WAIT`] = {
			Arguments = {},
			Style = `CommandColor`
		},
		[`WAITFOR`] = {
			Arguments = {},
			Style = `CommandColor`
		},
	}
}