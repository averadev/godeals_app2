
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

local btnCirCle = {}

local poscCurrent = 1

local groupTutorial = {}

local txtTutorial = {"img/bgk/TUTORIAL1.png", "img/bgk/TUTORIAL2.png", "img/bgk/TUTORIAL3.png","img/bgk/TUTORIAL4.png"}

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
	if poscCurrent ~= 4 then
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
	
	for y = 1, 4, 1 do
	
		groupTutorial[y] = display.newGroup()
		groupTutorial[y].alpha = 0
		self:insert(groupTutorial[y])
		
		local imgTutorial = display.newImage( txtTutorial[y] )
		imgTutorial:translate( intW/2, (intH/2 -intH/30.5) + h )
		--[[imgTutorial.height = intH / 1.16
		imgTutorial.width = intW]]
		
		if y == 3 then
			--imgTutorial.x= intW/2 - (intW * .0416)
		end
		
		groupTutorial[y]:insert( imgTutorial )
	end
	
	groupTutorial[1].alpha = 1
	
	self:insert(groupBtn)
	
	local btnNext = display.newRoundedRect( intW/2, intH/2 + intH/5.4, 380, 70, 11 )
	btnNext:addEventListener( "tap", changeScreen )
	btnNext:setFillColor( 1 )
	groupBtn:insert(btnNext)
	btnNext:toFront()
	
	local txtNext = display.newText({
		text = "CONTINUAR",
		x = intW/2, y = intH/2 + intH/5.4,
		width = 420,
		font = "Lato-Bold", fontSize = 30, align = "center"
	})
	txtNext:setFillColor( 145/255, 197/255, 115/255 )
	groupBtn:insert( txtNext )
		
	local btnHide = display.newRoundedRect( intW/2, intH/2 + intH/3.3, 380, 70, 11 )
	btnHide:setFillColor( 120/255, 163/255, 95/255 )
	btnHide:addEventListener( 'tap', closeTutorial )
	groupBtn:insert(btnHide)
	
	local txtHide = display.newText({
		text = "NO MOSTRAR",
		x = intW/2, y = intH/2 + intH/3.3,
		width = 420,
		font = "Lato-Bold", fontSize = 30, align = "center"
	})
	txtHide:setFillColor( 145/255, 197/255, 115/255 )
	groupBtn:insert( txtHide )
	
end