local CoreGui = game:GetService("CoreGui")

local Settings = require(`../Shared/Settings`)
local Create = require(`../UI/Create`)
local plugin = require(`../Core/Plugin`)()

local Encoder = require(`../Settings/Encoder`)
local Decoder = require(`../Settings/Decoder`)

local Interface = {}
Interface.__index = Interface

type self = {
	Widget: DockWidgetPluginGui,
	Holder: ScrollingFrame
}
type Interface = setmetatable<self, typeof(Interface)>

function Interface.new(root: {[any]: any}): Interface
	local self = setmetatable({} :: self, Interface)
	self.Root = root
	
	self.Widget = plugin:CreateDockWidgetPluginGuiAsync(`EmeraldSettings`, 
		DockWidgetPluginGuiInfo.new(
			Enum.InitialDockState.Float,
			false,
			false,
			500,
			500,
			1,
			1
		)
	)
	self.Widget.Title = `Emerald Settings`
	
	self.Holder = Create "ScrollingFrame" {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,

		ScrollBarImageColor3 = Color3.fromRGB(53, 55, 65),
		BackgroundColor3 = Color3.fromRGB(39, 41, 48),
		MidImage = `rbxassetid://132155326`,
		BottomImage = `rbxassetid://132155326`,
		TopImage = `rbxassetid://132155326`,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,

		Parent = self.Widget,
		Children = {
			Grid = Create "UIListLayout" {
				Padding = UDim.new(),
				SortOrder = Enum.SortOrder.LayoutOrder
			}
		}
	}
	
	self:Load()
	return self
end

function Interface.Load(self: Interface)
	for _, frame in (self.Holder:QueryDescendants(`>Frame`)) do
		frame:Destroy()
	end

	for settingName, setting in (Settings:List()) do
		self:AddButton(settingName, setting)
	end
end

function Interface.AddButton(self: Interface, settingName: string, setting: {Value: any, Default: any, Display: boolean, Index: number})
	local frame = Create "Frame" {
		BackgroundTransparency = 1,
		LayoutOrder = setting.Index,
		Size = UDim2.new(1, 0, 0, 23),
		
		Parent = self.Holder,
		Children = {
			Display = Create "TextLabel" {
				Text = setting.Display,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.fromScale(1, 1),
				FontFace = Font.fromEnum(Enum.Font.Code),
				TextScaled = true,
				BackgroundTransparency = 1,
				TextColor3 = Color3.new(1, 1, 1),
				
				Children = {
					TextSize = Create "UITextSizeConstraint" {
						MaxTextSize = 20,
					}
				}
			},
		}
	}
	local reset = Create "TextButton" {
		Text = `R`,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.new(0, 30, 1, 0),
		FontFace = Font.fromEnum(Enum.Font.Code),
		TextScaled = true,
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		
		Parent = frame,
		Children = {
			TextSize = Create "UITextSizeConstraint" {
				MaxTextSize = 20,
			}
		}
	}
	
	local settingType = typeof(setting.Default)
	local encodedValue = Encoder[settingType](setting.Value)
	if settingType == `boolean` then
		local button: TextButton = Create "TextButton" {
			Text = setting.Value and `Enabled` or `Disabled`,
			Size = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -reset.Size.X.Offset, 0, 0),
			TextColor3 = setting.Value and Color3.fromRGB(85, 255, 127) or Color3.fromRGB(255, 108, 108),
			TextScaled = true,
			FontFace = Font.fromEnum(Enum.Font.Code),
			TextXAlignment = Enum.TextXAlignment.Right,
			BackgroundTransparency = 1,
			
			Parent = frame,
			Children = {
				TextSize = Create "UITextSizeConstraint" {
					MaxTextSize = 20,
				}
			}
		}
		
		button.MouseButton1Down:Connect(function()
			local newValue = not setting.Value
			Settings:Set(settingName, newValue)
			button.Text = setting.Value and `Enabled` or `Disabled`
			button.TextColor3 = setting.Value and Color3.fromRGB(85, 255, 127) or Color3.fromRGB(255, 108, 108)
		end)

		reset.MouseButton1Down:Connect(function()
			Settings:Set(settingName, setting.Default)
			button.Text = setting.Value and `Enabled` or `Disabled`
			button.TextColor3 = setting.Value and Color3.fromRGB(85, 255, 127) or Color3.fromRGB(255, 108, 108)
		end)
	else
		local input: TextBox = Create "TextBox" {
			Text = encodedValue,
			Size = UDim2.new(0.5, 0, 1, 0),
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -reset.Size.X.Offset, 0, 0),
			TextColor3 = settingType == `Color3` and setting.Value or Color3.new(1, 1, 1),
			TextScaled = true,
			FontFace = Font.fromEnum(Enum.Font.Code),
			TextXAlignment = Enum.TextXAlignment.Right,
			BackgroundTransparency = 1,
			TextStrokeColor3 = Color3.new(1, 1, 1),
			TextStrokeTransparency = 1,
			ClearTextOnFocus = false,

			Parent = frame,
			Children = {
				TextSize = Create "UITextSizeConstraint" {
					MaxTextSize = 20,
				},
			}
		}
		
		local function UpdateStroke()
			if settingType == `Color3` then
				input.TextColor3 = setting.Value
				local tolerance = 50 / 255
				local isDarkColor = setting.Value.R <= tolerance or setting.Value.G <= tolerance or setting.Value.B <= tolerance
				input.TextStrokeTransparency = isDarkColor and 0.5 or 1
			end
		end
		UpdateStroke()
		
		input.FocusLost:Connect(function()
			local inputValue = input.Text
			local decodeSuccess, decodeResponse = pcall(function()
				return Decoder[settingType](inputValue)
			end)
			
			if not decodeSuccess or decodeResponse == nil then
				warn(decodeResponse or `Decoding returned nil`)
			else
				local encodeSuccess, encodeResponse = pcall(function()
					return Encoder[settingType](decodeResponse)
				end)
				
				if not encodeSuccess or encodeSuccess == nil then
					warn(encodeResponse or `Encoding returned nil`)
				else
					encodedValue = encodeResponse
					Settings:Set(settingName, decodeResponse)
				end
			end
			
			input.Text = encodedValue
			UpdateStroke()
		end)

		reset.MouseButton1Down:Connect(function()
			Settings:Set(settingName, setting.Default)
			encodedValue = Encoder[settingType](setting.Value)
			input.Text = encodedValue
			UpdateStroke()
		end)
	end
	
	return frame
end

return Interface