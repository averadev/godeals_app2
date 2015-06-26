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
    
    local function changeCity( event )
        local t = event.target
        t.alpha = 1
        transition.to( t, { alpha = .1, time = 200, transition = easing.outExpo, 
            onComplete = function()
                transition.to( t, { alpha = 1, time = 200, transition = easing.outExpo })
                transition.to( grpCity, { y = intH - 60, time = 800, transition = easing.outExpo } )
                hideMenuLeft()
                changeCityName(event.target)
            end 
        })
    end

    local function getCities( event )
        if grpCity.y == intH - 60 then
            transition.to( grpCity, { y = intH - 180, time = 800, transition = easing.outExpo } )
        else
            transition.to( grpCity, { y = intH - 60, time = 800, transition = easing.outExpo } )
        end
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
        icoMenu2.alpha = .5
		selfL:insert(icoMenu2)
        local icoMenu3 = display.newImage( "img/btn/icoMenu3.png" )
        icoMenu3:translate( 295, h + 390 )
        icoMenu3:addEventListener( "tap", cerrarSession )
		selfL:insert(icoMenu3)
        
        local txtMenu1 = display.newText( {
            text = "Tutorial",
            x = 20, y = h + 440,
            width = 100, height = 30,
            font = "Lato-Bold",  fontSize = 14, align = "center"
        })
		selfL:insert(txtMenu1)
        local txtMenu2 = display.newText( {
            text = "Configuración",
            x = 160, y = h + 440,
            width = 100, height = 30,
            font = "Lato-Bold",  fontSize = 14, align = "center"
        })
        txtMenu2:setFillColor( .5 )
		selfL:insert(txtMenu2)
        local txtMenu3 = display.newText( {
            text = "Cerrar Sesión",
            x = 295, y = h + 440,
            width = 100, height = 30,
            font = "Lato-Bold",  fontSize = 14, align = "center"
        })
		selfL:insert(txtMenu3)
        
        -- Menu Ciudades
		local lastY = 90
		local rectCity = {}
        selfL:insert(grpCity)
        grpCity.y = intH - 60
		
		local MenuLeftCiudad = display.newRect( display.contentCenterX - 80, 30 , 400, 60 )
		MenuLeftCiudad:setFillColor( 50/255, 150/255, 0 )
        MenuLeftCiudad:addEventListener( "tap", getCities )
		grpCity:insert(MenuLeftCiudad)
        
        local icoMenuCity = display.newImage( "img/btn/icoMenuCity.png" )
        icoMenuCity:translate( 320, 30)
        grpCity:insert(icoMenuCity)
        
        titleLeft = display.newText( {    
            x = 150, y = 32, align = "left", width = 300,
            text = "CAMBIAR CIUDAD",  font = "Lato-Bold", fontSize = 18,
        })
        titleLeft:setFillColor( 1 )
        grpCity:insert(titleLeft)
		
		
		--creamos los botones del menu
		for y = 1, #items, 1 do
			rectCity[y] = display.newRect(  display.contentCenterX - 80, lastY, 400, 60 )
			rectCity[y]:setFillColor( .7 )
			rectCity[y].txtMin = items[y].name
			rectCity[y].id = items[y].idCity
			rectCity[y]:addEventListener( "tap", changeCity )
			grpCity:insert(rectCity[y])
            
            txtCity = display.newText( {    
                x = 150, y = MenuLeftCiudad.height + lastY - 60, align = "left", width = 300,
                text = " - " .. items[y].name,  font = "Lato-Bold", fontSize = 18,
            })
			txtCity:setFillColor( 0 )
			grpCity:insert(txtCity)
			
			lineLeft[y] = display.newLine(-40, lastY + 30, 360, lastY + 30)
			grpCity:insert(lineLeft[y])
			
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



