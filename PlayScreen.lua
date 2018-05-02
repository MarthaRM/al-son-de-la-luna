-----------------------------------------------------------------------------------------
--
-- PlayScreen.lua
-- 
-----------------------------------------------------------------------------------------
--[[PlayScreen = {}

function PlayScreen:new()
	local screen = {}
	function screen:initialize()
		--
		--https://docs.coronalabs.com/api/library/display/setStatusBar.html
		--
		display.setStatusBar(display.HiddenSttusBar)
		
		--
		-- https://docs.coronalabs.com/api/library/physics/index.html
		--
		local physics = require "physics"
		physics.start()

		local background = display.newImage("images/superficie.jpg")
			background.x = 150
			background.y = 160


		local planet1 = display.newImage("images/planet1.jpg")
			planet1.x = 100
			planet1.y = 80

		local planet2 = display.newImage("images/planet2.jpg")
			planet2.x = 400
			planet2.y = 100
		--[[planet1 = self.getElement("images/planet1.png")--, 100, 80)
		planet2 = self.getElement("images/planet2.png")--, 400, 100)

		--function planet1:enterFrame(event)
		--	if self.x < -480 then
		--		self.x = 480
		--	else
		--		self.x = self.x - 3
		--	end
		--end

	end

	function screen:getElement(image)
		local img = display.newImage(image)
		image.x = 100
		image.y = 80
		
	end

	function screen:show()
		
	end

	function screen:hide()
		
	end

	function screen:scrollPlanet(self, event)
		if self.x < -480 then
			self.x = 480
		else
			self.x = self.x - 3
		end
	end

	function screen:play()

		
		--Runtime:addEventListener("enterFrame", planet1)

		--planet1.enterFrame = screen:scrollPlanet
		--Runtime:addEventListener("enterFrame", planet1)

		--planet2.enterFrame = screen:scrollPlanet()
		--Runtime:addEventListener("enterFrame", planet2)
	end

	screen:initialize()
	--screen:play()
	return screen
end
]]--


	