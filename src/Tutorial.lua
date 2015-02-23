
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

local btnCirCle = {}

local poscCurrent = 1

local groupTutorial = {}

local txtTutorial = {"img/bgk/TUTORIAL1.png", "img/bgk/TUTORIAL2.png", "img/bgk/TUTORIAL3.png"}

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
	bgTutorial:addEventListener( "tap", lockScrenn )
	bgTutorial:addEventListener( "touch", lockScrenn )
	self:insert(bgTutorial)
	
	for y = 1, 3, 1 do
	
		groupTutorial[y] = display.newGroup()
		groupTutorial[y].alpha = 0
		self:insert(groupTutorial[y])
		
		local imgTutorial = display.newImage( txtTutorial[y] )
		if y == 2 then
		imgTutorial.x= intW/2 - 20
		else
		imgTutorial.x= intW/2
		end
		imgTutorial.y = intH/2 - 20
		imgTutorial.width = 500
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
	
	groupTutorial[1].alpha = 1
	
	self:insert(groupBtn)
	
	local btnNext = display.newRoundedRect( intW/2, intH/2 + intH/8.5, 400, 65, 11 )
	btnNext:addEventListener( "tap", changeScreen )
	btnNext:setFillColor( 1 )
	groupBtn:insert(btnNext)
	btnNext:toFront()
	
	local txtNext = display.newText({
		text = "CONTINUAR",
		x = intW/2, y = intH/2 + intH/8.5,
		width = 420,
		font = "Lato-Bold", fontSize = 30, align = "center"
	})
	txtNext:setFillColor( 145/255, 197/255, 115/255 )
	groupBtn:insert( txtNext )
		
	local btnHide = display.newRoundedRect( intW/2, intH/2 + intH/4.25, 400, 65, 11 )
	btnHide:setFillColor( 120/255, 163/255, 95/255 )
	btnHide:addEventListener( 'tap', closeTutorial )
	groupBtn:insert(btnHide)
	
	local txtHide = display.newText({
		text = "NO MOSTRAR",
		x = intW/2, y = intH/2 + intH/4.25,
		width = 420,
		font = "Lato-Bold", fontSize = 30, align = "center"
	})
	txtHide:setFillColor( 145/255, 197/255, 115/255 )
	groupBtn:insert( txtHide )
	
end