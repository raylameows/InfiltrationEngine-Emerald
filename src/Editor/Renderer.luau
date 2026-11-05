local FullSource = require(`./RendererModules/FullSource`)
local PerLine = require(`./RendererModules/PerLine`)
local Settings = require(`../Shared/Settings`)
local DebugPrint = require(`../Shared/DebugPrint`)

local RendererWrapper = {}
RendererWrapper.__index = RendererWrapper

type self = {[any]: any?}
type RendererWrapper = setmetatable<self, typeof(RendererWrapper)>

-- When & if deemed stable enough, switch fully to per-line
function RendererWrapper.new(root: {[any]: any}): RendererWrapper
	local useFullSource = Settings:Get(`UseFullSourceRendering`) == true
	DebugPrint(`Using {useFullSource and `Full Source` or `Per Line`} rendering`)
	
	local start = os.clock()
	local renderer = useFullSource and FullSource.new(root) or PerLine.new(root)
	DebugPrint(`Rendering took {os.clock() - start}s`)
	return renderer
end

return RendererWrapper