local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

function scene:createScene( event )
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )

	storyboard.removeScene( "src.Home" )
	storyboard.gotoScene( "src.Home" )
    
end

-- Remove Listener
function scene:exitScene( event )
    storyboard.removeScene( "src.HomeWhite" )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )
    
return scene


