--groupSearchModal

require('src.BuildRow')
local RestManager = require('src.resources.RestManager')
local widget = require( "widget" )
local Globals = require('src.resources.Globals')
local storyboard = require( "storyboard" )

local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight
local yMain = 0
local texto = ""
local callbackCurrent = 0

local btnModal, bgModal

local scrViewSearch = {}

local elements = {}
local imageItems = {}
local ScreenScene = {}

local currentScene = ""
local nextScene = ""

local contSearch = 0;

GroupSearch = display.newGroup()

function setSearchElements(items)
	elements = items
end

function hideModalSearch( event )

	nextScene = storyboard.getCurrentSceneName()
	
	for y = 1, #Globals.scene, 1 do
		if Globals.scene[y] == nextScene then
			table.remove(Globals.scene, y)
			table.remove(scrViewSearch, y)
			table.remove(ScreenScene, y)
		end
	end
	
	for y = 1, #Globals.scene, 1 do
		if Globals.scene[y] == nextScene then
			table.remove(Globals.scene, y)
		end
	end
	
	if currentScene == nextScene then
		closeModalSearch()
	end

	deleteTxt()

	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	local pSearch = #Globals.searchText + 1
	Globals.searchText[pSearch] = texto
	
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

	contSearch = contSearch + 1

	endLoading()
	
	if screen == "event" then
	
	yMain = yMain + 30
	
		local separadorEventos = display.newImage( "img/btn/btnArrowGreen.png" )
        separadorEventos:translate( 41, yMain)
        separadorEventos.isVisible = true
        scrViewSearch[#scrViewSearch]:insert(separadorEventos)

        local textSeparadorEventos = display.newText( {
            text = "Eventos y actividades.",     
            x = 300, y = yMain + 30, width = intW, height = 80,
            font = "Lato-Regular", fontSize = 19, align = "left"
        })
        textSeparadorEventos:setFillColor( 85/255, 85/255, 85/255 )
        scrViewSearch[#scrViewSearch]:insert(textSeparadorEventos)
	
		yMain = yMain + 30
        for y = 1, #elements, 1 do 
            -- Create container
			
			local evento = Event:new()
            scrViewSearch[#scrViewSearch]:insert(evento)
            evento:build(true,elements[y], imageItems[y])
            evento.y = yMain
			evento.name = "src.Evento"
			evento:addEventListener( 'tap', hideModalSearch)
            yMain = yMain + 120
			
        end
		--getLoading()
		getLoading(scrViewSearch[#scrViewSearch])
		RestManager.getSearchCoupon(texto)
	elseif screen == "deal" then
	
		yMain = yMain + 50
        local separadorEventos = display.newImage( "img/btn/btnArrowGreen.png" )
        separadorEventos:translate( 41, yMain -3)
        separadorEventos.isVisible = true
        scrViewSearch[#scrViewSearch]:insert(separadorEventos)

        local textSeparadorEventos = display.newText( {
            text = "Promociones para ti.",     
            x = 300, y = yMain + 27, width = intW, height = 80,
            font = "Lato-Regular", fontSize = 19, align = "left"
        })
        textSeparadorEventos:setFillColor( 85/255, 85/255, 85/255 )
        scrViewSearch[#scrViewSearch]:insert(textSeparadorEventos)
	
	
		yMain = yMain + 30
        for y = 1, #elements, 1 do 
            -- Create container
			
			local deal = Deal:new()
            scrViewSearch[#scrViewSearch]:insert(deal)
            deal:build(true, elements[y], imageItems[y])
            deal.y = yMain
			deal:addEventListener( 'tap', hideModalSearch)
            yMain = yMain + 120
			
        end
		
	end
	
	scrViewSearch[#scrViewSearch]:setScrollHeight(yMain + 20)
	
end

function noSearchFind()
	endLoading()
	
	if contSearch == 0 then
		getNoContent(scrViewSearch[#scrViewSearch], "No hay resultados, intente con otra palabra")
		contSearch = 0
	end
end

---------------------------------------------------------
--------------- modalSeach
---------------------------------------------------------

function closeModalSearch()

	if #scrViewSearch ~= 0 then
		
		Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
		local previuScreen = ScreenScene[#ScreenScene - 1]
		local currentScreen = ScreenScene[#ScreenScene]
		--elimina las busquedas si estan repetidas
		if previuScreen == currentScreen then
			while previuScreen == currentScreen  do
				previuScreen = ScreenScene[#ScreenScene - 1]
				if #scrViewSearch > 0 then
					scrViewSearch[#scrViewSearch]:removeSelf()
					table.remove(scrViewSearch,#scrViewSearch)
					table.remove(ScreenScene, #ScreenScene)
				end
			end
			--elimina solo una busqueda
		else
			scrViewSearch[#scrViewSearch]:removeSelf()
			table.remove(scrViewSearch,#scrViewSearch)
			table.remove(ScreenScene, #ScreenScene)
		end
	end
	
	return true
end

function modalSeach(text,self)

	yMain = 0
	
	local poscSRV = #scrViewSearch + 1
	
	currentScene = storyboard.getCurrentSceneName()
	ScreenScene[#ScreenScene + 1] = currentScene
	
	scrViewSearch[poscSRV] = widget.newScrollView
	{
		top = h + 65,
		left = 0,
		width = intW,
		height = intH - (h + 65),
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		listener = blockModalSearch,
		backgroundColor = { .92, .92, .92 }
	}
	self:insert(scrViewSearch[poscSRV])
	scrViewSearch[poscSRV].name = "scrViewSearch"
	scrViewSearch[poscSRV]:toFront()
	scrViewSearch[poscSRV]:addEventListener( 'tap',blockModalSearch)
	
	getLoading(scrViewSearch[poscSRV])
	
	texto = text
	
	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	callbackCurrent = Globals.noCallbackGlobal
	
	RestManager.getSearchEvent(text)
	
	return true
end

function blockModalSearch( event )
	return true
end