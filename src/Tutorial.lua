
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

local btnCirCle = {}

local poscCurrent = 1

local groupTutorial = {}

local txtTutorial = {"img/bgk/TUTORIAL1.png", "img/bgk/TUTORIAL2.png", "img/bgk/TUTORIAL3.png"}

local bgTutorial = nil

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
		poscCurrent = 1
end

--cambiamos a la siguiente grupo
function changeScreen( event )
	if poscCurrent ~= 3 then
		--[[btnCirCle[poscCurrent]:setFillColor( 1 )
		btnCirCle[poscCurrent + 1]:setFillColor( 0,150/255,0 )]]
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
	
	bgTutorial = display.newRect(  intW/2, intH/2 + h, intW, intH)
    bgTutorial:setFillColor( 0 )
	bgTutorial.alpha = .3
	bgTutorial:addEventListener( "tap", changeScreen )
	bgTutorial:addEventListener( "touch", lockScrenn )
	self:insert(bgTutorial)
	
	for y = 1, 3, 1 do
	
		groupTutorial[y] = display.newGroup()
		groupTutorial[y].alpha = 0
		self:insert(groupTutorial[y])
		
		local imgTutorial = display.newImage( txtTutorial[y] )
		imgTutorial.x= intW/2
		imgTutorial.y = intH/2 - 20
		imgTutorial.width = 480
		groupTutorial[y]:insert( imgTutorial )
		
		--distancia entre circulos
		--local poscCircle = (intW * .16) * y
		--posicion
		--[[poscCircle = poscCircle + (intW * .1875)
		btnCirCle[y] = display.newCircle( poscCircle, intH - (intH/10), 10 )
		btnCirCle[y].id = y
		btnCirCle[y].status = 0
		btnCirCle[y]:addEventListener( "tap", changeScreenCircle )
		btnCirCle[y]:addEventListener( "touch", lockScrenn )
		self:insert(btnCirCle[y])]]
	end
	
	--[[btnCirCle[1]:setFillColor( 0,150/255,0 )
	btnCirCle[1].status = 1
	poscCurrent = 1]]
	
	
	
	--[[local imgTutorial2 = display.newImage( "img/btn/logo.png" )
    imgTutorial2.x= intW/2
    imgTutorial2.y = intH/2
    groupTutorial[2]:insert( imgTutorial2 )
	
	local imgTutorial3 = display.newImage( "img/btn/agotadoMax.png" )
    imgTutorial3.x= intW/2
    imgTutorial3.y = intH/2
    groupTutorial[3]:insert( imgTutorial3 )]]
	
	groupTutorial[1].alpha = 1
	
	
	
end