local composer = require( "composer" )
 
local scene = composer.newScene()
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
 
 
 
 
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
-- function changeScenes(){
--
 --}
local function handleButtonEvent (event)
    local phase = event.phase
    local id = event.target.id
    if "ended" == phase then
        if id == "Jugar" then
            composer.gotoScene("play", {effect = "slideUp", time = 1000})
            print(id)
        else
            composer.gotoScene("credits", {effect = "slideLeft", time = 1000})
            print(id)
        end
    end
    
end
-- create()
function scene:create( event )


    local widget  = require ("widget")
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

    bg = display.newImage("images/MenuPrincipal.png")-- mostrar la imagen en pantalla
                    bg.x = centerX -- pos en x
                    bg.y = centerY -- pos en y
                    bg.width = screenWidth
                    bg.height = screenHeight
    sceneGroup:insert(bg)

    local BotonJugar = widget.newButton
        {
            left = 211,
            top = 111,
            width = 150,
            height = 40,
            defaultFile = "images/B.Play.png",
            overFile="images/B.PlayPressed.png",
            id = "Jugar",
            onEvent = handleButtonEvent,
        }
    sceneGroup:insert(BotonJugar)

        local BotonCred = widget.newButton
        {
            left = 211,
            top = 160,
            width = 150,
            height = 40,
            defaultFile = "images/B.Creditos.png",
            overFile="images/B.CreditosPressed.png",
            id= "Creditos",
            onEvent = handleButtonEvent,
        }
    sceneGroup:insert(BotonCred)

    --BotonJugar:addEventListener("tap",changeScenes)
    --BotonCred:addEventListener("tap",changeScenes)

 
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
