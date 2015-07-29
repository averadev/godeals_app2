
local RestManager = require('src.resources.RestManager')
local Globals = require('src.resources.Globals')

local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

local groupFilters = display.newGroup()
local btnModal, bgModal

local btnFilter = {}
local txtFilter = {}
local filterName = nil
local filterNameImg = nil
local typeF = ""

function CloseModal( event )
	btnModal:removeSelf()
	bgModal:removeSelf()
	groupFilters:removeSelf()
	groupFilters = nil
	groupFilters = display.newGroup()
	return true
end

function closeModalTouch( event )
	return true
end

function Showfilter( event )
	RestManager.getFilter(event.target.id,typeF)
	CloseModal()
	return true
end

function createFilters(filter)

	local totalFilter = 0
	local poscY = 0
	local poscX = 0
	local urlImage = ""
	local poscTitle = 0
	local numFilter = 0
	local idFilter = {}

	--botones para filtrar
	if filter == "EVENTOS" then
		totalFilter = 7
		urlImage = "img/btn/EVENTOS_iconos/"
		poscTitle = intH/5.7
		numFilter = 0
		idFilter = Globals.filterEvent
	else
		totalFilter = 9
		urlImage = "img/btn/DEALS_Iconos/"
		poscTitle = intH/5.7
		numFilter = 6
		idFilter = Globals.filterDeals
	end
	
		for y = 1, totalFilter, 1 do
		
			local flagFilter = 0
			
			for h = 1, #idFilter, 1 do
				
				if y ~= 1 then
				
					if (numFilter + y - 1) == tonumber(idFilter[h].idFilter) then
						flagFilter = 1
					end
				end
			end
			
			if filter == "EVENTOS" then
				--[[if y < 4 then
					poscX = 130 * y - 10
					poscY = intH / 2
				else
					poscX = (130 * (y - 3)) - 10
					poscY = intH/1.45
				end]]
				if y < 4 then
					poscX = 130 * y - 10
					poscY = intH / 3
				elseif y > 3 and y < 7 then
					poscX = (130 * (y - 3)) - 10
					poscY = intH/1.9
				else
					poscX = (130 * (y - 6)) - 10
					poscY = intH /1.4
				end
			else
				if y < 4 then
					poscX = 130 * y - 10
					poscY = intH / 3
				elseif y > 3 and y < 7 then
					poscX = (130 * (y - 3)) - 10
					poscY = intH/1.9
				else
					poscX = (130 * (y - 6)) - 10
					poscY = intH /1.4
				end
			end
			
			local filterTitle = display.newText( {
				text = filter,     
				x = intW/2 + 10, y = poscTitle,
				width = 350, height =40,
				font = "Lato-Regular",  fontSize = 40, align = "center"
			})
			filterTitle:setFillColor( 1 )
			groupFilters:insert(filterTitle)
			
			btnFilter[y] = display.newImage( urlImage ..  filterNameImg[y] ..".png" )
			btnFilter[y] :translate( poscX, poscY)
			btnFilter[y] .width = intH * .14
			btnFilter[y] .height = intH * .14
			btnFilter[y] .isVisible = true
			btnFilter[y].id = numFilter + y - 1
			btnFilter[y].name = filterNameImg[y]
			groupFilters:insert(btnFilter[y] )
			
			if flagFilter == 0 then
				if y ~= 1 then
					btnFilter[y].alpha = .1
				else
					btnFilter[y]:addEventListener( "tap", Showfilter )
				end
			else
				btnFilter[y]:addEventListener( "tap", Showfilter )
			end
			
			txtFilter[y]  = display.newText( {
				text = filterName[y],     
				x = poscX, y = poscY + (intH * .105),
				width = 130, height =40,
				font = "Lato-Regular",  fontSize = 14, align = "center"
			})
			txtFilter[y]:setFillColor( 0 )
			groupFilters:insert(txtFilter[y])
			
			if y == 4 and filter == "EVENTOS" then
				txtFilter[y].text = filterName[y] .. " / INAGURACIONES"
			end
		
		end

end

--- Modal Menu

 function Modal ( filter )
    
    bgModal = display.newRect( display.contentCenterX, display.contentCenterY, intW, intH )
    bgModal:setFillColor( 0 )
    bgModal.alpha = .5
    grupoModal:insert(bgModal)
	bgModal:addEventListener( "tap", CloseModal )
	bgModal:addEventListener( "touch", closeModalTouch )
 
	typeF = filter
 
	if filter == "EVENTOS" then
		filterNameImg = {"TODOS","CONCIERTOS","DEPORTIVOS","CULTURALES","ANIVERSARIOS","COMPRAS","OTROS"}
		filterName = {Globals.language.FilterNameEvent1,Globals.language.FilterNameEvent2,Globals.language.FilterNameEvent3,
		Globals.language.FilterNameEvent4,Globals.language.FilterNameEvent5,Globals.language.FilterNameEvent6,Globals.language.FilterNameEvent7}
		
		btnModal = display.newImage( "img/bgk/fondo_deals.png" )
		btnModal.width = 440
		--btnModal.height = 500
		btnModal.height = intH - intH / 4.2
		btnModal:translate( intW / 2 + 10, intH / 2)
	else
		filterNameImg = {"TODOS","RESTAURANTES","BARES","ANTROS","TURISMO","TECNOLOGIA","SERVICIOS","COMPRAS","OTROS"}
		filterName = {Globals.language.FilterNameDeals1,Globals.language.FilterNameDeals2,Globals.language.FilterNameDeals3,
		Globals.language.FilterNameDeals4,Globals.language.FilterNameDeals5,Globals.language.FilterNameDeals6,
		Globals.language.FilterNameDeals7,Globals.language.FilterNameDeals8,Globals.language.FilterNameDeals9}
		
		btnModal = display.newImage( "img/bgk/fondo_deals.png" )
		btnModal.width = 440
		--btnModal.height = 670
		btnModal.height = intH - intH / 4.2
		btnModal:translate( intW / 2 + 10, intH / 2)
	end
	
	btnModal.isVisible = true
	grupoModal:insert(btnModal)
	btnModal:addEventListener( "tap", closeModalTouch )
	btnModal:addEventListener( "touch", closeModalTouch )
	
	createFilters(filter)
	
	return true
end

function rectModal( event )
	return true
end