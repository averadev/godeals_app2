--groupSearchModal

require('src.BuildRow')
local RestManager = require('src.resources.RestManager')
local widget = require( "widget" )
local Globals = require('src.resources.Globals')


local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight
local yMain = 0
local texto = ""
local callbackCurrent = 0

local btnModal, bgModal

local scrViewSearch

local elements = {}
local imageItems = {}

GroupSearch = display.newGroup()

function setSearchElements(items)
	elements = items
end

function hideModalSearch( event )

	--hideSearch2()
	deleteTxt()

	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	local pSearch = #Globals.searchText + 1
	Globals.searchText[pSearch] = texto
	
	btnModal:removeSelf()
	scrViewSearch:removeSelf()
	btnModal = nil
	scrViewSearch = nil
	
	
end

function loadSearchImage(obj)

	local path = system.pathForFile( elements[obj.posc].image, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
		if callbackCurrent == Globals.noCallbackGlobal then
			imageItems[obj.posc] = display.newImage( elements[obj.posc].image, system.TemporaryDirectory )
			imageItems[obj.posc].alpha = 0
			if obj.posc < #elements then
				obj.posc = obj.posc + 1
				loadSearchImage(obj)
			else
				buildSearchItems(obj.screen)
			end
		end
    else
        -- Listener de la carga de la imagen del servidor
        local function loadImageListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
                event.target.alpha = 0
				if callbackCurrent == Globals.noCallbackGlobal then
					imageItems[obj.posc] = event.target
					if obj.posc < #elements then
						obj.posc = obj.posc + 1
						loadSearchImage(obj)
					else
						buildSearchItems(obj.screen)
					end
				end
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url..obj.path..elements[obj.posc].image, 
        "GET", loadImageListener, elements[obj.posc].image, system.TemporaryDirectory ) 
    end
	
end

function buildSearchItems(screen)
	
	if screen == "event" then
	
	yMain = yMain + 30
	
		local separadorEventos = display.newImage( "img/btn/btnArrowGreen.png" )
        separadorEventos:translate( 41, yMain)
        separadorEventos.isVisible = true
        scrViewSearch:insert(separadorEventos)

        local textSeparadorEventos = display.newText( {
            text = "Eventos y actividades.",     
            x = 300, y = yMain + 30, width = intW, height = 80,
            font = "Lato-Regular", fontSize = 19, align = "left"
        })
        textSeparadorEventos:setFillColor( 85/255, 85/255, 85/255 )
        scrViewSearch:insert(textSeparadorEventos)
	
		yMain = yMain + 30
        for y = 1, #elements, 1 do 
            -- Create container
			
			local evento = Event:new()
            scrViewSearch:insert(evento)
            evento:build(true,elements[y], imageItems[y])
            evento.y = yMain
			evento:addEventListener( 'tap', hideModalSearch)
            yMain = yMain + 102
			
        end
		
		RestManager.getSearchCoupon(texto)
	elseif screen == "deal" then
	
		yMain = yMain + 50
        local separadorEventos = display.newImage( "img/btn/btnArrowGreen.png" )
        separadorEventos:translate( 41, yMain -3)
        separadorEventos.isVisible = true
        scrViewSearch:insert(separadorEventos)

        local textSeparadorEventos = display.newText( {
            text = "Promociones para ti.",     
            x = 300, y = yMain + 27, width = intW, height = 80,
            font = "Lato-Regular", fontSize = 19, align = "left"
        })
        textSeparadorEventos:setFillColor( 85/255, 85/255, 85/255 )
        scrViewSearch:insert(textSeparadorEventos)
	
	
		yMain = yMain + 30
        for y = 1, #elements, 1 do 
            -- Create container
			
			local deal = Deal:new()
            scrViewSearch:insert(deal)
            deal:build(true, elements[y], imageItems[y])
            deal.y = yMain
			deal:addEventListener( 'tap', hideModalSearch)
            yMain = yMain + 102
			
        end
		
	end
	
	scrViewSearch:setScrollHeight(yMain + 160)
	
end

---------------------------------------------------------
--------------- modalSeach
---------------------------------------------------------

function closeModalSearch()
	if btnModal ~= nil then
		
		Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
		btnModal:removeSelf()
		scrViewSearch:removeSelf()
		btnModal = nil
		scrViewSearch = nil
		--native.showAlert( "Go Deals",Globals.searchText[#Globals.searchText] , { "OK"})
		--print(Globals.searchText[#Globals.searchText])
	end
	
	return true
end

function modalSeach(text)

	yMain = 0
	
	if btnModal ~= nil then
		btnModal:removeSelf()
		scrViewSearch:removeSelf()
		btnModal = nil
		scrViewSearch = nil
	end
    
    btnModal = display.newRect( display.contentCenterX, display.contentCenterY + h + 60, intW, intH )
    btnModal:setFillColor( .92, .92, .92 )
    btnModal.alpha = 1
    GroupSearch:insert(btnModal)
	btnModal:addEventListener("tap",blockModalSearch)
	btnModal:addEventListener("touch",blockModalSearch)
	btnModal:toFront()
	
	scrViewSearch = widget.newScrollView
	{
		top = h + 70,
		left = 0,
		width = intW,
		height = intH,
		--listener = ListenerChangeScrollHome,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		backgroundColor = { .92, .92, .92 }
	}
	GroupSearch:insert(scrViewSearch)
	scrViewSearch.name = "scrViewSearch"
	
	texto = text
	
	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	callbackCurrent = Globals.noCallbackGlobal
	
	RestManager.getSearchEvent(text)
	
	return true
end

function blockModalSearch( event )
	return true
end