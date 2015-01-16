
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

local modal, btnModal, bgModal

local svcurrent

function CloseModal( event )
	rect1Modal:removeSelf()
	rect2Modal:removeSelf()
	rect3Modal:removeSelf()
	rect4Modal:removeSelf()
	modal:removeSelf()
	bgModal:removeSelf()
	svcurrent:setIsLocked( false )
	return true
end

--- Modal Menu

function modalFunction( event )
	return true
end

 function Modal ( scrViewMain )
 
	bgModal = display.newRect(0,0,intW,intH)
	bgModal.anchorX = 0
	bgModal.anchorY = 0
	bgModal:setFillColor( 187, 219, 255, .1 )
	grupoModal:insert(bgModal)
	bgModal:addEventListener( "tap", CloseModal )
	
	modal = display.newRect(30, display.contentCenterY / 3,intW - 60,(intH / 2) * 1.5)
	modal.anchorX = 0
	modal.anchorY = 0
	modal:setFillColor( 0)
	grupoModal:insert(modal)
	modal:addEventListener( "tap", modalFunction )
	
	rect1Modal = display.newRect(50, display.contentCenterY / 3 + 30,modal.contentWidth /2 - 50,250)
	rect1Modal.anchorX = 0
	rect1Modal.anchorY = 0
	rect1Modal:setFillColor( .63,.85,.12)
	grupoModal:insert(rect1Modal)
	rect1Modal:addEventListener("tap", rectModal)
	
	rect2Modal = display.newRect(modal.contentWidth /2 + 60, display.contentCenterY / 3 + 30,modal.contentWidth /2 - 50,250)
	rect2Modal.anchorX = 0
	rect2Modal.anchorY = 0
	rect2Modal:setFillColor( .63,.85,.12)
	grupoModal:insert(rect2Modal)
	rect2Modal:addEventListener("tap", rectModal)
	
	rect3Modal = display.newRect(50, modal.contentHeight / 1.3, modal.contentWidth /2 - 50, 250)
	rect3Modal.anchorX = 0
	rect3Modal.anchorY = 0
	rect3Modal:setFillColor( .63,.85,.12)
	grupoModal:insert(rect3Modal)
	rect3Modal:addEventListener("tap", rectModal)
	
	rect4Modal = display.newRect(modal.contentWidth /2 + 60, modal.contentHeight / 1.3, modal.contentWidth /2 - 50, 250)
	rect4Modal.anchorX = 0
	rect4Modal.anchorY = 0
	rect4Modal:setFillColor( .63,.85,.12)
	grupoModal:insert(rect4Modal)
	rect4Modal:addEventListener("tap", rectModal)
	
	local halfW = display.contentWidth * 0.5
	local halfH = display.contentHeight * 0.5
	
	svcurrent = scrViewMain
	
	svcurrent:setIsLocked( true )
	
	return true
end

function rectModal( event )
	return true
end