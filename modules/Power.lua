local gu = require("GraphicsUtils.lua")

local function find(type)
	local found = {}
	for i,v in ipairs(peripheral.getNames()) do
		local p = peripheral.wrap(v)
		if p.listSources and p.listSources()[type] then
			table.insert(found, p)
		end
	end
	return unpack(found)
end

return @class:require("Module.lua")
	local function determineDisabled()
		if #({find("rf_provider")}) == 0 then
			self.disabled = true
		else
			self.disabled = false
		end
	end

	function (loadModule)
		self.name = "Power"
		determineDisabled()
	end

	function (update)
		determineDisabled()
	end

	function (drawInWindow:win)
		local energyCells = {find("rf_provider")}

		-- do all calculations before any drawing
		local bars = {}

		for i,v in ipairs(energyCells) do
			table.insert(bars, {name="RF Provider "..i,val=v.getEnergyStored("north")/v.getMaxEnergyStored("north")})
		end

		local w,h = win.getSize()
		local thin = #bars * 3 > h

		local fg, bg, tc = colors.yellow, colors.gray, colors.black
		local function toggleColors()
			if fg == colors.yellow then
				fg, bg, tc = colors.lightGray, colors.gray, colors.white
			else
				fg, bg, tc = colors.yellow, colors.gray, colors.black
			end
		end

		win.setBackgroundColor(colors.black)
		win.setCursorPos(1,1)
		win.clear()
		for i,v in ipairs(bars) do
			gu.drawBarInWindow(
				win,
				v.name,
				v.val,
				fg, bg, tc,
				thin
			)
			toggleColors()
		end
	end
end