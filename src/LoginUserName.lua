---------------------------------------------------------------------------------
-- Godeals App
-- Alberto Vera
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- REQUIRE & VARIABLES
---------------------------------------------------------------------------------
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY
local hBar = display.topStatusBarContentHeight
local imgLogo, groupSign, groupCreate
local txtSignEmail, txtSignPass, txtCreateEmail, txtCreatePass, txtCreateRePass

local setting = DBManager.getSettings()
Globals.language = require('src.resources.Language')
if setting.language == "es" then
	Globals.language = Globals.language.es
else
	Globals.language = Globals.language.en
end


---------------------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------------------
-- Ajusta el contenido al mostrarse el teclado 
function onTxtFocus(event)
    if ( "began" == event.phase ) then
        -- Interfaz Sign In
        if groupSign.x == 0 and groupSign.y == 0 then
            transition.to( imgLogo, { y = 60 + hBar, time = 400, transition = easing.outExpo } )
            transition.to( groupSign, { y = (-midH + 200) + hBar, time = 400, transition = easing.outExpo } )
        -- Interfaz Create
        elseif groupCreate.x == 0 and groupCreate.y == 0 then
            transition.to( imgLogo, { y = 60 + hBar, time = 400, transition = easing.outExpo } )
            transition.to( groupCreate, { y = (-midH + 225) + hBar, time = 400, transition = easing.outExpo } )
        end
    elseif ( "submitted" == event.phase ) then
        -- Hide Keyboard
        native.setKeyboardFocus(nil)
        if event.target.method == "create" then
            doCreate()
        else
            doSignIn()
        end
    end
end

function gotoHome()
    storyboard.removeScene( "src.Home" )
	storyboard.gotoScene( "src.Home", { time = 400, effect = "crossFade" })
end

function getReturnSplash(event)
    storyboard.removeScene( "src.LoginSplash" )
    storyboard.gotoScene( "src.LoginSplash", { time = 400, effect = "crossFade" })
end 

function showCreate()
    backTxtPositions()
    transition.to( groupSign, { x = -480, time = 400, transition = easing.outExpo } )
    transition.to( groupCreate, { x = 0, time = 400, transition = easing.outExpo } )
end

function hideCreate()
    backTxtPositions()
    transition.to( groupSign, { x = 0, time = 400, transition = easing.outExpo } )
    transition.to( groupCreate, { x = 480, time = 400, transition = easing.outExpo } )
end

function networkConnectionL()
    local netConn = require('socket').connect('www.google.com', 80)
    if netConn == nil then
        native.showAlert( "Go Deals", Globals.language.loginNoNetworkConnection, { "OK"})
        return false
    end
    netConn:close()
    return true
end

function doCreate()
    if txtCreateEmail.text == '' or txtCreatePass.text == '' or txtCreateRePass.text == '' then
        native.showAlert( "Go Deals", Globals.language.loginCreateAlert1, { "OK"})
    elseif not (txtCreatePass.text == txtCreateRePass.text) then
        native.showAlert( "Go Deals", Globals.language.loginCreateAlert2, { "OK"})
    elseif networkConnectionL() then
        backTxtPositions()
		local mac = ""
		if getBeacon then
			local macAd = getBeacon.getMacAddress()
			mac = crypto.digest( crypto.md5, macAd )
		end
        RestManager.createUser(txtCreateEmail.text, txtCreatePass.text, ' ', ' ', ' ', mac)
    end
end

function doSignIn()
    if txtSignEmail.text == '' or txtSignPass.text == '' then
        native.showAlert( "Go Deals", Globals.language.loginSignInAlert, { "OK"})
    elseif networkConnectionL() then
       -- showLoadLogin()
        backTxtPositions()
		local mac = ""
		if getBeacon then
			local macAd = getBeacon.getMacAddress()
			mac = crypto.digest( crypto.md5, macAd )
		end
        RestManager.validateUser(txtSignEmail.text, txtSignPass.text, mac)
    end 
end

function backTxtPositions()
    -- Hide Keyboard
    native.setKeyboardFocus(nil)
    -- Interfaz Sign In
    if groupSign.x == 0 and groupSign.y < 0 then
        transition.to( imgLogo, { y = midH / 2, time = 400, transition = easing.outExpo } )
        transition.to( groupSign, { y = 0, time = 400, transition = easing.outExpo } )
    -- Interfaz Create
    elseif groupCreate.x == 0 and groupCreate.y < 0 then
        transition.to( imgLogo, { y = midH / 2, time = 400, transition = easing.outExpo } )
        transition.to( groupCreate, { y = 0, time = 400, transition = easing.outExpo } )
    end
end


---------------------------------------------------------------------------------
-- OVERRIDING SCENES METHODS
--------------------------------------------------------------- ------------------
-- Called when the scene's view does not exist:
function scene:createScene( event )

    -- Agregamos el home
	screen = self.view
    
    -- Background
    local background = display.newImage("img/bgk/bgLoginUserName.jpg", true) 
	background.x = midW
	background.y = midH
    screen:insert(background)
    if background.height < intH then
        local xVar = intH / background.height
        background.height = background.height * xVar
        background.width = background.width * xVar
    end
    
    imgLogo = display.newImage("img/btn/logoLoginUser.png", true) 
	imgLogo.x = midW
	imgLogo.y = midH / 2
	screen:insert(imgLogo)
    
    -- Groups
    groupSign = display.newGroup()
	screen:insert(groupSign)
    groupCreate = display.newGroup()
	screen:insert(groupCreate)

    -- Bg TextFields
    local bgSignEmail = display.newImage("img/btn/usuario.png", true) 
    bgSignEmail.x = midW
    bgSignEmail.y = midH - 45
    groupSign:insert(bgSignEmail)
    local bgSignPass = display.newImage("img/btn/contrasenia.png", true) 
    bgSignPass.x = midW
    bgSignPass.y = midH + 45
    groupSign:insert(bgSignPass)
    
    -- TextFields Sign In
    txtSignEmail = native.newTextField( midW + 25, midH - 45, 300, 45 )
    txtSignEmail.size = 24
    txtSignEmail.method = "signin"
    txtSignEmail.inputType = "email"
    txtSignEmail.hasBackground = false
    txtSignEmail.placeholder = Globals.language.loginDescUsername
    txtSignEmail:addEventListener( "userInput", onTxtFocus )
	groupSign:insert(txtSignEmail)
    txtSignPass = native.newTextField( midW + 25, midH + 45, 300, 45 )
    txtSignPass.size = 24
    txtSignPass.method = "signin"
    txtSignPass.isSecure = true
    txtSignPass.hasBackground = false
    txtSignPass.placeholder = Globals.language.loginDescPasword
    txtSignPass:addEventListener( "userInput", onTxtFocus )
	groupSign:insert(txtSignPass)
    
    local bgBtn = display.newRoundedRect( midW, midH + 130, 350, 55, 10 )
	bgBtn:setFillColor( 0, 51/255, 86/255 )
	groupSign:insert(bgBtn)
    local btn = display.newRoundedRect( midW, midH + 130, 345, 50, 10 )
	btn:setFillColor( 0, 109/255, 175/255 )
    btn:addEventListener( "tap", doSignIn )
	groupSign:insert(btn)
    
    local txtDoSignIn = display.newText( {
        text = Globals.language.loginTxtDoSignIn,
        x = midW, y = midH + 130,
        font = "Lato",  fontSize = 28, align = "center"
    })
    groupSign:insert(txtDoSignIn)
    
    local btnDoReturn = display.newRoundedRect( midW - 125, midH + 205, 170, 55, 20 )
	btnDoReturn:setFillColor( 0, 51/255, 86/255 )
    btnDoReturn.alpha = .3
    btnDoReturn:addEventListener( "tap", getReturnSplash )
	groupSign:insert(btnDoReturn)
    local txtDoReturn = display.newText( {
        text = Globals.language.loginTxtReturn1,
        x = midW - 70, y = midH + 205, width = 200,
        font = "Lato",  fontSize = 22, align = "left"
    })
    groupSign:insert(txtDoReturn)
    
    local btnDoCreateIt = display.newRoundedRect( midW + 105, midH + 205, 170, 55, 20 )
	btnDoCreateIt:setFillColor( 0, 51/255, 86/255 )
    btnDoCreateIt.alpha = .3
    btnDoCreateIt:addEventListener( "tap", showCreate )
	groupSign:insert(btnDoCreateIt)
    local txtDoCreateIt = display.newText( {
        text = Globals.language.loginTxtCreate,
        x = midW + 70, y = midH + 205, width = 200,
        font = "Lato",  fontSize = 22, align = "right"
    })
    groupSign:insert(txtDoCreateIt)
        
    -- Bg TextFields
    local bgCreateEmail = display.newImage("img/btn/usuario.png", true) 
    bgCreateEmail.x = midW
    bgCreateEmail.y = midH - 75
    groupCreate:insert(bgCreateEmail)
    local bgCreatePass = display.newImage("img/btn/contrasenia.png", true) 
    bgCreatePass.x = midW
    bgCreatePass.y = midH + 05
    groupCreate:insert(bgCreatePass)
    local bgCreateRePass = display.newImage("img/btn/contrasenia.png", true) 
    bgCreateRePass.x = midW
    bgCreateRePass.y = midH + 85
    groupCreate:insert(bgCreateRePass)
    
    -- TextFields Create
    txtCreateEmail = native.newTextField( midW + 25, midH - 75, 300, 45 )
    txtCreateEmail.size = 24
    txtCreateEmail.method = "create"
    txtCreateEmail.inputType = "email"
    txtCreateEmail.hasBackground = false
    txtCreateEmail.placeholder = Globals.language.loginDescUsername
	groupCreate:insert(txtCreateEmail)
    txtCreateEmail:addEventListener( "userInput", onTxtFocus )
    txtCreatePass = native.newTextField( midW + 25, midH + 05, 300, 45 )
    txtCreatePass.size = 24
    txtCreatePass.method = "create"
    txtCreatePass.isSecure = true
    txtCreatePass.hasBackground = false
    txtCreatePass.placeholder = Globals.language.loginDescPasword
	groupCreate:insert(txtCreatePass)
    txtCreatePass:addEventListener( "userInput", onTxtFocus )
    txtCreateRePass = native.newTextField( midW + 25, midH + 85, 300, 45 )
    txtCreateRePass.size = 24
    txtCreateRePass.method = "create"
    txtCreateRePass.isSecure = true
    txtCreateRePass.hasBackground = false
    txtCreateRePass.placeholder = Globals.language.loginDescPasword
	groupCreate:insert(txtCreateRePass)
    txtCreateRePass:addEventListener( "userInput", onTxtFocus )
    
    local bgBtn2 = display.newRoundedRect( midW, midH + 170, 350, 55, 10 )
	bgBtn2:setFillColor( 0, 51/255, 86/255 )
	groupCreate:insert(bgBtn2)
    local btn2 = display.newRoundedRect( midW, midH + 170, 345, 50, 10 )
	btn2:setFillColor( 0, 109/255, 175/255 )
    btn2:addEventListener( "tap", doCreate )
	groupCreate:insert(btn2)
    
    local txtDoSignIn2 = display.newText( {
        text = Globals.language.loginTxtDoCreate,
        x = midW, y = midH + 170,
        font = "Lato",  fontSize = 28, align = "center"
    })
    groupCreate:insert(txtDoSignIn2)
    
    local btnDoReturn2 = display.newRoundedRect( midW - 125, midH + 245, 170, 55, 20 )
	btnDoReturn2:setFillColor( 0, 51/255, 86/255 )
    btnDoReturn2.alpha = .3
    btnDoReturn2:addEventListener( "tap", hideCreate )
	groupCreate:insert(btnDoReturn2)
    local txtDoReturn2 = display.newText( {
        text = Globals.language.loginTxtReturn1,
        x = midW - 70, y = midH + 245, width = 200,
        font = "Lato",  fontSize = 22, align = "left"
    })
    groupCreate:insert(txtDoReturn2)
    
    groupCreate.x = 480
    
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
end

-- Remove Escene Objects
function scene:exitScene( event )
    if txtSignEmail then
        txtSignEmail:removeSelf()
        txtSignEmail = nil
    end
    if txtSignPass then
        txtSignPass:removeSelf()
        txtSignPass = nil
    end
    if txtCreateEmail then
        txtCreateEmail:removeSelf()
        txtCreateEmail = nil
    end
    if txtCreatePass then
        txtCreatePass:removeSelf()
        txtCreatePass = nil
    end
    if txtCreateRePass then
        txtCreateRePass:removeSelf()
        txtCreateRePass = nil
    end
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

    
return scene

