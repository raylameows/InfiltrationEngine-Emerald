local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local Create = require(`../UI/Create`)

local Version = require(`../Shared/Version`)
local Settings = require(`../Shared/Settings`)
local plugin = require(`../Core/Plugin`)()

local Interface = {}
Interface.__index = Interface

type self = {
	Screen: ScreenGui | DockWidgetPluginGui,
	Holder: ScrollingFrame,
	LinesDisplay: TextLabel,
	Text: TextLabel,
	Input: TextBox,
	Caret: Frame,
	LineHighlight: Frame,
	SuggestionFrame: ScrollingFrame
}
type Interface = setmetatable<self, typeof(Interface)>

function Interface.new(root: {[any]: any}): Interface
	local self = setmetatable({} :: self, Interface)
	self.Root = root
	
	local activated = not self.Root.Object:IsA(`BasePart`)
	--self.Screen = nil
	--if self.Root.Object:IsA(`BasePart`) then
	--	--self.Screen = plugin:CreateDockWidgetPluginGuiAsync(`EmeraldEditorDocument`,
	--	--	DockWidgetPluginGuiInfo.new(
	--	--		Enum.InitialDockState.Float,
	--	--		true,
	--	--		false,
	--	--		600,
	--	--		100,
	--	--		1,
	--	--		1
	--	--	)
	--	--)
	--	--self.Screen.Title = `{self.Root.Object.Name}`
	--else
	--	self.Screen = Create "ScreenGui" {
	--		Archivable = true,
	--		Name = `StateScriptEditor`,

	--		Parent = CoreGui
	--	}
	--end
	
	self.Screen = Create "ScreenGui" {
		Archivable = true,
		Name = `StateScriptEditor`,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

		Parent = CoreGui
	}
	
	
	-- This looks mid actually
	--self.Version = Create "TextLabel" {
	--	Size = UDim2.fromScale(1, 1),
	--	ZIndex = 999,

	--	BackgroundTransparency = 1,
	--	TextTransparency = 0.5,
		
	--	Text = Version.getCurrent(),
	--	TextSize = 17,
	--	TextColor3 = Version.isOutdated() and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255),
	--	FontFace = Font.fromEnum(Enum.Font.Code),
	--	TextXAlignment = Enum.TextXAlignment.Right,
	--	TextYAlignment = Enum.TextYAlignment.Bottom,
		
	--	Parent = self.Screen
	--}
	
	self.Toggle = Create "ImageButton" {
		AnchorPoint = Vector2.new(1, 1),
		Size = UDim2.fromOffset(50, 50),
		Position = UDim2.new(1, -20, 1, -20),
		BackgroundTransparency = 0,
		BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScriptBackground),
		ZIndex = 500,
		Rotation = activated and 0 or 180,
		
		Image = `rbxassetid://123669781013911`,
		
		Parent = self.Screen,
		Children = {
			Stroke = Create "UIStroke" {
				Color = Color3.new(1, 1, 1),
				Thickness = 2,
			}
		}
	}
	
	self.Warning = Create "ImageButton" {
		AnchorPoint = Vector2.new(1, 1),
		Size = UDim2.fromOffset(50, 50),
		Position = UDim2.new(1, -20, 1, -90),
		BackgroundTransparency = 0,
		BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScriptBackground),
		ZIndex = 500,
		ImageColor3 = Color3.fromRGB(255, 120, 120),
		Rotation = activated and 0 or 180,
		Visible = Version.isOutdated(),

		Image = `rbxassetid://105983344931670`,

		Parent = self.Screen,
		Children = {
			Stroke = Create "UIStroke" {
				Color = Color3.fromRGB(255, 120, 120),
				Thickness = 2,
			}
		}
	}
	
	self.Holder = Create "ScrollingFrame" {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,

		ScrollBarImageColor3 = Color3.fromRGB(53, 55, 65),
		BackgroundColor3 = Color3.fromRGB(39, 41, 48),
		MidImage = `rbxassetid://132155326`,
		BottomImage = `rbxassetid://132155326`,
		TopImage = `rbxassetid://132155326`,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		Visible = false,

		Parent = self.Screen,
		Children = {
			Ruler = Create "Frame" {
				Name = `Ruler`,
				Size = UDim2.new(0, 37, 1, 0),
				BackgroundColor3 = Color3.fromRGB(38, 41, 47),
				BorderSizePixel = 0,
				ZIndex = 25,
			},
			Dropper = Create "Frame" {
				Name = `Dropper`,
				Size = UDim2.new(0, 18, 1, 0),
				Position = UDim2.new(0, 37, 0, 0),
				BackgroundColor3 = Color3.fromRGB(42, 44, 51),
				BorderSizePixel = 0,
				ZIndex = 25,
			},
			Background = Create "Frame" {
				Name = `Background`,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 20,

				BackgroundColor3 = Settings:Get(`BackgroundColor`)
			}
		}
	}
	self.LinesDisplay = Create "TextLabel" {
		Size = UDim2.fromScale(1, 1),
		ZIndex = 50,

		BackgroundTransparency = 1,
		TextTransparency = 0,

		TextSize = 17,
		TextColor3 = Settings:Get(`TextColor`),
		FontFace = Font.fromEnum(Enum.Font.Code),
		TextXAlignment = Enum.TextXAlignment.Right,
		TextYAlignment = Enum.TextYAlignment.Top,

		Parent = self.Holder.Ruler,
		Children = {
			Create "UIPadding" {
				PaddingLeft = UDim.new(0, 8),
				PaddingRight = UDim.new(0, 8),
			}
		}
	}
	self.Text = Create "TextLabel" {
		Size = UDim2.new(1, -55, 1, 0),
		Position = UDim2.new(0, 55, 0, 0),
		ZIndex = 50,

		BackgroundTransparency = 1,
		TextTransparency = 0,

		TextSize = 17,
		TextColor3 = Settings:Get(`TextColor`),
		FontFace = Font.fromEnum(Enum.Font.Code),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		RichText = true,
		AutomaticSize = Enum.AutomaticSize.XY,

		Parent = self.Holder
	}
	self.Input = Create "TextBox" {
		Size = UDim2.new(1, -55, 1, 0),
		Position = UDim2.new(0, 55, 0, 0),
		ZIndex = 49,

		BackgroundTransparency = 1,
		TextTransparency = 0,
		TextColor3 = Settings:Get(`BackgroundColor`),

		Text = self.Root.Language == `StateScript` and root.Object:GetAttribute(`ScriptSource`) or self.Root.Object:GetAttribute(`CustomBehavior`),
		TextSize = 17,
		FontFace = Font.fromEnum(Enum.Font.Code),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		ClearTextOnFocus = false,
		MultiLine = true,
		AutomaticSize = Enum.AutomaticSize.Y,

		Parent = self.Holder
	}
	self.Caret = Create "Frame" {
		Size = UDim2.fromOffset(Settings:Get(`CaretWidth`), self.LineHeight),
		BorderSizePixel = 0,
		ZIndex = 75,

		Parent = self.Holder,
	}
	self.LineHighlight = Create "Frame" {
		Size = UDim2.new(1, 0, 0, self.LineHeight),
		BackgroundColor3 = Color3.fromRGB(45, 50, 65),
		BorderSizePixel = 0,
		ZIndex = 22,

		Parent = self.Holder,
	}
	self.SuggestionFrame = Create "ScrollingFrame" {
		Size = UDim2.fromOffset(300, 80),
		BackgroundColor3 = Color3.fromRGB(54, 54, 54),
		BorderSizePixel = 0,
		CanvasSize = UDim2.fromScale(0, 0),
		Visible = false,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ZIndex = 100,

		ScrollBarThickness = 5,
		ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
		MidImage = `rbxassetid://132155326`,
		BottomImage = `rbxassetid://132155326`,
		TopImage = `rbxassetid://132155326`,

		Parent = self.Holder,
		Children = {
			Layout = Create "UIGridLayout" {
				CellSize = UDim2.new(1, 0, 0, 15),
				CellPadding = UDim2.fromScale(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder
			}
		}
	}

	self.DefaultAbsolutePosition = self.Input.AbsolutePosition
	if not activated then
		self.Holder.Position = UDim2.fromScale(0, 1)
	end
	self.Holder.Visible = true
	
	local tinfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	self.Toggle.MouseButton1Down:Connect(function()
		if activated then
			activated = false
			TweenService:Create(self.Holder, tinfo, {Position = UDim2.fromScale(0, 1)}):Play()
			TweenService:Create(self.Toggle, tinfo, {Rotation = 180}):Play()
		else
			activated = true
			TweenService:Create(self.Holder, tinfo, {Position = UDim2.fromScale(0, 0)}):Play()
			TweenService:Create(self.Toggle, tinfo, {Rotation = 0}):Play()
		end
	end)
	
	local warningPopup
	self.Warning.MouseButton1Down:Connect(function()
		if warningPopup then
			--warningPopup:Destroy()
			--TweenService:Create(self.Toggle, tinfo, {Rotation = 180}):Play()
		else
			warningPopup = Create "CanvasGroup" {
				GroupTransparency = 1,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(47, 47, 47),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.3, 0.4),
				ZIndex = 5000,
				Parent = self.Screen,
				
				Children = {
					Header = Create "TextLabel" {
						Size = UDim2.fromScale(1, 0.2),
						Position = UDim2.fromScale(0, 0),
						ZIndex = 500000,

						BackgroundTransparency = 1,
						TextTransparency = 0,

						TextScaled = true,
						TextColor3 = Color3.fromRGB(255, 125, 125),
						FontFace = Font.fromEnum(Enum.Font.Code),
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Top,

						Text = `Outdated`
					},
					Description = Create "TextLabel" {
						Size = UDim2.fromScale(0.8, 0.8),
						AnchorPoint = Vector2.new(0.5, 0),
						Position = UDim2.fromScale(0.5, 0.2),
						ZIndex = 500000,

						BackgroundTransparency = 1,
						TextTransparency = 0,

						TextScaled = true,
						TextColor3 = Color3.fromRGB(255, 255, 255),
						FontFace = Font.fromEnum(Enum.Font.Code),
						TextXAlignment = Enum.TextXAlignment.Center,
						TextYAlignment = Enum.TextYAlignment.Top,

						Text = `Your version of Emerald ({Version.getCurrent()}) is outdated. Update to the newest version ({Version.getNewest()}) NOW!!!!!!!!`,
						
						Children = {
							Create "UITextSizeConstraint" {
								MaxTextSize = 25,
							}
						}
					},
					Stroke = Create "UIStroke" {
						Color = Color3.fromRGB(255, 125, 125),
						Transparency = 1,
						Thickness = 2,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					}
				}
			}
			local button: TextButton = Create "TextButton" {
				ZIndex = 500000,
				BorderSizePixel = 0,
				BackgroundColor3 = Color3.fromRGB(130, 131, 78),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.8),
				Size = UDim2.fromScale(0.7, 0.2),
				
				TextScaled = true,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				FontFace = Font.fromEnum(Enum.Font.Code),
				
				Text = `Understood`,
				
				Parent = warningPopup,
				Children = {
					TextSize = Create "UITextSizeConstraint" {
						MaxTextSize = 40,
					},
					Stroke = Create "UIStroke" {
						Color = Color3.fromRGB(255, 255, 255),
						Thickness = 2,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					}
				}
			}
			button.Activated:Once(function()
				TweenService:Create(warningPopup, tinfo, {GroupTransparency = 1}):Play()
				TweenService:Create(warningPopup.UIStroke, tinfo, {Transparency = 1}):Play()
				task.wait(tinfo.Time)
				warningPopup:Destroy()
				warningPopup = nil
			end)
			TweenService:Create(warningPopup, tinfo, {GroupTransparency = 0}):Play()
			TweenService:Create(warningPopup.UIStroke, tinfo, {Transparency = 0}):Play()
			TweenService:Create(self.Warning, tinfo, {Rotation = 360}):Play()
			task.delay(tinfo.Time, function()
				self.Warning.Rotation = 0
			end)
		end
	end)
	
	self.Input.CursorPosition = -1
	
	root.Maid:Add(self.Screen)
	return self
end

-- Why is this like 100 times better than the built-in AutomaticCanvasSize???
function Interface.UpdateCanvas(self: Interface)
	local totalHeight = self.Input.TextBounds.Y
	local totalWidth = self.Input.TextBounds.X
	if totalWidth > 0 then
		totalWidth += 56
	end
	
	self.Holder.CanvasSize = UDim2.fromOffset(totalWidth, totalHeight)
end

return Interface