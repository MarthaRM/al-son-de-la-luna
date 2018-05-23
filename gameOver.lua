local composer = require( "composer" )
local widget = require "widget"
local scene = composer.newScene()
 _G.stage = display.getCurrentStage()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
 local again
 local main
 local bg
 local etrellas --ETRELLAS? LOL
 local gameOverMusic 
 local bestScore="0" ---- MEJOR SCORE
 local textScore
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local function againButtonEvent (event)
    local phase = event.phase
    if "ended" == phase then
        if event.target.id == "main" then
            print ("main")
            composer.gotoScene("menu", {effect = "fade", time = 500})
        elseif event.target.id == "again" then
            print("again")
            composer.gotoScene("play", {effect = "fade", time = 500})
        end
    end
end


-- create()
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    bg = display.newImage("images/FondoJuego.png")-- mostrar la imagen en pantalla
        bg.x = centerX -- pos en x
        bg.y = centerY -- pos en y
        bg.width = screenWidth
        bg.height = screenHeight    
    sceneGroup:insert(bg) --agrega el elemento a la escena
      
    moon = display.newImageRect("images/Luna.png", 350, 350)
            moon.x = display.contentCenterX
            moon.y = display.contentCenterY + 80
    sceneGroup:insert(moon) 

    local mountain = display.newImage("images/Background.png")-- mostrar la imagen en pantalla
    mountain.x = display.contentCenterX -- pos en x
    mountain.y = stage.height - 50 -- pos en y
    sceneGroup:insert(mountain) --agrega el elemento a la escena

    local cactus = display.newImage("images/Misc.png")-- mostrar la imagen en pantalla
            cactus.x = display.contentCenterX - cactus.width/2-- pos en x
            cactus.y = stage.height - 80 -- pos en y
    sceneGroup:insert(cactus) --agrega el elemento a la escena

    local floor = display.newImage("images/Piso.png")
    floor.y = stage.height - 14
    floor.x = display.contentCenterX
    sceneGroup:insert(floor)

    local planet1 = display.newImage("images/1.png")
            planet1.x = 50
            planet1.y = 50
    planet1.enterFrame = scrollElement
    sceneGroup:insert(planet1)

    local planet2 = display.newImage("images/2.png")
            planet2.x = 250
            planet2.y = 110
    sceneGroup:insert(planet2)      

    local planet3 = display.newImage("images/3.png")
            planet3.x = 350
            planet3.y = 125
    sceneGroup:insert(planet3)

    local planet4 = display.newImage("images/4.png")
            planet4.x = 450
            planet4.y = 80
    sceneGroup:insert(planet4)

    local planet5 = display.newImage("images/3.png")
            planet5.x = 650
            planet5.y = 50
    sceneGroup:insert(planet5)     

    local planet6 = display.newImage("images/2.png")
            planet6.x = 800
            planet6.y = 100
    sceneGroup:insert(planet6)     

    local planet7 = display.newImage("images/4.png")
            planet7.x = 850
            planet7.y = 140
    sceneGroup:insert(planet7) 

    local planet8 = display.newImage("images/3.png")
            planet8.x = 700
            planet8.y = 135
    sceneGroup:insert(planet8) 


    local menuGameO = display.newImage("images/GameOver.png")-- mostrar la imagen en pantalla
    menuGameO.x = display.contentCenterX-- + menuPause.width - 2 -- pos en x
    menuGameO.y = display.contentCenterY-- + menuPause.width - 2 -- pos en y
    sceneGroup:insert(menuGameO) 

    again = widget.newButton
    {
        id = "again",
        left = display.contentCenterX - 65,
        top = stage.height/2 - 25,
        width = 130,
        height = 33,
        defaultFile = ("images/B.Reint.png"),
        overFile = ("images/B.ReintPressed.png"),
        onEvent = againButtonEvent,
    }
    sceneGroup:insert(again)
    main = widget.newButton
    {
        id = "main",
        left = display.contentCenterX - 65,
        top = stage.height/2 + 25,
        width = 130,
        height = 33,
        defaultFile = ("images/B.Menu.png"),
        overFile = ("images/B.MenuPressed.png"),
        onEvent = againButtonEvent,
    }
    sceneGroup:insert(main)



    ------------------------------ SCORE -------------------------------------

    --[[-------------------------- OBTENER PUNTAJE ----------------------------
    local path = system.pathForFile( "score.txt", system.DocumentsDirectory)

    -- Open the file handle
    file, errorString = io.open(path, "a" )
            
    if not file then
    -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
        -- Output lines
        bestScore=file:read("*n")
        if bestScore == nil then
            bestScore=0
        end
        print("_G.score Over ".._G.score.." bestScore "..bestScore)
        if bestScore<_G.score then
            bestScore=_G.score
        end
        -- Close the file handle
        io.close( file )
    end
                 
    file = nil

    file, errorString = io.open(path, "w" )
            
    if not file then
    -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
        file:write(bestScore)
        -- Close the file handle
        io.close( file )
        print("new bestScore "..bestScore)
    end
                 
    file = nil
    -------------------------------------------------------------------------
    --bestScore="1"]]

    textScore = display.newText("Mejor puntaje: "..bestScore, 60, 20, native.systemFontBold, 24) 
    textScore:setTextColor(1,1,1)
    sceneGroup:insert(textScore) 
    --------------------------------------------------------------------------
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        ---------------------------- OBTENER PUNTAJE ----------------------------
        local path = system.pathForFile( "score.txt", system.DocumentsDirectory)
     
        -- Open the file handle
        local file, errorString = io.open(path, "r" )
                
        if not file then
            -- Error occurred; output the cause
            print( "File error: " .. errorString )
        else
            -- Output lines
            bestScore=file:read("*n")
            print("MEJOR SCORE "..bestScore)
            if bestScore == nil then
                bestScore=0
                print("Fue nil")
            end
            if bestScore<_G.score then
                bestScore=_G.score
            end
            -- Close the file handle
            io.close( file )
        end
                     
        file = nil
        print("ACTUALIZANDO ON SCREEN "..bestScore)
        textScore.text = "Mejor puntaje: "..bestScore

        file, errorString = io.open(path, "w" )
            
        if not file then
        -- Error occurred; output the cause
            print( "File error: " .. errorString )
        else
            file:write(bestScore)
            -- Close the file handle
            io.close( file )
            print("new bestScore "..bestScore)
        end
                     
        file = nil

        -------------------------------------------------------------------------
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
        ----MUSICA---
        gameOverMusic = audio.loadStream( "music/gameover.wav" )
        audio.play( gameOverMusic, { channel=3, loops=-1, fadein=100 })
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
        ----MUSICA----
        audio.fadeOut( { channel=3, time=1500 } )
        audio.stop(3)
        audio.rewind({channel=3})
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene( "gameOver", true )
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