---------------------------------------------------------------------------------
-- Godeals App
-- Alfredo Chi
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- REQUIRE & VARIABLES
---------------------------------------------------------------------------------

require('src.Menu')
require('src.Header')
require('src.BuildRow')
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local RestManager = require('src.resources.RestManager')
local DBManager = require('src.resources.DBManager')
local widget = require( "widget" )
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY
local h = display.topStatusBarContentHeight

local homeScreen = display.newGroup()
local settings, allItems, txtSearchP, listPartner, hWPL

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

function setPartnerList(items)
	allItems = items
    buildPartnerList(items)
end


function onSearchTP(event)
    native.setKeyboardFocus(nil)
    doSearchP(txtSearchP.text)
    return true
end

function onSearchP(event)
    if ( "submitted" == event.phase ) then
        doSearchP(event.target.text)
    end
end

function doSearchP(txtS)
    native.setKeyboardFocus(nil)
    txtS = string.lower(txtS)
    
    if txtS == "" then
        buildPartnerList(allItems)
    else
        local newItems = {}
        for y = 1, #allItems, 1 do 
            print(allItems[y].name)
            print(string.find(allItems[y].name, txtS))
            if string.find(string.lower(allItems[y].name), txtS) ~= nil or 
                string.find(string.lower(allItems[y].info), txtS) ~= nil then
                table.insert(newItems, allItems[y])
            end
        end
        buildPartnerList(newItems)
    end
    
end

function buildPartnerList(items)
    print("buildPartnerList")
    if listPartner then
        listPartner:removeSelf()
        listPartner = nil
    end
    listPartner = display.newGroup()
    svContent:insert(listPartner)
    
	local yMain = 0
    for y = 1, #items, 1 do 
        -- Create container
        local partner = Partner:new()
        listPartner:insert(partner)
        partner:build(items[y])
        partner.y = yMain
        yMain = yMain + 100
    end
	svContent:setScrollHeight(yMain)
end

function txtPHide()
    txtSearchP.y = -100
end

--obtenemos el homeScreen de la escena
function getScreenPL()
	return homeScreen
end

function scene:createScene( event )

	screen = self.view
	screen:insert(homeScreen)
	
	local bg = display.newRect( 0, h, display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 1 )
	homeScreen:insert(bg)
	
	-- Build Component Header
	local header = Header:new()
    homeScreen:insert(header)
    header.y = h
    header:buildToolbar()
    header:buildNavBar("Mi Bandeja")
    hWPL = 5 + header:buildWifiBle()
    
    local bgBtnS = display.newRect( 440,  h + 160 + hWPL, 60, 40 )
	bgBtnS:setFillColor( 1 )
    bgBtnS:addEventListener( "tap", onSearchTP )
	homeScreen:insert(bgBtnS)
    
    local bgSearchPartner = display.newImage( "img/bgk/bgSearchPartner.png" )
    bgSearchPartner:translate( 240,  h + 160 + hWPL )
    homeScreen:insert(bgSearchPartner)
    
    txtSearchP = native.newTextField( 225, h + 160 + hWPL, 350, 40 )
    txtSearchP.hasBackground = false
    txtSearchP:addEventListener( "userInput", onSearchP )
	homeScreen:insert(txtSearchP)
	
    svContent = widget.newScrollView
	{
		top = h + 190 + hWPL,
		left = 0,
		width = intW,
		height = intH - (h + 190 + hWPL),
		horizontalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	homeScreen:insert(svContent)
    
	RestManager.getPartnerList()
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    txtSearchP.y =  h + 160 + hWPL
	Globals.scene[#Globals.scene + 1] = storyboard.getCurrentSceneName()
end

-- Remove Listener
function scene:exitScene( event )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene