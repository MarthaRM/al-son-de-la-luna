-- https://docs.coronalabs.com/api/library/composer/index.html
local composer = require( "composer" )
local scene = composer.newScene()

-- https://docs.coronalabs.com/api/library/physics/index.html
local physics = require ("physics")
-- stage = tamaño pantalla
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
 local floor
 local alien
 local contador = 0
 local speed = 1
 local timerUpTimer
 local currentTimeText = 0
 local counterStatus = true
 local triangleShape = { 0,-12, 15,30, -12,30 }
 local file
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- ------------------------------------------------------
-- scrollElement()
-- 
-- Hace "girar" en la pantalla los elementos del fondo
-- ------------------------------------------------------
local function scrollElement(self, event)
    self.speed=speed
    if self.x < (display.contentWidth-self.width)*(-1) then
        self.x = display.contentWidth+self.width
        --self.y = stage.height - alien.height/2 - math.random(5,20)
    else
        self.x = self.x - self.speed
    end
end

-- ------------------------------------------------------
-- touchAction()
--
-- Funcion a ejecutar cuando se toque al personaje
-- para hacerlo brincar
-- ------------------------------------------------------
local function touchAction( event )
    if event.phase == "began" then
        -- velocidad en x = 0
        -- velocidad en y = 800
        player:setLinearVelocity(0,800)

        player:applyLinearImpulse( nil, 800, player.x, player.y )
    end
end

-- ------------------------------------------------------
-- onCollision()
--
-- En proceso ...
-- ------------------------------------------------------
local function onCollision(self, event)

    if event.phase == "began" then
        ---if event.object2.type == "obstacle" then
            if event.object2.type ~= "SUELO" then
                counterStatus=false
            end
        --end
    end
end

-- ------------------------------------------------------
-- create()
-- Crea una nueva escena inicializando sus elementos
-- 
-- ------------------------------------------------------
function scene:create( event )
 
 -- esto es de composer pero la verdad no se que es :B
    local sceneGroup = self.view

    -- BACKGROUND
    bg = display.newImage("images/superficie.jpg")-- mostrar la imagen en pantalla
            bg.x = 150 -- pos en x
            bg.y = 160 -- pos en y
            bg.type = "bg"
    sceneGroup:insert(bg) --agrega el elemento a la escena

    -- PLANETS
    planet1 = display.newImage("images/planet1.png")
            planet1.x = 50
            planet1.y = 80
            planet1.speed = speed -- atributo de plantet1 que determina la velocidad con la que se movera en pantalla
            planet1.type = "bg"

    planet2 = display.newImage("images/planet2.png")
            planet2.x = 320
            planet2.y = 90
            planet2.speed = speed
            planet2.type = "bg"

    planet1.enterFrame = scrollElement -- evento
    Runtime:addEventListener("enterFrame", planet1)

    planet2.enterFrame = scrollElement
    Runtime:addEventListener("enterFrame", planet2)

    -- ALIEN
    alien = display.newImage("images/alien.png")
            alien.x = 500
            alien.y = stage.height - alien.height/2 - 10
            alien.speed = 2.5
            alien.type = "obstacle"
    
    -- al ser "static" es posible que gire en la pantalla
    physics.addBody(alien, "static", {shape=triangleShape, density=3, bounce = 0})
    alien.enterFrame = scrollElement
    Runtime:addEventListener("enterFrame", alien)
    sceneGroup:insert(alien)

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

    -- agrega elemento a physics
    physics.addBody(player, "dynamic", {density=0.65, bounce = 0.2})
    player.isFixedRotation = true -- PARA QUE NO BAILE EL PERSONAJE
    player.isSleepingAllowed = false -- PARA QUE NO SE "DUERMA"
    Runtime:addEventListener("touch", touchAction)

    --  EN PROCESO----------------------------------------------
    player.collision = onCollision
    Runtime:addEventListener("collision", player)
    -------------------------------------------------------
    -- FLOOR
    floor = display.newRect(stage.width/2, 0, stage.width*2, 0)
    floor.type = "SUELO"
    -- "statuc" indica que sera un objeto sin movimiento
    physics.addBody(floor, "static", {bounce = 0})
    floor.y = stage.height - 10

    currentTimeText = display.newText(contador, 400, 20, native.systemFontBold, 24) 
    currentTimeText:setTextColor(1,1,1)
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


-- Contador
local function timerUp()
    if speed<4 then
        speed = speed*1.04
    end
    if counterStatus == true then
        contador = contador + 1
        currentTimeText.text = "Puntaje: "..contador
    end
end

timerUpTimer = timer.performWithDelay(1000, timerUp, 0)
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene