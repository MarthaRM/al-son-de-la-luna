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
 local etrellas
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
        defaultFile = ("images/B.Play.png"),
        overFile = ("images/B.PlayPressed.png"),
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
        defaultFile = ("images/B.Play.png"),
        overFile = ("images/B.PlayPressed.png"),
        onEvent = againButtonEvent,
    }
    sceneGroup:insert(main)
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