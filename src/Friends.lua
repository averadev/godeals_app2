
local json = require("json")
local facebook = require( "facebook" )
local RestManager = require('src.resources.RestManager')
local DBManager = require('src.resources.DBManager')
local Globals = require('src.resources.Globals')
local widget = require( "widget" )
require('src.BuildRow')

--variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentWidth / 2
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
local scvFriends, grpFList, iconCheckFB
local groupFriends, btnAceptF, btnAceptFB
local maxShape = {}
local txtIsNotFriends


--muestra el modal con la lista de amigos
function showListFriends(idC)

	idCoupon = idC
    groupFriends = display.newGroup()

	local bgFriend = display.newRect( display.contentCenterX, display.contentCenterY + h, intW, intH)
    bgFriend:setFillColor( 0 )
    bgFriend.alpha = .5
    groupFriends:insert(bgFriend)
	bgFriend:addEventListener( "tap", NoCloseFB )
    
    local bgModal = display.newRoundedRect( midW, midH, 400, 500, 10 )
    bgModal:setFillColor( .9 )
    groupFriends:insert( bgModal )
    
    local bgBanner = display.newRoundedRect( midW, midH - 210, 400, 80, 10 )
    bgBanner:setFillColor( .2 )
    groupFriends:insert( bgBanner )
    
    local bgSearch = display.newRoundedRect( midW + 125, midH - 210, 150, 80, 10 )
    bgSearch:setFillColor( .2, .6, 0 )
	bgSearch:addEventListener( "tap", getFBFriends )
    groupFriends:insert( bgSearch )
    
    local bgBanner2 = display.newRect( midW + 60, midH - 210, 20, 80)
    bgBanner2:setFillColor( .2 )
    groupFriends:insert( bgBanner2 )
	
	local friendsTitle = display.newText( {
		text = "COMPARTIR DEAL CON:",     
		x = 210, y = midH - 215,
		width = 300,
		font = "Lato-Bold",  fontSize = 18
	})
	friendsTitle:setFillColor( 1 )
	groupFriends:insert(friendsTitle)
    
    local friendRefresh = display.newImage( "img/btn/iconUpdate.png" )
	friendRefresh:translate( 375, midH - 225 )
	groupFriends:insert(friendRefresh)
	
	local txtRefreshFriend = display.newText( {
		text = "Actualizar Amigos",     
		x = 375, y = midH - 195, width = 150,
		font = "Lato-Regular",  fontSize = 14, align = "center"
	})
	txtRefreshFriend:setFillColor( 1 )
	groupFriends:insert(txtRefreshFriend)
    
    local bgButtons = display.newRoundedRect( midW, midH + 205, 380, 70, 10 )
    bgButtons:setFillColor( 1 )
    groupFriends:insert( bgButtons )
	
	btnAceptF = display.newRoundedRect(335, midH + 205, 170, 45, 5)
	btnAceptF:setFillColor(8/255, 108/255, 160/255)
    btnAceptF.alpha = .5
	btnAceptF:addEventListener( "tap", shareToFriend )
	groupFriends:insert(btnAceptF)
    
    btnAceptFB = display.newRoundedRect( 335, midH + 217, 170, 20, 5 )
    btnAceptFB.alpha = 0
    btnAceptFB:setFillColor( {
        type = 'gradient',
        color1 = { 8/255, 108/255, 160/255 }, 
        color2 = { 0, 78/255, 130/255 },
        direction = "bottom"
    } ) 
	groupFriends:insert(btnAceptFB)
	
	local txtAceptF = display.newText( {
		text = "COMPARTIR DEAL",     
		x = 335, y = midH + 205,
		width = 200,
		font = "Lato-Bold",  fontSize = 14, align = "center"
	})
	txtAceptF:setFillColor( 1 )
	groupFriends:insert(txtAceptF)
	
	local btnCancelF = display.newRoundedRect(145, midH + 205, 170, 45, 5)
	btnCancelF:setFillColor(224/255, 16/255, 16/255)
	groupFriends:insert(btnCancelF)
	btnCancelF:addEventListener( "tap", closeListFB )
    
    local btnCancelFB = display.newRoundedRect( 145, midH + 217, 170, 20, 5 )
    btnCancelFB:setFillColor( {
        type = 'gradient',
        color1 = { 224/255, 16/255, 16/255 }, 
        color2 = { 184/255, 0/255, 0/255 },
        direction = "bottom"
    } ) 
	groupFriends:insert(btnCancelFB)
	
	local txtCancelF = display.newText( {
		text = "CANCELAR",     
		x = 145, y = midH + 205,
		width = 200,
		font = "Lato-Bold",  fontSize = 14, align = "center"
	})
	txtCancelF:setFillColor( 1 )
	groupFriends:insert(txtCancelF)
	
	scvFriends = widget.newScrollView
	{
		top = midH - 180,
		left = 40,
		width = 400,
		height = 350,
		listener = ScrollListenerFriends,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		isBounceEnabled = false,
		backgroundColor = { .9 }
	}
	groupFriends:insert(scvFriends)
    printFriends(DBManager.getFriends())

	return true;
end

-- Muestra los usuarios
function printFriends( items )
    if grpFList then
        grpFList:removeSelf()
        grpFList = nil
    end
    grpFList = display.newGroup()
	scvFriends:insert(grpFList)
    local listY = 40
    
    for i = 1, #items, 1 do
        local bgFriend = display.newRect( 200, listY, 400, 79)
        bgFriend.fbId = items[i].id
        bgFriend:setFillColor( 1 )
        grpFList:insert( bgFriend )
        bgFriend:addEventListener( "tap", selFBRow )
        
        local txtId = display.newText( {
            text = items[i].name,     
            x = 250, y = listY,
            width = 270,
            font = "Lato-Bold",  fontSize = 16, align = "left"
        })
        txtId:setFillColor( .2 )
        grpFList:insert(txtId)
        
        getFBImage(listY, items[i].id)
        listY = listY + 80 
    end
    
    iconCheckFB = display.newImage( "img/btn/iconReady.png" )
    iconCheckFB.fbId = nil
    iconCheckFB.alpha = 0
    iconCheckFB:translate( 370, 40 )
    grpFList:insert(iconCheckFB)
    
    listY = listY + 20
    local bgToMail = display.newRoundedRect( 200, listY, 360, 60, 5 )
    bgToMail:setFillColor( 1 )
    grpFList:insert( bgToMail )
    
    local iconEmail = display.newImage( "img/btn/iconEmail.png" )
	iconEmail:translate( 50, listY )
	grpFList:insert(iconEmail)
    
    txtSendEmail = native.newTextField( 220, listY, 300, 50 )
    txtSendEmail.inputType = "email"
	txtSendEmail.placeholder = "ENVIAR CORREO A UN AMIGO"
    txtSendEmail.hasBackground = false
	txtSendEmail:setReturnKey(  "send"  )
	txtSendEmail:addEventListener( "userInput", onTxtFriend )
	txtSendEmail.font = native.newFont( native.systemFont, 18 )
	grpFList:insert(txtSendEmail)
    
    scvFriends:setScrollHeight(listY + 50)
    
end

-- Selecciona registro
function selFBRow( event )
    t = event.target
    iconCheckFB.fbId = t.fbId
    iconCheckFB.y = t.y
    iconCheckFB.alpha = 1
    enablebButton(true)
end

-- Selecciona registro
function enablebButton( isEnabled )
    if isEnabled then
        btnAceptF.alpha = 1
        btnAceptFB.alpha = 1
    else
        btnAceptF.alpha = .5
        btnAceptFB.alpha = 0
    end
end

-- Compartir a Amigo
function shareToFriend( event )
    t = event.target
    if t.alpha == 1 then
        if iconCheckFB.fbId == nil then
            RestManager.shareDealsByEmail( txtSendEmail.text, idCoupon )
        else
            local idUser = iconCheckFB.fbId
            RestManager.shareDealsByFace( idUser, idCoupon )
        end
        -- Close window
        closeListFB()
        animateShareDeal()
        changeBtnShare()
    end
    
end


-- Obtiene las fotos de perfil
function getFBImage( posc, fbId )
    local sizeAvatar = 'width=70&height=70'
	
	-- Determinamos si la imagen existe
    local path = system.pathForFile( "avatarFriend" .. fbId, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
        if groupFriends then
            local avatar = display.newImage("avatarFriend"..fbId, system.TemporaryDirectory )
            avatar:translate( 50, posc)
            avatar.width = 70
            avatar.height  = 70
            grpFList:insert(avatar)
        end
    else
        -- Listener de la carga de la imagen del servidor
        local function networkListenerFBFriend( event )
            if ( event.isError ) then
            else
                if groupFriends then
                    event.target:translate( 50, posc)
                    grpFList:insert(event.target)
                else
                    event.target.alpha = 0
                end
            end
        end
        -- Descargamos de la nube
        display.loadRemoteImage( "http://graph.facebook.com/".. fbId .."/picture?type=large&"..sizeAvatar, 
					"GET", networkListenerFBFriend, "avatarFriend"..fbId, system.TemporaryDirectory )
    end
end

-- Obtiene los amigos
function getFBFriends(  )
    facebook.login( fbAppID, FBListener, {"public_profile", "email", "user_birthday", "user_friends"} )
end

function FBListener( event )
    if ( "session" == event.type ) then
        if ( "login" == event.phase ) then
			local params = { fields = "email,name,id" }
            facebook.request( "me/friends", "GET",params )
		elseif ( "loginCancelled" == event.phase) then
			
        end
    elseif ( "request" == event.type ) then
        if ( not event.isError ) then
            local response = json.decode( event.response )
            if #response.data > 0 then
                DBManager.saveFriends(response.data)
                printFriends(response.data)
            end
        end
    end
end

-- No cierra el modal de amigos
function NoCloseFB( event )
    return true;
end

-- Cierra el modal de amigos
function closeListFB( event )
	native.setKeyboardFocus(nil)
	groupFriends:removeSelf()
	groupFriends = nil
	idCoupon = 0
	return true;
end

-- Cierra el modal de amigos
function onTxtFriend( event )
	if ( "began" == event.phase ) then
		if event.target.text ~= "" then
            iconCheckFB.alpha = 0
            iconCheckFB.fbId = nil
            enablebButton(true)
		end
	elseif ( "submitted" == event.phase ) then
		native.setKeyboardFocus(nil)
		if event.target.text ~= "" then
            RestManager.shareDealsByEmail( txtSendEmail.text, idCoupon )
            -- Close window
            closeListFB()
            animateShareDeal()
            changeBtnShare()
		end
		
	elseif ( event.phase == "editing" ) then
	
		if event.target.text ~= "" then
            enablebButton(true)
		else
            enablebButton(false)  
		end
		
	elseif( "ended" == event.phase ) then
		
	end
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
	
	bgEmailFriend = display.newImage( "img/btn/txtEmail.png" )
    bgEmailFriend:translate(200, lastY - 43 )
	groupFriendsList:insert( bgEmailFriend )
	
	txtSendEmail = native.newTextField( 200, lastY - 40, 370, 60 )
    txtSendEmail.method = "sendEmail"
    txtSendEmail.inputType = "email"
	txtSendEmail.placeholder = "Enviar correo a un amigo"
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