--groupSearchModal

local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

local btnModal, bgModal, svcurrent

function modalSeach()

	bgModal = display.newRect( display.contentCenterX, display.contentCenterY + h + 55, intW, intH )
    bgModal:setFillColor( 0)
    bgModal.alpha = .1
    groupSearchModal:insert(bgModal)
    
    btnModal = display.newRect( display.contentCenterX, display.contentCenterY + h + 120, intW, intH )
    btnModal:setFillColor( .1,.8,.4 )
    btnModal.alpha = 1
    groupSearchModal:insert(btnModal)
	--btnModal:addEventListener( "tap", CloseModal )
 
	--[[btnModal = display.newImage( "img/bgk/bgFilter.png" )
	btnModal:translate( intW / 2, intH - 370)
	btnModal.isVisible = true
	grupoModal:insert(btnModal)
	btnModal:addEventListener( "tap", CloseModal )
	
    svcurrent = scrViewMain
	scrViewMain:setIsLocked( true )]]
	
	return true
end