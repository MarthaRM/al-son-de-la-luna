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
		if player.y >= 234 then
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
    --Runtime:addEventListener("enterFrame", planet1)
    sceneGroup:insert(planet1)
    planet2.enterFrame = scrollElement
    --Runtime:addEventListener("enterFrame", planet2)
    sceneGroup:insert(planet2)
    -- ALIEN
    alien = display.newImage("images/alien.png")
            alien.x = 500
            alien.y = stage.height - alien.height/2 - 10
            alien.speed = 2.5
            alien.type = "obstacle"
    
    -- al ser "static" es posible que gire en la pantalla
    physics.addBody(alien, "static", {shape=triangleShape, density=3, bounce = 0})
    alien.enterFrame = scrollElement
    --Runtime:addEventListener("enterFrame", alien)
    sceneGroup:insert(alien)

    -- PIEDRA
    piedra = display.newImage("images/piedra.png")
            piedra.x = 900
            piedra.y = stage.height - piedra.height/2 - 15
            piedra.speed = 2.5
            piedra.type = "obstacle"
    piedra.enterFrame = scrollElement
    --Runtime:addEventListener("enterFrame", piedra)
    sceneGroup:insert(piedra)
    -- PLAYER
    player = display.newImage("images/Personaje.png")
            player.x = 50
            player.y = 180

    -- agrega elemento a physics
    physics.addBody(player, "dynamic", {density=0.65, bounce = 0.2})
    player.isFixedRotation = true -- PARA QUE NO BAILE EL PERSONAJE
    player.isSleepingAllowed = false -- PARA QUE NO SE "DUERMA"
    --Runtime:addEventListener("touch", touchAction)
    sceneGroup:insert(player)

    --  EN PROCESO----------------------------------------------
    player.collision = onCollision
    --Runtime:addEventListener("collision", player)
    -------------------------------------------------------
    -- FLOOR
    floor = display.newRect(stage.width/2, 0, stage.width*2, 0)
    floor.type = "SUELO"
    -- "statuc" indica que sera un objeto sin movimiento
    physics.addBody(floor, "static", {bounce = 0})
    floor.y = stage.height - 10

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
            alien.y = stage.height - alien.height/2 - 10
            alien.speed = 2.5

        piedra.x = 900
            piedra.y = stage.height - piedra.height/2 - 15
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
        Runtime:addEventListener("enterFrame", alien)
        Runtime:addEventListener("enterFrame", piedra)
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