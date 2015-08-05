local Globals = require('src.resources.Globals')

MenuLeft = {}
MenuRight = {}

function MenuLeft:new()
    
    local DBManager = require('src.resources.DBManager')
	local RestManager = require('src.resources.RestManager')
	
	local intW = display.contentWidth
	local intH = display.contentHeight
	local h = display.topStatusBarContentHeight
	local rectCancun, rectPlaya
	local lineLeft = {}

	local selfL = display.newGroup()
    local grpCity = display.newGroup()
	local grpLanguage = display.newGroup()
	
	local rectCity = {}
	
	local rectLanguage = {}
	
	selfL.x = -480
	
	function selfL:builScreenLeft()
		
		local bgMenuLeft = display.newRect( display.contentCenterX, display.contentCenterY + h, intW, intH )
		bgMenuLeft:setFillColor( 1 )
		bgMenuLeft.alpha = .2
		bgMenuLeft:addEventListener("tap",hideMenuLeft)
		bgMenuLeft:addEventListener("touch",blockMenu)
		selfL:insert(bgMenuLeft)
		
		local MenuLeft = display.newRect( display.contentCenterX - 80, display.contentCenterY + h, 400, intH )
		MenuLeft:setFillColor( .1 )
		MenuLeft.alpha = 1
		MenuLeft:addEventListener("tap",blockMenu)
		MenuLeft:addEventListener("touch",blockMenu)
		selfL:insert(MenuLeft)
		
		RestManager.getCity()
		
	end
	
	function HideChangeCity()
		transition.to( grpCity, { y = intH - 123, time = 800, transition = easing.outExpo } )
		transition.to( grpLanguage, { y = intH - 60, time = 800, transition = easing.outExpo } )
	end
    
    local function changeCity( event )
        local t = event.target
        t.alpha = 1
        transition.to( t, { alpha = .9, time = 200, transition = easing.outExpo, 
            onComplete = function()
                transition.to( t, { alpha = 1, time = 200, transition = easing.outExpo })
                --transition.to( grpCity, { y = intH - 60, time = 800, transition = easing.outExpo } )
                hideMenuLeft()
				if t.isTrue == 0 then
					changeCityName(event.target)
				end
				
				--rectCity[y]:setFillColor( .4 )
				for y = 1, #rectCity, 1 do
					rectCity[y]:setFillColor( .7 )
					rectCity[y].isTrue = 0
				end
				t:setFillColor( .4 )
				t.isTrue = 1
                
            end 
        })
		
		return true
    end
	
	local function changeLanguage( event )
		
		local t = event.target
        t.alpha = 1
        transition.to( t, { alpha = .9, time = 200, transition = easing.outExpo, 
            onComplete = function()
                transition.to( t, { alpha = 1, time = 200, transition = easing.outExpo })
                --transition.to( grpCity, { y = intH - 60, time = 800, transition = easing.outExpo } )
                hideMenuLeft()
				if t.isTrue == 0 then
					changeLanguageName(event.target)
				end
				for y = 1, #rectLanguage, 1 do
					rectLanguage[y]:setFillColor( .7 )
					rectLanguage[y].isTrue = 0
				end
				t:setFillColor( .4 )
				t.isTrue = 1
			end 
        })
		
		
		return true
		
	end
    
    local function getPartners( event )
        local t = event.target
        t.alpha = .5
        transition.to( t, { alpha = .05, time = 200, transition = easing.outExpo, 
            onComplete = function()
                hideMenuLeft()
                showPartners()
            end 
        })
    end
	
	local function ShowRedeemCode( event )
		local t = event.target
        t.alpha = .5
        transition.to( t, { alpha = .05, time = 200, transition = easing.outExpo, 
            onComplete = function()
                hideMenuLeft()
				showCode()
            end 
        })
		return true
	end

    function getCities( event )
	
		
		
		transition.to( grpLanguage, { y = intH - 60, time = 800, transition = easing.outExpo } )
        if grpCity.y == intH - 123 then
            transition.to( grpCity, { y = intH - 240, time = 800, transition = easing.outExpo } )
        else
            transition.to( grpCity, { y = intH - 123, time = 800, transition = easing.outExpo } )
			if grpLanguage.y - intH - 123  == -303 then
				transition.to( grpCity, { y = intH - 240, time = 800, transition = easing.outExpo } )
			end
        end
		return true
    end
	
	function getLanguage( event )
		 transition.to( grpCity, { y = intH - 123, time = 800, transition = easing.outExpo } )
		if grpLanguage.y == intH - 60 then
			transition.to( grpCity, { y = intH - 240, time = 800, transition = easing.outExpo } )
            transition.to( grpLanguage, { y = intH - 180, time = 800, transition = easing.outExpo } )
        else
            transition.to( grpLanguage, { y = intH - 60, time = 800, transition = easing.outExpo } )
			--transition.to( grpCity, { y = intH - 123, time = 800, transition = easing.outExpo } )
        end
		return true
		
	end
    
    local function cerrarSession( event )
        hideMenuLeft()
        logout()
    end
	
	function createMenuLeft(items)
        
        local settings = DBManager.getSettings()
        local sizeAvatar = 'width=200&height=200'
        
		if settings.fbId == "" then
            local avatar = display.newImage( "img/bgk/user.png" )
            avatar.x = 150
            avatar.y = h + 160
            avatar.width = 200
            avatar.height  = 200
			selfL:insert(avatar)
            
            local mask = display.newImage( "img/bgk/bgAvatar.png" )
            mask:translate( 150, h + 160)
            selfL:insert(mask)
		else
			local path = system.pathForFile( "avatarFb"..settings.fbId, system.TemporaryDirectory )
			local fhd = io.open( path )
			if fhd then
				fhd:close()
                local avatar = display.newImage("avatarFb"..settings.fbId, system.TemporaryDirectory )
                avatar:translate( 150, h + 160)
                avatar.width = 200
                avatar.height  = 200
				selfL:insert(avatar)
                
                local mask = display.newImage( "img/bgk/bgAvatar.png" )
                mask:translate( 150, h + 160)
				selfL:insert(mask)
			else
				local function networkListenerFB( event )
					-- Verificamos el callback activo
					if ( event.isError ) then
					else
                        event.target.x = 150
                        event.target.y = h + 160
                        event.target.height = 200
                        event.target.width = 200
						selfL:insert( event.target )
                        
                        local mask = display.newImage( "img/bgk/bgAvatar.png" )
                        mask:translate( 150, h + 160)
                        selfL:insert(mask)
					end
				end
				display.loadRemoteImage( "http://graph.facebook.com/".. settings.fbId .."/picture?type=large&"..sizeAvatar, 
					"GET", networkListenerFB, "avatarFb"..settings.fbId, system.TemporaryDirectory )
			end
		end
        
        local textNombre = display.newText( {
            text = settings.name,     
            x = 160, y = h + 300,
            width = 380, height = 30,
            font = "Lato-Bold",  fontSize = 30, align = "center"
        })
        textNombre:setFillColor( 1 )
        selfL:insert(textNombre)
        if settings.fbId == "" then
            textNombre.text = settings.email
        end
        
        -- Menu Buttons
        local lineTop = display.newRect( 160, h + 350, 400, 1)
        lineTop.alpha = .5
		selfL:insert(lineTop)
        local lineBottom = display.newRect( 160, h + 450, 400, 1)
        lineBottom.alpha = .5
		selfL:insert(lineBottom)
        local lineH1 = display.newRect( 85, h + 400, 2, 100)
        lineH1.alpha = .5
		selfL:insert(lineH1)
        local lineH2 = display.newRect( 230, h + 400, 2, 100)
        lineH2.alpha = .5
		selfL:insert(lineH2)
        
        local icoMenu1 = display.newImage( "img/btn/icoMenu1.png" )
        icoMenu1:translate( 20, h + 390 )
        icoMenu1:addEventListener( "tap", showTutorial )
		selfL:insert(icoMenu1)
        local icoMenu2 = display.newImage( "img/btn/icoMenu2.png" )
        icoMenu2:translate( 160, h + 390 )
		icoMenu2:addEventListener( "tap", ShowRedeemCode )
		selfL:insert(icoMenu2)
        local icoMenu3 = display.newImage( "img/btn/icoMenu3.png" )
        icoMenu3:translate( 295, h + 390 )
        icoMenu3:addEventListener( "tap", cerrarSession )
		selfL:insert(icoMenu3)
        
        local txtMenu1 = display.newText( {
            text = Globals.language.menuTxtMenu1,
            x = 20, y = h + 440,
            width = 100, height = 30,
            font = "Lato-Bold",  fontSize = 14, align = "center"
        })
		selfL:insert(txtMenu1)
        local txtMenu2 = display.newText( {
            text = Globals.language.menuTxtMenu2,
            x = 160, y = h + 440,
            width = 100, height = 30,
            font = "Lato-Bold",  fontSize = 14, align = "center"
        })
        txtMenu2:setFillColor( .5 )
		selfL:insert(txtMenu2)
        local txtMenu3 = display.newText( {
            text = Globals.language.menuTxtMenu3,
            x = 295, y = h + 440,
            width = 100, height = 30,
            font = "Lato-Bold",  fontSize = 14, align = "center"
        })
		selfL:insert(txtMenu3)
        
        
        -- Comercios afiliados
        local bgComercios = display.newRect( display.contentCenterX - 80, h + 545, 400, 70 )
		bgComercios:setFillColor( .5 )
        bgComercios.alpha = .05
        bgComercios:addEventListener( "tap", getPartners )
		selfL:insert(bgComercios)
        local lineTopC = display.newRect( 160, h + 510, 400, 1)
        lineTopC:setFillColor( 50/255, 150/255, 0 )
		selfL:insert(lineTopC)
        local lineBottomC = display.newRect( 160, h + 580, 400, 1)
        lineBottomC:setFillColor( 50/255, 150/255, 0 )
		selfL:insert(lineBottomC)
        
        local txtMenu4 = display.newText( {
            text = Globals.language.menuTxtMenu4,
            x = 160, y = h + 545, width = 330, 
            font = "Lato-Bold",  fontSize = 18, align = "left"
        })
		selfL:insert(txtMenu4)
		
		 -- Cambio de codigo
        --[[local bgChangeCode = display.newRect( display.contentCenterX - 80, h + 620, 400, 70 )
		bgChangeCode:setFillColor( .5 )
        bgChangeCode.alpha = .05
        bgChangeCode:addEventListener( "tap", ShowRedeemCode )
		selfL:insert(bgChangeCode)
		local lineBottomCC = display.newRect( 160, h + 655, 400, 1)
        lineBottomCC:setFillColor( 50/255, 150/255, 0 )
		selfL:insert(lineBottomCC)
		
		local txtMenuCC = display.newText( {
            text = Globals.language.menuTxtMenuCC,
            x = 160, y = h + 620, width = 330, 
            font = "Lato-Bold",  fontSize = 18, align = "left"
        })
		selfL:insert(txtMenuCC)--]]
        
        
        -- Menu Ciudades
		local lastY = 90
        selfL:insert(grpCity)
        --grpCity.y = intH - 60
		grpCity.y = intH - 123
		
		local MenuLeftCiudad = display.newRect( display.contentCenterX - 80, 30 , 400, 60 )
		MenuLeftCiudad:setFillColor( 50/255, 150/255, 0 )
        MenuLeftCiudad:addEventListener( "tap", getCities )
		grpCity:insert(MenuLeftCiudad)
        
        --[[local icoMenuCity = display.newImage( "img/btn/icoMenuCity.png" )
        icoMenuCity:translate( 320, 30)
        grpCity:insert(icoMenuCity)]]
        
        titleLeft = display.newText( {    
            x = 150, y = 32, align = "left", width = 300,
            text = Globals.language.menuTitleLeft,  font = "Lato-Bold", fontSize = 18,
        })
        titleLeft:setFillColor( 1 )
        grpCity:insert(titleLeft)
		
		--creamos los botones del menu
		for y = 1, #items, 1 do
			rectCity[y] = display.newRect(  display.contentCenterX - 80, lastY, 400, 60 )
			rectCity[y]:setFillColor( .7 )
			rectCity[y].txtMin = items[y].name
			rectCity[y].id = items[y].idCity
			rectCity[y].isTrue = 0
			rectCity[y]:addEventListener( "tap", changeCity )
			grpCity:insert(rectCity[y])
			
			if tonumber(settings.city) == tonumber(items[y].idCity) then
				rectCity[y]:setFillColor( .4 )
				rectCity[y].isTrue = 1
			end
            
            txtCity = display.newText( {    
                x = 150, y = MenuLeftCiudad.height + lastY - 60, align = "left", width = 300,
                text = " - " .. items[y].name,  font = "Lato-Bold", fontSize = 18,
            })
			txtCity:setFillColor( 0 )
			grpCity:insert(txtCity)
			
			lineLeft[y] = display.newLine(-40, lastY + 30, 360, lastY + 30)
			grpCity:insert(lineLeft[y])
			lineLeft[y]:setStrokeColor( 0, 0, 0, 1 )
			lineLeft[y].strokeWidth = 5
			lineLeft[y]:toFront()
			
			lastY = lastY + 60
		end
		
		local lastY = 90
		selfL:insert(grpLanguage)
		grpLanguage.y = intH - 60
		
		local MenuLeftLanguage = display.newRect( display.contentCenterX - 80, 30 , 400, 60 )
		MenuLeftLanguage:setFillColor( 50/255, 150/255, 0 )
        MenuLeftLanguage:addEventListener( "tap", getLanguage )
		grpLanguage:insert(MenuLeftLanguage)
        
        titleLanguageLeft = display.newText( {    
            x = 150, y = 32, align = "left", width = 300,
            text = Globals.language.menuTitleLanguageLeft,  font = "Lato-Bold", fontSize = 18,
        })
        titleLanguageLeft:setFillColor( 1 )
        grpLanguage:insert(titleLanguageLeft)
		
		local LanguageName = {'Español','English'}
		local LanguageSub = {'es','en'}
		
		--rectLanguage
		
		for y = 1, #LanguageName, 1 do
			rectLanguage[y] = display.newRect(  display.contentCenterX - 80, lastY, 400, 60 )
			rectLanguage[y]:setFillColor( .7 )
			rectLanguage[y].txtMin = LanguageSub[y]
			rectLanguage[y].isTrue = 0
			--rectLanguage[y].id = items[y].idCity
			rectLanguage[y]:addEventListener( "tap", changeLanguage )
			grpLanguage:insert(rectLanguage[y])
			
			if settings.language == LanguageSub[y]  then
				rectLanguage[y]:setFillColor( .4 )
				rectLanguage[y].isTrue = 1
			end
            
            txtLanguage = display.newText( {    
                x = 150, y = MenuLeftCiudad.height + lastY - 60, align = "left", width = 300,
                text = " - " .. LanguageName[y],  font = "Lato-Bold", fontSize = 18,
            })
			txtLanguage:setFillColor( 0 )
			grpLanguage:insert(txtLanguage)
			
			lineLeft[y] = display.newLine(-40, lastY + 30, 360, lastY + 30)
			grpLanguage:insert(lineLeft[y])
			lineLeft[y]:setStrokeColor( 0, 0, 0, 1 )
			lineLeft[y].strokeWidth = 5
			lineLeft[y]:toFront()
			
			lastY = lastY + 60
		end
		
		-- Border Right
        local borderRight = display.newRect( 358, intH / 2, 4, intH )
        borderRight:setFillColor( {
            type = 'gradient',
            color1 = { .1, .1, .1, .7 }, 
            color2 = { .9, .9, .9, .4 },
            direction = "left"
        } ) 
        borderRight:setFillColor( 0, 0, 0 ) 
        selfL:insert(borderRight)
		
	end
	
	function blockMenu( event )
		return true
	end
	
	return selfL
	
end



