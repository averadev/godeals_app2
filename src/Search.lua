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

local poscSRV = 0

local btnModal, bgModal

local scrViewSearch = nil
local groupSearch = {}

local elements = {}
local imageItems = {}
local ScreenScene = {}

local currentScene = ""
local nextScene = ""

local contSearch = 0;
local contSearchActive = 0

GroupSearch = display.newGroup()

function setSearchElements(items)
	elements = items
	for y=1, #elements, 1 do
		elements[y].identificador = 1
	end
end

function hideModalSearch( event )

	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1

	groupSearch[poscSRV].x = 480
	scrViewSearch.x = 720
	
	deleteTxt()
	
	contSearchActive = contSearchActive + 1

	endLoading()
	
end

function showModalSearch()
	
	local SceneCurrent = ScreenScene[#ScreenScene]
	local SceneCurrent2 = storyboard.getCurrentSceneName()
	local contScene = #ScreenScene
	local SceneCurrent3 = ScreenScene[#ScreenScene]
	
	while SceneCurrent == SceneCurrent3 do
			if SceneCurrent then
				if #SceneCurrent > 0 then
					SceneCurrent3 = ScreenScene[contScene]
				
					contScene = contScene - 1
				else
					SceneCurrent3 = nil
				end
			else
				SceneCurrent3 = 0
			end
	end

	if scrViewSearch ~= nil and SceneCurrent ==  SceneCurrent2 then
		showSearch()
		scrViewSearch.x = 240
		groupSearch[#groupSearch].x = 0
		
	elseif scrViewSearch ~= nil and SceneCurrent2 ==  SceneCurrent3 then
		showSearch()
		scrViewSearch.x = 240
		groupSearch[#groupSearch].x = 0
	else
		hideSearch2()
	end
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
			groupSearch[poscSRV]:insert(separadorEventos)

			local textSeparadorEventos = display.newText( {
				text = Globals.language.searchTextSeparadorEventos,     
				x = 300, y = yMain + 30, width = intW, height = 80,
				font = "Lato-Regular", fontSize = 19, align = "left"
			})
			textSeparadorEventos:setFillColor( 85/255, 85/255, 85/255 )
			groupSearch[poscSRV]:insert(textSeparadorEventos)
		
		if callbackCurrent == Globals.noCallbackGlobal then
	
		yMain = yMain + 50
        for y = 1, #elements, 1 do 
            -- Create container
			
				local evento = Event:new()
				groupSearch[poscSRV]:insert(evento)
				evento:build(true,elements[y], imageItems[y])
				evento.y = yMain
				evento.name = "src.Evento"
				evento:addEventListener( 'tap', hideModalSearch)
				yMain = yMain + 180
			
        end
		
		--getLoading(scrViewSearch)
		RestManager.getSearchCoupon(texto)
		
		end
	elseif screen == "deal" then
	
		yMain = yMain + 30
			local separadorEventos = display.newImage( "img/btn/btnArrowGreen.png" )
			separadorEventos:translate( 41, yMain -3)
			separadorEventos.isVisible = true
			groupSearch[poscSRV]:insert(separadorEventos)

			local textSeparadorEventos = display.newText( {
				text = Globals.language.searchTextSeparadorDeals,     
				x = 300, y = yMain + 27, width = intW, height = 80,
				font = "Lato-Regular", fontSize = 19, align = "left"
			})
			textSeparadorEventos:setFillColor( 85/255, 85/255, 85/255 )
			groupSearch[poscSRV]:insert(textSeparadorEventos)
		
		if callbackCurrent == Globals.noCallbackGlobal then
	
			yMain = yMain + 50
			for y = 1, #elements, 1 do 
				-- Create container
			
				local deal = Deal:new()
				groupSearch[poscSRV]:insert(deal)
				deal:build(true, elements[y], imageItems[y])
				deal.y = yMain
				deal:addEventListener( 'tap', hideModalSearch)
				yMain = yMain + 180
			
			end
		
		end
	
		scrViewSearch:setScrollHeight(yMain + 20)
	
	end
	
end

function noSearchFind()
	endLoading()
	
	if contSearch == 0 and scrViewSearch ~= nil then
		
		getNoContent(scrViewSearch, Globals.language.searchGetNoContent)
		contSearch = 0
	end
end

---------------------------------------------------------
--------------- modalSeach
---------------------------------------------------------

function closeModalSearch()

	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1

	if scrViewSearch ~= nil and scrViewSearch.x == 240 then
		Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
		if #groupSearch > 1 then
			scrViewSearch.x = 720
			
			local previuScreen = ScreenScene[#ScreenScene - 1]
			local currentScreen = ScreenScene[#ScreenScene]
			local sceneCurrent = storyboard.getCurrentSceneName()
			
			--elimina las busquedas si estan repetidas
			if #groupSearch == contSearchActive then
				if previuScreen == currentScreen then
					while previuScreen == currentScreen  do
						previuScreen = ScreenScene[#ScreenScene - 1]
						if #groupSearch > 0 then
							groupSearch[#groupSearch]:removeSelf()
							table.remove(groupSearch,#groupSearch)
							table.remove(ScreenScene, #ScreenScene)
							contSearchActive = contSearchActive - 1
						else
						
						end
					end
				
					if sceneCurrent ~= currentScreen then
						groupSearch[#groupSearch]:removeSelf()
						table.remove(groupSearch,#groupSearch)
						table.remove(ScreenScene, #ScreenScene)
					end
				else
					groupSearch[#groupSearch]:removeSelf()
					table.remove(groupSearch,#groupSearch)
					table.remove(ScreenScene, #ScreenScene)
				end
				--elimina solo una busqueda
			else
				groupSearch[#groupSearch]:removeSelf()
				table.remove(groupSearch,#groupSearch)
				table.remove(ScreenScene, #ScreenScene)
				GroupSearch = nil
				contSearchActive = contSearchActive - 1
			end
			
			scrViewSearch:setScrollHeight(groupSearch[#groupSearch].height + 50)
			
		else
			groupSearch[#groupSearch]:removeSelf()
			table.remove(groupSearch,#groupSearch)
			table.remove(ScreenScene, #ScreenScene)
			scrViewSearch:removeSelf()
			scrViewSearch = nil
			contSearchActive = contSearchActive - 1
		end
	end
	
	deleteTxt()
	
	return true
end

function modalSeach(text,self)

	yMain = 0
	
	poscSRV = #groupSearch + 1
	
	currentScene = storyboard.getCurrentSceneName()
	ScreenScene[#ScreenScene + 1] = currentScene
	
	if scrViewSearch == nil then
		scrViewSearch = widget.newScrollView
		{
			top = h + 80,
			left = 0,
			width = intW,
			height = intH - (h + 80),
			horizontalScrollDisabled = true,
			verticalScrollDisabled = false,
			backgroundColor = { .92, .92, .92 }
		}
		--self:insert(scrViewSearch)
		scrViewSearch.name = "scrViewSearch"
		scrViewSearch:toFront()
		scrViewSearch:addEventListener( 'tap',blockModalSearch)
	else
		scrViewSearch.x = 240
	end
	
		groupSearch[poscSRV] = display.newGroup()
		scrViewSearch:insert(groupSearch[poscSRV])
	
	if scrViewSearch then
		getLoading(scrViewSearch)
	end
	
	texto = text
	
	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	callbackCurrent = Globals.noCallbackGlobal
	
	RestManager.getSearchEvent(text)
	
	return true
end

function blockModalSearch( event )
	if(scrViewSearch[poscSRV]) then
		return true
	end
end