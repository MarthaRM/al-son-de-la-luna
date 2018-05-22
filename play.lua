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
 local bgAdorno
 local bgAdorno2
 local planet1
 local planet2
 local player
 local obstaculo
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
 local speedTemporal
 local BotonPausa
 local pauseStatus =false
 local playerStatus = false
 local playMusic
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
            -- reanuda sprite obstaculo
            obstaculo:play()
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
        	BotonPausa:setEnabled(false)
        	temporaryspeed = speed
        	speed = 0
        	counterStatus = false
        	print("pause pausa",playerStatus)
        	physics.pause()
            --detiene sprite jugador
            player:pause()
            -- detiene sprite obstaculo
            obstaculo:pause()
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
-- scrollElement()
-- 
-- Hace "girar" los obstaculos o enemigos del personaje
-- de forma aleatoria
-- 
-- ------------------------------------------------------
local function scrollObstacle(self, event)

    if self.x < (display.contentWidth-self.width)*(-1) then
        
        ------- AJUSTE DE NIVEL DEL OBSTACULO -------
        if speed<5 then
            self.speed=math.random(speed+1,speed+5)
        elseif speed<10 then
            self.speed=math.random(speed+2,speed+7)
        elseif speed<15 then
            self.speed=math.random(speed+3,speed+9)
        elseif speed<20 then
            self.speed=math.random(speed+4,speed+11)
        else
            self.speed=math.random(speed+5,speed+13)
        end
        ---------------------------------------------
        speedTemporal=self.speed
        self.x = display.contentWidth+self.width + math.random(5,20)
        -- nombres de secuencias
        local ops =
        {
          [1] = 'alien',
          [2] = 'gallina',
          [3] = "robot"
        }
        -- agrega una secuencia aleatoria
        self:setSequence(ops[math.random(1, 3)])
        -- inicia nueva secuecia
        self:play()
        self.y = stage.height - self.height/2 - 27
    else
        if pauseStatus==true then
            speedTemporal = self.speed
            self.speed=0
        else
            self.speed=speedTemporal
        end
        self.x = self.x - self.speed
        self.speed = speedTemporal
    end
end

-- ------------------------------------------------------
-- scrollElementPiso()
-- 
-- Hace "girar" el suelo del juego
-- ------------------------------------------------------
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

local function scrollElementBack(self, event)
    self.speed=speed
    -- if self.x < (display.contentWidth/2)*(-1) then
    if self.x < (self.width / 2 *(-1) - 50) then

        self.x = display.contentCenterX + self.width + 30

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

	--print("pausestatus",pauseStatus)

	if pauseStatus  == false then

		--print("playerstatus",playerStatus)
		if player.y >= 220 then

			--print(event.phase)
			--print(phase)

		    if phase == "began"  then
		        -- velocidad en x = 0
		        -- velocidad en y = 800
		       
		        player:setLinearVelocity(0,800)
		        player:applyLinearImpulse( nil, 850, player.x, player.y )
                if player.gravityScale < 1.48 then
                    player.gravityScale=(1+(speed/18))
                else
                    player.gravityScale=1.5
                end
		        print("salta")

                --cambia secuncia del jugador para que se detenga en un frame y aparente brincar
                player:setFrame(2)
                player:pause()
                playerStatus = true

		    end

		end
	end
end

-- ------------------------------------------------------
-- onCollision()
-- 
-- Detecta colisiones entre obstaculos y personaje
-- ------------------------------------------------------
local function onCollision(self, event)

    if event.phase == "began" then
        ---if event.object2.type == "obstacle" then
            if event.object2.type ~= "SUELO" then
                counterStatus=false
                speed=0
                physics.pause()
                composer.gotoScene("gameOver",{effect="fade", time=500})
                
                ------------------------------ GUARDAR PUNTAJE ----------------------------
                local path = system.pathForFile( "score.txt", system.DocumentsDirectory)
                local bestScore
                
                -- Open the file handle
                file = io.open( path, "a+" )

                for line in file:lines() do
                    if line~=nil then
                        bestScore=line
                    else
                        bestScore="0"
                        file:write("0")
                    end
                end
                print(bestScore)
                io.close(file)

                file = io.open(path,"w+")
                
                if tonumber(bestScore)<contador then
                    file:write(contador)
                else
                    file:write(bestScore)
                end
                -- Close the file handle
                io.close( file )
                file = nil

                -------------------------------------------------------------------------

            else--if event.object2.type == "SUELO" then
            	
            	playerStatus = false
            	--print(player.y)
                --cambia secuancia de jugador para que aparen caminar
                player:setSequence("walking")
                --incia sprite nuevamente, al cambiar de secuencia el sprite se detiene
                player:play()

            end
        --end
    end
end
-- ------------------------------------------------------
-- makeSprite()
--
-- Crea un nuevo sprite con una sola secuencia
-- ------------------------------------------------------
local function makeSprite(name, time, w, h, frames, file)
    local options = {
        width = w,
        height = h,
        numFrames = frames
    }

    
    sequenceData = 
    {
        name=name,
        start=1,
        count=frames,
    --    count=6,
        time=time,
        loopCount = 0,   -- Optional ; default is 0 (loop indefinitely)
        loopDirection = "forward"    -- Optional ; values include "forward" or "bounce"
    }
    
    local sprite =  graphics.newImageSheet( file, options )
    return display.newSprite(sprite, sequenceData) 
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

    bgAdorno = display.newImage("images/Background.png")-- mostrar la imagen en pantalla
    bgAdorno.x = display.contentCenterX -- pos en x
    bgAdorno.y = stage.height - 50 -- pos en y
    bgAdorno.speed = 2
    bgAdorno.type = "bg"
    bgAdorno.enterFrame = scrollElementPiso
    sceneGroup:insert(bgAdorno) --agrega el elemento a la escena

    bgAdorno2 = display.newImage("images/Background.png")-- mostrar la imagen en pantalla
            bgAdorno2.x = display.contentCenterX + bgAdorno2.width - 2 -- pos en x
            bgAdorno2.y = stage.height - 50 -- pos en y
            bgAdorno2.speed = 2
            bgAdorno2.type = "bg"
    bgAdorno2.enterFrame = scrollElementPiso
    sceneGroup:insert(bgAdorno2) --agrega el elemento a la escena

    bgAdorno3 = display.newImage("images/Misc.png")-- mostrar la imagen en pantalla
            bgAdorno3.x = display.contentCenterX + bgAdorno2.width -- pos en x
            bgAdorno3.y = stage.height - 50 -- pos en y
            bgAdorno3.speed = 2
            bgAdorno3.type = "bg"
    bgAdorno3.enterFrame = scrollElementBack
    sceneGroup:insert(bgAdorno3) --agrega el elemento a la escena

    bgAdorno4 = display.newImage("images/Misc.png")-- mostrar la imagen en pantalla
            bgAdorno4.x = display.contentCenterX + bgAdorno2.width -- pos en x
            bgAdorno4.y = stage.height - 50 -- pos en y
            bgAdorno4.speed = 2
            bgAdorno4.type = "bg"
    bgAdorno4.enterFrame = scrollElementBack
    sceneGroup:insert(bgAdorno4) --agrega el elemento a la escena
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

    -- OBSTACULOS
    -- Para los obstaculos, se crea una ImageSeet para cada sprite
    -- Despues se crea una variable SecuenceData que almacena los datos de cada ImageSheet de cada
    -- obstaculo para crear un sprite que contenga cada animacion y solo cambiar la imageSheet de forma aleatoria
    -- sin la necesidad de crear nuevos objetos
    
    -- AlienaImage Sheet
    local sheetData = { width=59, height=52, numFrames=6 }
    local alienSprite = graphics.newImageSheet( "images/alienSprite.png", sheetData )
     
    -- Gallina image sheet
    sheetData = { width=42, height=64, numFrames=3}
    local gallinaSprite = graphics.newImageSheet( "images/Gallina.png", sheetData )

    -- Robot image sheet
    sheetData = { width=62.5, height=112, numFrames=3}
    local robotSprite = graphics.newImageSheet( "images/robotSprite.png", sheetData )
     
    -- In your sequences, add the parameter 'sheet=', referencing which image sheet the sequence should use
    local sequenceData = {
        { name="alien", sheet=alienSprite, start=1, count=6, time=500, loopCount=0 , loopDirection = "forward"},
        { name="gallina", sheet=gallinaSprite, start=1, count=3, time=500, loopCount=0 , loopDirection = "forward"},
        { name="robot", sheet=robotSprite, start=1, count=3, time=500, loopCount=0 , loopDirection = "forward"}
    }
   
    obstaculo = display.newSprite(alienSprite, sequenceData)
            obstaculo.x = 800
            obstaculo.y = stage.height - obstaculo.height/2 - 150
            obstaculo.speed = 2.5
            obstaculo.type = "obstacle"
    
    -- al ser "static" es posible que gire en la pantalla
    physics.addBody(obstaculo, "static", {shape=triangleShape, density=3, bounce = 0})
    obstaculo.enterFrame = scrollObstacle
    sceneGroup:insert(obstaculo)
    -- inicia el sprite
    obstaculo:setSequence("alien")
    obstaculo:play()

    --[[ PIEDRA
    piedra = display.newImage("images/piedra.png")
            piedra.x = 900
            piedra.y = 100
            piedra.speed = 2.5
            piedra.type = "obstacle"
    piedra.enterFrame = scrollObstacle
    sceneGroup:insert(piedra)]]
    
    -- PLAYER
    player = makeSprite("player", 500, 81, 120.5, 4, "images/PlayerWalk.png")--sprite
            player.x = 50
            player.y = 180

    -- agrega elemento a physics
    physics.addBody(player, "dynamic", {density=0.95, bounce = 0.2})
    player.isFixedRotation = true -- PARA QUE NO BAILE EL PERSONAJE
    player.isSleepingAllowed = false -- PARA QUE NO SE "DUERMA"
    sceneGroup:insert(player)
    player:setSequence("walking")
    player:play()
    player.collision = onCollision
    player.type="player"

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

        obstaculo.x = 500
        obstaculo.y = stage.height - obstaculo.height/2 - 27
        obstaculo.speed = 2.5

        --[[piedra.x = 900
            piedra.y = stage.height - piedra.height/2 - 27
            piedra.speed = 2.5]]

        player.x = 50
        player.y = 180
        player.gravityScale=1

        pauseStatus  = false
		BotonPausa:setEnabled(true)
        speedTemporal=3

		 

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
        Runtime:addEventListener("enterFrame", obstaculo)
        Runtime:addEventListener("enterFrame", piso1)
        Runtime:addEventListener("enterFrame", piso2)
        Runtime:addEventListener("touch", touchAction)
        Runtime:addEventListener("collision", player)
        Runtime:addEventListener("enterFrame", bgAdorno)
        Runtime:addEventListener("enterFrame", bgAdorno2)
        Runtime:addEventListener("enterFrame", bgAdorno3)
        Runtime:addEventListener("enterFrame", bgAdorno4)
        --pauseStatus  = false
      	playerStatus=false
      	print("start did phase ", playerStatus)
      	physics.start()

        ----MUSICA---
        playMusic = audio.loadStream( "music/play.wav" )
        audio.play( playMusic, { channel=2, loops=-1, fadein=3200 })

    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 		BotonPausa:setEnabled()
        ----MUSICA----
        audio.fadeOut( { channel=2, time=1500 } )
        audio.stop(2)
        audio.rewind({channel=2})
 		
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
    if speed<25 and pauseStatus~=true then
        speed = speed*1.03
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