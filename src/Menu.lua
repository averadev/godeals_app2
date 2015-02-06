MenuLeft = {}
MenuRight = {}

function MenuLeft:new()
	
	local intW = display.contentWidth
	local intH = display.contentHeight
	local h = display.topStatusBarContentHeight
	
	local lineLeft = {}

	local selfL = display.newGroup()
	
	selfL.x = -480
	
	function selfL:builScreenLeft()
		
		local bgMenuLeft = display.newRect( display.contentCenterX, display.contentCenterY + h, intW, intH )
		--bgMenuLeft:setFillColor( .92, .92, .92 )
		bgMenuLeft:setFillColor( 1 )
		bgMenuLeft.alpha = .2
		bgMenuLeft:addEventListener("tap",hideMenuLeft)
		bgMenuLeft:addEventListener("touch",blockMenu)
		selfL:insert(bgMenuLeft)
		
		local MenuLeft = display.newRect( display.contentCenterX - 80, display.contentCenterY + h, 400, intH )
		MenuLeft:setFillColor( .92, .92, .92 )
		MenuLeft.alpha = 1
		MenuLeft:addEventListener("tap",blockMenu)
		MenuLeft:addEventListener("touch",blockMenu)
		selfL:insert(MenuLeft)
		
		createMenuLeft()
		
	end
	
	function createMenuLeft()
		
		local MenuLeftCiudad = display.newRect( display.contentCenterX - 80, h + 40 , 400, 80 )
		MenuLeftCiudad:setFillColor( .66,.66,.66 )
		MenuLeftCiudad.alpha = 1
		MenuLeftCiudad:addEventListener("tap",blockMenu)
		MenuLeftCiudad:addEventListener("touch",blockMenu)
		selfL:insert(MenuLeftCiudad)
		
		local txtCancun = display.newText( {    
        x = 50, y = MenuLeftCiudad.height + 35 + h,
        text = "Cancun",  font = "Lato-Light", fontSize = 30,
		})
		txtCancun:setFillColor( 0 )
		selfL:insert(txtCancun)
		
		lineLeft[1] = display.newLine(-40, 150 + h, 360, 150 + h)
		selfL:insert(lineLeft[1])
		
		local txtPlaya = display.newText( {    
        x = 35, y = MenuLeftCiudad.height + 110 + h,
        text = "Playa",  font = "Lato-Light", fontSize = 30,
		})
		txtPlaya:setFillColor( 0 )
		selfL:insert(txtPlaya)
		
		lineLeft[2] = display.newLine(-40, 230 + h, 360, 230 + h)
		selfL:insert(lineLeft[2])
		
		
	end
	
	function blockMenu( event )
		return true
	end
	
	return selfL
	
end

function MenuRight:new()
	
	local intW = display.contentWidth
	local intH = display.contentHeight
	local h = display.topStatusBarContentHeight

	local selfR = display.newGroup()
	
	selfR.x = 520
	
	function selfR:builScreenRight()
		
		local bgMenuRight = display.newRect( display.contentCenterX, display.contentCenterY + h, intW, intH )
		--bgMenuRight:setFillColor( .92, .92, .92 )
		bgMenuRight:setFillColor( 1 )
		bgMenuRight.alpha = .2
		bgMenuRight:addEventListener("tap",hideMenuRight)
		bgMenuRight:addEventListener("touch",blockMenu)
		selfR:insert(bgMenuRight)
		
		local MenuRight = display.newRect( 280, display.contentCenterY + h, 400, intH )
		--bgMenuRight:setFillColor( .92, .92, .92 )
		MenuRight:setFillColor( .92, 1, .1 )
		MenuRight.alpha = 1
		MenuRight:addEventListener("tap",blockMenu)
		MenuRight:addEventListener("touch",blockMenu)
		selfR:insert(MenuRight)
	end
	
	function blockMenu( event )
		return true
	end
	
	return selfR
	
end



