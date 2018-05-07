-- https://docs.coronalabs.com/api/library/composer/index.html
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require ("widget")

-- https://docs.coronalabs.com/api/library/physics/index.html
local physics = require ("physics")
-- stage = tamaño pantalla
_G.stage = display.getCurrentStage()
physics.setDrawMode("normal")
physics.start() 
physics.setGravity(0, 40)
physics.setPositionIterations(10)
centerX = display.contentCenterX
centerY = display.contentCenterY
screenLeft = display.screenOriginX
screenWidth = display.contentWidth - screenLeft * 2
screenRight = screenLeft * screenWidth
screenTop = display.screenOriginY
screenHeight = display.contentHeight - screenTop * 2
screenBottom = screenTop + screenHeight 
display.contentWidht = screendWidth
display.contentHeight = screenHeight
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
 local speed = 2
 local timerUpTimer
 local currentTimeText = 0
 local counterStatus = true
 local triangleShape = { 0,-12, 12,30, -12,30 }
 local BotonReanudar
 local BotonMenu
 local temporaryspeed
 local BotonPausa
 local pauseStatus =false
 local playerStatus = false
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local function BotonesPausa(event)
	local phase = event.phase
	local id  = event.target.id
	if "ended" == phase then 

		if id == "Reanudar" then
			BotonReanudar:removeSelf()
			BotonMenu:removeSelf()
			speed = temporaryspeed
        	counterStatus = true
        	BotonPausa:setEnabled(true)
        	pauseStatus  = false
        	playerStatus=false
        	print("start reanudar ",playerStatus)
        	physics.start()
            --reanuda sprite jugador
            player:play()
            -- reanuda sprite alien
            alien:play()
		elseif id =="Menu" then
			BotonReanudar:removeSelf()
			BotonMenu:removeSelf()
			

       		playerStatus=false
			composer.gotoScene("menu",{effect="fade",time=500})



		end
	end
end

local function handleButtonEvent(event)
	local phase = event.phase
    local id = event.target.id
    if "ended" == phase then
        if id == "Pause" then
        	print("wtf")
        	--physics.addBody(player, "static", {density=0.65, bounce = 0.2})
        	BotonPausa:setEnabled(false)
        	temporaryspeed = speed
        	speed = 0
        	counterStatus = false
        	print("pause pausa",playerStatus)
        	physics.pause()
            --detiene sprite jugador
            player:pause()
            -- detiene sprite alien
            alien:pause()

            --player.x = player.x
            --player.y = player.y
            pauseStatus  = true
		     BotonReanudar = widget.newButton
		        {
		            left = stage.width/2 - 75,
      				top = stage.height/2 - 30,
		            width = 150,
		            height = 40,
		            defaultFile = "images/B.Rean.png",
		            overFile="images/B.ReanPressed.png",
		            id = "Reanudar",
		           	onEvent = BotonesPausa,
		        }
		     BotonMenu = widget.newButton
		     {
		            left = stage.width/2 - 75,
       				top = stage.height/2 + 30,
		            width = 150,
		            height = 40,
		            defaultFile = "images/B.Menu.png",
		            overFile="images/B.MenuPressed.png",
		            id = "Menu",
		            onEvent =BotonesPausa,
		 	 }

        end
    end
end



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

local function scrollElementPiso(self, event)
    self.speed=speed
    -- if self.x < (display.contentWidth/2)*(-1) then
    if self.x < self.width / 2 *(-1) - 50 then
        --self.x = display.contentWidth+self.width
        self.x = display.contentCenterX + self.width - 20
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
	local phase = event.phase
	print("pausestatus",pauseStatus)
	if pauseStatus  == false then
		print("playerstatus",playerStatus)
		if player.y >= 219 then
			print(event.phase)
			print(phase)
		    if phase == "began"  then
		        -- velocidad en x = 0
		        -- velocidad en y = 800
		       
		        player:setLinearVelocity(0,800)

		        player:applyLinearImpulse( nil, 800, player.x, player.y )
		        print("salta")
		    end
		    playerStatus = true
		   	

		end
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
                speed=0
                composer.gotoScene("gameOver",{effect="fade", time=500})
                
                --composer.removeScene( "play",true )
            else--if event.object2.type == "SUELO" then
            	
            	playerStatus = false
            	print(player.y)

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
    bg = display.newImage("images/FondoJuego.png")-- mostrar la imagen en pantalla
                    bg.x = centerX -- pos en x
                    bg.y = centerY -- pos en y
                    bg.width = screenWidth
                    bg.height = screenHeight
            bg.type = "bg"
    sceneGroup:insert(bg) --agrega el elemento a la escena


    -- PLANETS
    planet1 = display.newImage("images/1.png")
            planet1.x = 50
            planet1.y = 50
            planet1.speed = speed -- atributo de plantet1 que determina la velocidad con la que se movera en pantalla
            planet1.type = "bg"
    planet1.enterFrame = scrollElement
    sceneGroup:insert(planet1)

    planet2 = display.newImage("images/2.png")
            planet2.x = 250
            planet2.y = 110
            planet2.speed = speed
            planet2.type = "bg"
    planet2.enterFrame = scrollElement
    sceneGroup:insert(planet2)      

    planet3 = display.newImage("images/3.png")
            planet3.x = 350
            planet3.y = 125
            planet3.speed = speed
            planet3.type = "bg"
    planet3.enterFrame = scrollElement
    sceneGroup:insert(planet3)

    planet4 = display.newImage("images/4.png")
            planet4.x = 450
            planet4.y = 80
            planet4.speed = speed
            planet4.type = "bg"
    planet4.enterFrame = scrollElement
    sceneGroup:insert(planet4)

    planet5 = display.newImage("images/3.png")
            planet5.x = 650
            planet5.y = 50
            planet5.speed = speed
            planet5.type = "bg"
    planet5.enterFrame = scrollElement
    sceneGroup:insert(planet5)     

    planet6 = display.newImage("images/2.png")
            planet6.x = 800
            planet6.y = 100
            planet6.speed = speed
            planet6.type = "bg"
    planet6.enterFrame = scrollElement
    sceneGroup:insert(planet6)     

    planet7 = display.newImage("images/4.png")
            planet7.x = 850
            planet7.y = 140
            planet7.speed = speed
            planet7.type = "bg"
    planet7.enterFrame = scrollElement
    sceneGroup:insert(planet7) 

    planet8 = display.newImage("images/3.png")
            planet8.x = 700
            planet8.y = 135
            planet8.speed = speed
            planet8.type = "bg"
    planet8.enterFrame = scrollElement
    sceneGroup:insert(planet8) 

    -- ALIEN
    -- Sprite Alien
    sequenceData = 
    {
        name="alien",
        start=1,
        count=6,
    --    count=6,
        time=500,
        loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
        loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
    }
    local options = {
        --required parameters
        width = 59,
        height = 52,
        numFrames = 6
    }
    local alienSprite = graphics.newImageSheet( "images/alienSprite.png", options )
    
    alien = display.newSprite(alienSprite, sequenceData)     
            alien.x = 800
            alien.y = stage.height - alien.height/2 - 150
            alien.speed = 2.5
            alien.type = "obstacle"
    
    -- al ser "static" es posible que gire en la pantalla
    physics.addBody(alien, "static", {shape=triangleShape, density=3, bounce = 0})
    alien.enterFrame = scrollElement
    --Runtime:addEventListener("enterFrame", alien)
    sceneGroup:insert(alien)
    -- inicia el sprite
    alien:play()

    -- PIEDRA
    piedra = display.newImage("images/piedra.png")
            piedra.x = 900
            piedra.y = 100
            piedra.speed = 2.5
            piedra.type = "obstacle"
    piedra.enterFrame = scrollElement
    --Runtime:addEventListener("enterFrame", piedra)
    sceneGroup:insert(piedra)
    
    -- PLAYER
    sequenceData = 
    {
        name="player",
        start=1,
        count=4,
    --    count=6,
        time=500,
        loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
        loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
    }
    options = {
        --required parameters
        width = 81,
        height = 120.5,
        numFrames = 4
    }
    playerSprite = graphics.newImageSheet( "images/PlayerWalk.png", options )
    player = display.newSprite(playerSprite, sequenceData)   
            player.x = 50
            player.y = 180

    -- agrega elemento a physics
    physics.addBody(player, "dynamic", {density=0.95, bounce = 0.2})
    player.isFixedRotation = true -- PARA QUE NO BAILE EL PERSONAJE
    player.isSleepingAllowed = false -- PARA QUE NO SE "DUERMA"
    --Runtime:addEventListener("touch", touchAction)
    sceneGroup:insert(player)
    player:play()

    --  EN PROCESO----------------------------------------------
    player.collision = onCollision
    --Runtime:addEventListener("collision", player)
    -------------------------------------------------------
    -- FLOOR
    floor = display.newRect(stage.width/2, 0, stage.width*2, 0)
    floor.type = "SUELO"
    physics.addBody(floor, "static", {bounce = 0})
    floor.y = stage.height - 27

    -- "static" indica que sera un objeto sin movimiento
    piso1 = display.newImage("images/Piso.png")
    piso1.y = stage.height - 14
    piso1.x = display.contentCenterX
    sceneGroup:insert(piso1)
    piso1.enterFrame = scrollElementPiso
    piso1.speed = 2.5

    piso2 = display.newImage("images/Piso.png")
    piso2.y = stage.height - 14
    piso2.x = display.contentCenterX + piso2.width
    sceneGroup:insert(piso2)
    piso2.enterFrame = scrollElementPiso
    piso2.speed = 2.5

    sceneGroup:insert(piso1)
    sceneGroup:insert(piso2)


     BotonPausa = widget.newButton
        {
            left = 400,
            top = 20,
            width = 50,
            height = 50,
            defaultFile = "images/B.Pause.png",
            overFile="images/B.Pause.png",
            id = "Pause",
            onEvent = handleButtonEvent,
        }
    sceneGroup:insert(BotonPausa)

    currentTimeText = display.newText(contador, 20, 20, native.systemFontBold, 24) 
    currentTimeText:setTextColor(1,1,1)
    sceneGroup:insert(currentTimeText)
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        speed=2
        contador=0
        counterStatus = true

        alien.x = 500
            alien.y = stage.height - alien.height/2 - 27
            alien.speed = 2.5

        piedra.x = 900
            piedra.y = stage.height - piedra.height/2 - 27
            piedra.speed = 2.5

            player.x = 50
          	player.y = 180

         pauseStatus  = false
		 BotonPausa:setEnabled(true)


		 

        player:setLinearVelocity(0,800)
		currentTimeText.text="Puntaje: "..0
		playerStatus=false
		print("start will phase",playerStatus)
		physics.start()
 		 

    elseif ( phase == "did" ) then
        Runtime:addEventListener("enterFrame", planet1)
        Runtime:addEventListener("enterFrame", planet2)
        Runtime:addEventListener("enterFrame", planet3)
        Runtime:addEventListener("enterFrame", planet4)
        Runtime:addEventListener("enterFrame", planet5)
        Runtime:addEventListener("enterFrame", planet6)
        Runtime:addEventListener("enterFrame", alien)
        Runtime:addEventListener("enterFrame", piedra)
        Runtime:addEventListener("enterFrame", piso1)
        Runtime:addEventListener("enterFrame", piso2)
        Runtime:addEventListener("touch", touchAction)
        Runtime:addEventListener("collision", player)
        --pauseStatus  = false
      	playerStatus=false
      	print("start did phase ", playerStatus)
      	physics.start()


        


    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 		BotonPausa:setEnabled()
 		
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
    if speed<5 then
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