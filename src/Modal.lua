
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight


local btnModal, bgModal, svcurrent

function CloseModal( event )
	btnModal:removeSelf()
	bgModal:removeSelf()
	svcurrent:setIsLocked( false )
	return true
end

--- Modal Menu

function modalFunction( event )
	return true
end

 function Modal ( scrViewMain )
    
    bgModal = display.newRect( display.contentCenterX, display.contentCenterY, intW, intH )
    bgModal:setFillColor( 0)
    bgModal.alpha = .5
    grupoModal:insert(bgModal)
	bgModal:addEventListener( "tap", CloseModal )
 
	btnModal = display.newImage( "img/bgk/bgFilter.png" )
	btnModal:translate( intW / 2, intH - 370)
	btnModal.isVisible = true
	grupoModal:insert(btnModal)
	btnModal:addEventListener( "tap", CloseModal )
	
    svcurrent = scrViewMain
	scrViewMain:setIsLocked( true )
	
	return true
end

function rectModal( event )
	return true
end