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
 local bestScore ---- MEJOR SCORE
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
    bg = display.newImage("images/Espacio.png")-- mostrar la imagen en pantalla
           bg.x = 230 -- pos en x
           bg.y = 160 -- pos en y
            
    sceneGroup:insert(bg) --agrega el elemento a la escena
            
    stars = display.newImage("images/Estrellas.png")-- mostrar la imagen en pantalla
           stars.x = 150 -- pos en x
           stars.y = 160 -- pos en y
    sceneGroup:insert(stars) --agrega el elemento a la escena

    again = widget.newButton
    {
        id = "again",
        left = stage.width/2 - 75,
        top = stage.height/2 - 40,
        width = 150,
        height = 40,
        defaultFile = ("images/B.Reint.png"),
        overFile = ("images/B.ReintPressed.png"),
        onEvent = againButtonEvent,
    }
    sceneGroup:insert(again)
    main = widget.newButton
    {
        id = "main",
        left = stage.width/2 - 75,
        top = stage.height/2 + 40,
        width = 150,
        height = 40,
        defaultFile = ("images/B.Menu.png"),
        overFile = ("images/B.MenuPressed.png"),
        onEvent = againButtonEvent,
    }
    sceneGroup:insert(main)



    ------------------------------ SCORE -------------------------------------

    ---------------------------- OBTENER PUNTAJE ----------------------------
    local path = system.pathForFile( "score.txt", system.DocumentsDirectory)

    -- Open the file handle
    local file, errorString = io.open(path, "r" )
            
    if not file then
    -- Error occurred; output the cause
        print( "File error: " .. errorString )
    else
        -- Output lines
        for line in file:lines() do
            if bestScore==nil then
                bestScore=line  
                print("GameOver"..line) 
            end
        end
        -- Close the file handle
        io.close( file )
    end
                 
    file = nil
    -------------------------------------------------------------------------

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
            for line in file:lines() do
                bestScore=line  
                print("GameOver"..line) 
            end
            -- Close the file handle
            io.close( file )
        end
                     
        file = nil
        print("ACTUALIZANDO ON SCREEN "..bestScore)
        textScore.text = "Mejor puntaje: "..bestScore

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