
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight
local DBManager = require('src.resources.DBManager')

local btnCirCle = {}

local poscCurrent = 1

local groupTutorial = {}

local txtTutorial = {"img/bgk/app_tutorial1.png", "img/bgk/app_tutorial2.png", "img/bgk/app_tutorial3.png",
                     "img/bgk/app_tutorial4.png", "img/bgk/app_tutorial5.png", "img/bgk/app_tutorial6.png"}
					 
local txtTutorial_en = {"img/bgk/app_tutorial1_en.png", "img/bgk/app_tutorial2_en.png", "img/bgk/app_tutorial3_en.png",
                     "img/bgk/app_tutorial4_en.png", "img/bgk/app_tutorial5_en.png", "img/bgk/app_tutorial6_en.png"}

local bgTutorial = nil

local groupBtn = display.newGroup()

--bloqueamos el touth
function lockScrenn( event )
	return true
end

function closeTutorial()
	for y = 1, #groupTutorial, 1 do
			groupTutorial[y]:removeSelf()
		end
		groupTutorial =nil
		groupTutorial = {}
		
		bgTutorial:removeSelf()
		bgTutorial = nil
		
		groupBtn:removeSelf()
		groupBtn = display.newGroup()
		
		poscCurrent = 1
end

--cambiamos a la siguiente grupo
function changeScreen( event )
	if poscCurrent ~= #txtTutorial then
		groupTutorial[poscCurrent].alpha = 0
		groupTutorial[poscCurrent + 1].alpha = 1
		poscCurrent = poscCurrent + 1
	else
		closeTutorial()
	end
	return true
end

--cambiamos cuando se aprete un boton circular
function changeScreenCircle( event )
	if event.target.id ~= poscCurrent then
		event.target:setFillColor( 0,150/255,0 )
		btnCirCle[poscCurrent]:setFillColor( 1 )
		groupTutorial[poscCurrent].alpha = 0
		groupTutorial[event.target.id].alpha = 1
		poscCurrent = event.target.id
	end
	return true
end

--creamos la pantalla del tutorial
function createTutorial(self)
	
	bgTutorial = display.newRect(  midW, midH, intW, intH)
    bgTutorial:setFillColor( 0 )
	bgTutorial.alpha = .7
	bgTutorial:addEventListener( "tap", lockScrenn )
	bgTutorial:addEventListener( "touch", lockScrenn )
	self:insert(bgTutorial)
	
	local imgH 
	
	for y = 1, #txtTutorial, 1 do
	
		groupTutorial[y] = display.newGroup()
		groupTutorial[y].alpha = 0
		self:insert(groupTutorial[y])
		
		local settings = DBManager.getSettings()
		
		local imgTutorial
		
		if settings.language == 'es' then
			imgTutorial = display.newImage( txtTutorial[y] )
		else
			imgTutorial = display.newImage( txtTutorial_en[y] )
		end
		
		imgTutorial.x = midW
		imgTutorial.y = midH
		imgH = imgTutorial.contentHeight
		
		groupTutorial[y]:insert( imgTutorial )
	end
	
	groupTutorial[1].alpha = 1
	
	self:insert(groupBtn)
	
	local btnNext = display.newRoundedRect( midW + 170, midH + 280, 100, 70, 11 )
	btnNext:addEventListener( "tap", changeScreen )
	btnNext:setFillColor( 1 )
    btnNext.alpha = .01
	groupBtn:insert(btnNext)
	btnNext:toFront()
	
end