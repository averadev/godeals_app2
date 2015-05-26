
local json = require("json")
local facebook = require( "facebook" )
local RestManager = require('src.resources.RestManager')
local Globals = require('src.resources.Globals')
local widget = require( "widget" )
require('src.BuildRow')

--variables
local intW = display.contentWidth
local intH = display.contentHeight
local midH = display.contentHeight / 2
local h = display.topStatusBarContentHeight
local faceActive = 0
local fbAppID = "750089858383563"
local lastY = 40
local previousFriend = 1
local idCoupon = 0
local contFriendlist = 0
local lockInput = 0;

local btnAceptF

local txtEmailFriend

local txtSendEmail

local xscv, yscv

--contenedores
local scvFriends
local groupFriends = display.newGroup()
local groupFriendsList = display.newGroup()
local maxShape = {}
local txtIsNotFriends


--muestra el modal con la lista de amigos
function showListFriends(idC)

	idCoupon = idC

	local bgFriend = display.newRect( display.contentCenterX, display.contentCenterY + h, intW, intH)
    bgFriend:setFillColor( 0 )
    bgFriend.alpha = .5
    groupFriends:insert(bgFriend)
	bgFriend:addEventListener( "tap", CloseListFriends )
	bgFriend:addEventListener( "touch", CloseListFriends )
	
	local imgBgFriends = display.newImage( "img/bgk/bgShare.png" )
	imgBgFriends:translate( (intW / 2), midH )
	groupFriends:insert(imgBgFriends)
	imgBgFriends:addEventListener( 'tap', lockedModalFriend )
	imgBgFriends:addEventListener( 'touch', lockedModalFriend )
	
	local friendsTitle = display.newText( {
		text = "Compartir DEAL con:",     
		x = 200, y = midH - 235,
		width = 300,
		font = "Lato-Regular",  fontSize = 20
	})
	friendsTitle:setFillColor( 1 )
	groupFriends:insert(friendsTitle)
	
	local btnRefreshFriend = display.newRoundedRect(370, midH - 235, 140, 46, 5)
	btnRefreshFriend:setFillColor({
        type = 'gradient',
        color1 = { 0, 179/255, 0 }, 
        color2 = { 0, 138/255, 0 },
        direction = "bottom"
    })
	groupFriends:insert(btnRefreshFriend)
	btnRefreshFriend:addEventListener( 'tap', refreshFriend )
    
    local friendRefresh = display.newImage( "img/btn/friendRefresh.png" )
	friendRefresh:translate( 320, midH - 235 )
	groupFriends:insert(friendRefresh)
	
	local txtRefreshFriend = display.newText( {
		text = "ACTUALIZAR AMIGOS",     
		x = 385, y = midH - 235, width = 110,
		font = "Lato-Regular",  fontSize = 14, align = "center"
	})
	txtRefreshFriend:setFillColor( 1 )
	groupFriends:insert(txtRefreshFriend)
	
	btnAceptF = display.newRoundedRect(350, midH + 210, 170, 50, 5)
	btnAceptF:setFillColor(0/255, 149/255, 186/255)
	groupFriends:insert(btnAceptF)
	
	local txtAceptF = display.newText( {
		text = "Compartir",     
		x = 350, y = midH + 210,
		width = 200,
		font = "Lato-Regular",  fontSize = 20, align = "center"
	})
	txtAceptF:setFillColor( 1 )
	groupFriends:insert(txtAceptF)
	
	local btnCancelF = display.newRoundedRect(130, midH + 210, 170, 50, 5)
	btnCancelF:setFillColor(241/255, 151/255, 151/255)
	groupFriends:insert(btnCancelF)
	btnCancelF:addEventListener( "tap", CloseListFriends )
	
	local txtCancelF = display.newText( {
		text = "Cancelar",     
		x = 130, y = midH + 210,
		width = 200,
		font = "Lato-Regular",  fontSize = 20, align = "center"
	})
	txtCancelF:setFillColor( 1 )
	groupFriends:insert(txtCancelF)
	
	scvFriends = widget.newScrollView
	{
		top = midH - 185,
		left = 40,
		width = 400,
		height = 360,
		listener = ScrollListenerFriends,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		isBounceEnabled = false,
		backgroundColor = { 1 }--.96
	}
	groupFriends:insert(scvFriends)
	
	createListFriends()

	return true;
end

--cierra el modal de amigos
function CloseListFriends( event )
	native.setKeyboardFocus(nil)
	groupFriends:removeSelf()
	groupFriends = display.newGroup()
	idCoupon = 0
	groupFriendsList = display.newGroup()
	lastY = 50
	maxShape = {}
	lockInput = 0
	
	return true;
end

--bloqueamos los efectos de tap y touch
function lockedModalFriend( event )
	return true
end

--crea los items de amigos
function createListFriends()

	if faceActive == 0 then
		
		faceActive = 1
		facebook.login( fbAppID, facebookListener2, {"public_profile", "email", "user_birthday", "user_friends"} )
		
	elseif faceActive == 1 then
		
		local params = { fields = "name,id" }
        facebook.request( "me/friends", "GET",params )
		
	end
			
	scvFriends:setScrollHeight(lastY + 20)
	
end

--actualiza la lista de amigos
function refreshFriend( event )
	
	native.setKeyboardFocus(nil)
	
	createListFriends()
	
	return true
	
end

function facebookListener2( event )

    if ( "session" == event.type ) then
        if ( "login" == event.phase ) then
			local params = { fields = "email,name,id" }
            facebook.request( "me/friends", "GET",params )
		elseif ( "loginCancelled" == event.phase) then
			groupFriendsList:removeSelf()
			groupFriendsList = display.newGroup()
			lastY = 40
			groupFriendsList = display.newGroup()
			scvFriends:insert( groupFriendsList )
			faceActive = 0
			printTextFriend()
        end
    elseif ( "request" == event.type ) then
		
        if ( not event.isError ) then
            local response = json.decode( event.response )
			
				BuildItemsFriends(response.data)
        end
    end
end

-- crea la lista de amigos
function BuildItemsFriends(items)

	contFriendlist = #items

	if #items > 0 then
	
		groupFriendsList:removeSelf()
		groupFriendsList = display.newGroup()
		lastY = 40
		scvFriends:scrollToPosition{
			y =  0,
			time = 200
		}
		maxShape = {}
		
		scvFriends:insert( groupFriendsList )
	
		for i = 1, #items, 1 do
			loadImageFriend(items[i])
			if i == #items then
			end
			
        end
		
		scvFriends:setScrollHeight(lastY + 8)
	else
		
		groupFriendsList = display.newGroup()
		scvFriends:insert( groupFriendsList )
		
		txtIsNotFriends = display.newText( {
			text = "No se encontro lista de amigos",     
			x = 230, y = 60,
			width = 380,
			font = "Lato-Regular", fontSize = 24, align = "left"
		})
		txtIsNotFriends:setFillColor( 0 )
		groupFriendsList:insert(txtIsNotFriends)
		
		lastY = lastY + 100
		
		printTextFriend()
	
	end
end

--activa el boton de aceptar
function selectFriend( event )

	maxShape[previousFriend]:setFillColor( 1 )

	previousFriend =  event.target.num

	maxShape[event.target.num]:setFillColor( .80 )

	btnAceptF.alpha = 1
	btnAceptF.id = event.target.id
	btnAceptF:removeEventListener( 'tap', sendDealsFriend )
	btnAceptF:addEventListener( 'tap', sendDealsFriend )

	return true
end

--se hace la peticion para compartir el deals
function sendDealsFriend( event )
	
	native.setKeyboardFocus(nil)
	if event.target.id ~= 0 then
		RestManager.shareDealsByFace( event.target.id, idCoupon )
	else
		if txtSendEmail.text ~= "" then
			RestManager.shareDealsByEmail( txtSendEmail.text, idCoupon )
		else
			RestManager.shareDealsByEmail( " ", idCoupon )
		end
	end

	return true;
end

--evento que se dispara cuando se hace focus en el textField
function onTxtFocusFriend( event )
	
	if ( "began" == event.phase ) then
	
		xscv, yscv = scvFriends:getContentPosition()
	
		scvFriends:setScrollHeight(lastY + scvFriends.height - scvFriends.height/3)
		scvFriends:scrollToPosition{
			y =  -txtSendEmail.y + 30,
			time = 200
		}
		
		if event.target.text ~= "" then
		
			maxShape[previousFriend]:setFillColor( 1 )
			previousFriend =  event.target.num
			maxShape[event.target.num]:setFillColor( .80 )
			
			btnAceptF.alpha = 1
			btnAceptF.id = 0
			btnAceptF:removeEventListener( 'tap', sendDealsFriend )
			btnAceptF:addEventListener( 'tap', sendDealsFriend )
		
		end
		
		
	elseif ( "submitted" == event.phase ) then
		native.setKeyboardFocus(nil)
		
		if lockInput == 0 then
			lockInput = 1
			if txtSendEmail.text ~= "" then
				RestManager.shareDealsByEmail( txtSendEmail.text, idCoupon )
			else
				RestManager.shareDealsByEmail( " ", idCoupon )
			end
		end
		
	elseif ( event.phase == "editing" ) then
	
		if event.target.text ~= " " then
		
			maxShape[previousFriend]:setFillColor( 1 )
			previousFriend =  event.target.num
			maxShape[event.target.num]:setFillColor( .80 )
			
			btnAceptF.alpha = 1
			btnAceptF.id = 0
			btnAceptF:removeEventListener( 'tap', sendDealsFriend )
			btnAceptF:addEventListener( 'tap', sendDealsFriend )
		
		end
		
	elseif( "ended" == event.phase ) then
		scvFriends:setScrollHeight(lastY)
		scvFriends:scrollToPosition{
			y =  yscv,
			time = 200
	}
	
	end
	
end

--evento que se dispara cuando se usa el scrollView
--esconde y muestra el textField
function ScrollListenerFriends( event )

	local phase = event.phase

    if "began" == phase then
        
    elseif "moved" == phase then
        
		local xx, yy = event.target:getContentPosition()
		
		event.target:getContentPosition()
		
		if txtSendEmail then
			local pointMail = scvFriends.height - txtSendEmail.y - 14
		end
		
    elseif "ended" == phase then
	
		local xx, yy = event.target:getContentPosition()
		
		if txtSendEmail then
			local pointMail = scvFriends.height - txtSendEmail.y - 14
		end
		
    end
	

    return true
	
end

--obtenemos las fotos del perfil
function loadImageFriend(items)

	local sizeAvatar = 'width=70&height=70'
	
	-- Determinamos si la imagen existe
    local path = system.pathForFile( "avatarFriend" .. items.id, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
		--if elements[obj.posc].callback == Globals.noCallbackGlobal then
			friendList(items)
		--end
    else
        -- Listener de la carga de la imagen del servidor
        local function networkListenerFBFriend( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
                event.target.alpha = 0
				
				--if elements[obj.posc].callback == Globals.noCallbackGlobal then
					
					friendList(items)	
						
				--end
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( "http://graph.facebook.com/".. items.id .."/picture?type=large&"..sizeAvatar, 
					"GET", networkListenerFBFriend, "avatarFriend"..items.id, system.TemporaryDirectory )
    end
	
end

--pinta la lista de amigos
function friendList(items)

	local contLF = #maxShape + 1
    
    local lineSeparator = display.newRect( 200, lastY, 400, 74 )
	lineSeparator:setFillColor( .5 )
    lineSeparator.alpha = .1
	groupFriendsList:insert( lineSeparator )
	lineSeparator:toFront()

	maxShape[contLF] = display.newRect( 200, lastY, 400, 80 )
	maxShape[contLF].id = items.id
	maxShape[contLF].name = items.name
	maxShape[contLF].num = contLF
	groupFriendsList:insert( maxShape[contLF] )
	maxShape[contLF]:toBack()
	maxShape[contLF]:addEventListener( 'tap', selectFriend)
    
    local logoFace = display.newImage( "img/btn/logoFace.png" )
	logoFace:translate( 110, lastY )
	groupFriendsList:insert(logoFace)
	
	local txtNameFriend = display.newText({
		text = items.name,     
		x = 270, y = lastY,
		width = 270,
		height = 28,
		font = "Lato-Regular", fontSize = 24, align = "left"
	})
	txtNameFriend:setFillColor( 0 )
    groupFriendsList:insert(txtNameFriend)
	
	local avatar = display.newImage("avatarFriend"..items.id, system.TemporaryDirectory )
	avatar.x = 40
	avatar.y = lastY
	avatar.width = 70
	avatar.height  = 70
	groupFriendsList:insert(avatar)
	
	
	
	lastY = lastY + 80
	
	if contFriendlist == contLF then
	
		printTextFriend()
	
	end

end

--pinta el textFriend al final de la lista
function printTextFriend()

	local contLF = #maxShape + 1

	maxShape[contLF] = display.newRect( 200, lastY, 400, 80 )
    maxShape[contLF].num = contLF
	groupFriendsList:insert( maxShape[contLF] )
	maxShape[contLF]:toBack()
	
	lastY = lastY + 50
	
	local lineSeparator = display.newRect( 200, lastY, 400, 1)
	lineSeparator:setFillColor( 0 )
	groupFriendsList:insert( lineSeparator )
	lineSeparator:toFront()
	
	bgEmailFriend = display.newImage( "img/btn/email.png" )
    bgEmailFriend:translate(200, lastY - 40 )
	bgEmailFriend.width = 360
	groupFriendsList:insert( bgEmailFriend )
	
	txtSendEmail = native.newTextField( 225, lastY - 40, 300, 60 )
    txtSendEmail.method = "sendEmail"
    txtSendEmail.inputType = "email"
	txtSendEmail.placeholder = "Correo del amigo"
    txtSendEmail.hasBackground = false
	txtSendEmail:setReturnKey(  "send"  )
	txtSendEmail.num = contLF
	txtSendEmail:addEventListener( "userInput", onTxtFocusFriend )
	groupFriendsList:insert(txtSendEmail)
	txtSendEmail.font = native.newFont( native.systemFont, 22 )
	
	if txtSendEmail.y > scvFriends.height then
		txtSendEmail.x = intW * 2
	end
	
end