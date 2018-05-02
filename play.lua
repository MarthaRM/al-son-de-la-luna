local composer = require( "composer" )
 
local scene = composer.newScene()

local physics = require ("physics")
_G.stage = display.getCurrentStage()
physics.setDrawMode("normal")
physics.start() 
physics.setGravity(0, 40)
physics.setPositionIterations(10)


-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 local bg
 local planet1
 local planet2
 local player

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
 
-- create()

local function scrollElement(self, event)
    if self.x < (display.contentWidth-self.width)*(-1) then
        self.x = display.contentWidth+self.width
        --self.y = stage.height - alien.height/2 - math.random(5,20)
    else
        self.x = self.x - self.speed
    end
end


local function touchAction( event )
    if event.phase == "began" then
        player:setLinearVelocity(0,800)
        player:applyLinearImpulse( nil, 800, player.x, player.y )
    end
end

local function onCollision(self, event)
    if event.phase == "began" then
        if self.type == "obstacle" then
            print("collision")
        end
    end
end


function scene:create( event )
 
    local sceneGroup = self.view

    -- BACKGROUND
    bg = display.newImage("images/superficie.jpg")
            bg.x = 150
            bg.y = 160
            bg.type = "bg"
    sceneGroup:insert(bg)

    -- PLANETS
    planet1 = display.newImage("images/planet1.png")
            planet1.x = 50
            planet1.y = 80
            planet1.speed = 1/2
            planet1.type = "bg"
    planet2 = display.newImage("images/planet2.png")
            planet2.x = 320
            planet2.y = 90
            planet2.speed = 1/2
            planet2.type = "bg"
    planet1.enterFrame = scrollElement
    Runtime:addEventListener("enterFrame", planet1)

    planet2.enterFrame = scrollElement
    Runtime:addEventListener("enterFrame", planet2)

    -- ALIEN
    alien = display.newImage("images/alien.png")
            alien.x = 500
            alien.y = stage.height - alien.height/2 - 10
            alien.speed = 2.5
            alien.type = "obstacle"

    --physics.addBody(alien, "dynamic", {density=3, bounce = 0})
    alien.enterFrame = scrollElement
    Runtime:addEventListener("enterFrame", alien)

    -- PIEDRA
    piedra = display.newImage("images/piedra.png")
            piedra.x = 900
            piedra.y = stage.height - piedra.height/2 - 15
            piedra.speed = 2.5
            piedra.type = "obstacle"
    piedra.enterFrame = scrollElement
    Runtime:addEventListener("enterFrame", piedra)

    -- PLAYER
    player = display.newImage("images/Personaje.png")
            player.x = 50
            player.y = 180

    physics.addBody(player, "dynamic", {density=3, bounce = 0})
    --physics.addBody(alien, "dynamic", {density=3, bounce = 0})
    --alien:setLinearVelocity(-200)
    Runtime:addEventListener("touch", touchAction)

    --  EN PROCESO----------------------------------------------
    --alien.collision = onCollision
    --Runtime:addEventListener("collision", alien)
    -------------------------------------------------------
    -- FLOOR
    local floor = display.newRect(stage.width/2, 0, stage.width*2, 0)
    floor.type = "ground"
    physics.addBody(floor, "static")
    floor.y = stage.height - 10

        
    


----------------------------------------------------------
------------------------ ELEMENTS ------------------------
    --[[-planet1 = display.newImage("images/planet1.png")
            planet1.x = 50
            planet1.y = 80
            planet1.speed = 1/2

    planet2 = display.newImage("images/planet2.png")
            planet2.x = 320
            planet2.y = 90
            planet2.speed = 1/2
    
    planet1.enterFrame = scrollElement
    Runtime:addEventListener("enterFrame", planet1)

    planet2.enterFrame = scrollElement
    Runtime:addEventListener("enterFrame", planet2)


    alien = display.newImage("images/alien.png")
            alien.x = 150
            alien.y = 230
            alien.speed = 2

    piedra = display.newImage("images/piedra.png")
            piedra.x = 550
            piedra.y = 220
            piedra.speed = 2

    alien.enterFrame = scrollElement
    Runtime:addEventListener("enterFrame", alien)

    piedra.enterFrame = scrollElement
    Runtime:addEventListener("enterFrame", piedra)
----------------------------------------------------------
----------------------------------------------------------

----------------------------------------------------------
------------------------ PLAYER --------------------------
    player = display.newImage("images/Personaje.png")
            player.x = 50
            player.y = 180

    player.jumpObstacle = jump
    Runtime:addEventListener("jumpObstacle", player)]]
----------------------------------------------------------
----------------------------------------------------------


    -- Code here runs when the scene is first created but has not yet appeared on screen
 
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
 
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene