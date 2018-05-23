local composer = require( "composer" )
local scene = composer.newScene()

 ------------------------ VARUABLES LOCALES ----------------------------------------

local bg --Background
local text
local touchArea
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
local function touchAction( event )

    local phase = event.phase

    if phase == "began"  then
        composer.gotoScene("menu", {effect = "slideRight", time = 1000})
    end
    return true
end

-- create()
function scene:create( event )

    local sceneGroup = self.view
    
    bg = display.newImage("images/Credits.png")-- mostrar la imagen en pantalla
    bg.x = centerX -- pos en x
    bg.y = centerY -- pos en y
    bg.width = screenWidth
    bg.height = screenHeight
    bg.type = "bg"
    sceneGroup:insert(bg) --agrega el elemento a la escena

    text = display.newText("Toca cualquier lugar para regresar", display.contentCenterX , screenHeight-20, native.systemFontBold, 24) 
    text:setTextColor(1,1,1)
    sceneGroup:insert(text) 
 
    transition.blink( text, { time=3000 } )
    touchArea = display.newRect( 0, 0, screenWidth*2, screenHeight*2 )
    touchArea:setFillColor(0,0,0)
    touchArea.alpha = 0.009
    sceneGroup:insert(touchArea) 
    touchArea:addEventListener( "touch", touchAction )
end
 
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on scr
 
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