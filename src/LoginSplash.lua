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
local facebook = require( "facebook" )
local json = require("json")
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

local sshots = {}
local circles = {}
local btnLoginS = {}
local propertiesBtn = {}
local subFig = ""
local subLang = ""
local direction = 0
local idxScr = 1
local wScrPhone = 300
local wFixScr = 1.25
local lblTitle1, lblTitle2, lblTitle3
local lblTitle4, lblTitle5, lblTitle6
local bgSplash1, bgSplash2, bgPhone, grpScreens

local setting = DBManager.getSettings()
Globals.language = require('src.resources.Language')
if setting.language == "es" then
	Globals.language = Globals.language.es
else
    print(subLang)
    subLang = "En"
	Globals.language = Globals.language.en
end


---------------------------------------------------------------------------------
-- FUNCTIONS
---------------------------------------------------------------------------------
function gotoHome()
    Globals.isReadOnly = false
    storyboard.removeScene( "src.Home" )
    storyboard.gotoScene( "src.Home", { time = 400, effect = "crossFade" })
end

function toLoginUserName(event)
    Globals.isReadOnly = false
    storyboard.removeScene( "src.LoginUserName" )
    storyboard.gotoScene( "src.LoginUserName", { time = 400, effect = "crossFade" })
end

function toLoginFree()
    Globals.isReadOnly = true
    storyboard.removeScene( "src.Home" )
    storyboard.gotoScene( "src.Home", { time = 400, effect = "crossFade" })
end

function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end


function facebookListener( event )
    if ( "session" == event.type ) then
        if ( "login" == event.phase ) then
            local params = { fields = "birthday, email,name,id" }
            facebook.request( "me", "GET", params )
        end
    elseif ( "request" == event.type ) then
        local response = json.decode( event.response )
        local email, birthday, mac = '-', '-', '-'
        if response.email then
            email = response.email
        end
        if response.birthday then
            local t = {}
            for mo, da, ye in string.gmatch( response.birthday, "(%w+)/(%w+)/(%w+)" ) do
                t[1] = mo
                t[2] = da
                t[3] = ye
            end
            birthday = t[3] .. "-" .. t[1] .. "-" .. t[2] .. " " .. "00:00:00"
            birthday = response.email
        end
        RestManager.createUser(email, ' ', response.name, response.id, birthday, mac)
    end
end
function loginFB()
    facebook.login( "750089858383563", facebookListener, {"public_profile", "email", "user_birthday"} )
end

-- Listener Touch Screen
function touchScreen(event)
    if event.phase == "began" then
        direction = 0
    elseif event.phase == "moved" then
        local x = (event.x - event.xStart)
        if direction == 0 then
            if x < -10 and idxScr < 7 then
                direction = 1
            elseif x > 10 and idxScr > 1 then
                direction = -1
            end
            -- Stop&Hide button show
            transition.cancel( "transButton" )
            for z = 1, #btnLoginS do
                if btnLoginS[z].alpha > 0 then 
                    btnLoginS[z].alpha = 0  
                    btnLoginS[z].width = 2
                    btnLoginS[z].height = 2
                end
            end
        elseif direction == 1 then
            -- Mover pantalla
            if x < 0 and x > -240 then
                if idxScr == 1 then
                    bgSplash1.x = (x * 2)
                    grpScreens.x = (x * 2) + intW
                elseif idxScr < 7 then
                    sshots[idxScr].x = midW + (x * wFixScr)
                    sshots[idxScr + 1].x = (midW + wScrPhone) + (x * wFixScr)
                end
            end
        elseif direction == -1 then
            if x > 0 and x < 240 then
                if idxScr == 2 then
                    bgSplash1.x = -intW + (x * 2)
                    grpScreens.x = (x * 2)
                elseif idxScr > 2 then
                    sshots[idxScr].x = midW + (x * wFixScr)
                    sshots[idxScr - 1].x = (midW - wScrPhone) + (x * wFixScr)
                end
            end
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        local x = (event.x - event.xStart)
        -- Init Screen to Phone Screens
        if direction == 1 and idxScr == 1 then
            if x > -150 then 
                -- Cancel
                transition.to( bgSplash1, { x = 0, time = 200 })
                transition.to( grpScreens, { x = intW, time = 200 })
            else 
                -- Do
                transition.to( bgSplash1, { x = -intW, time = 200 })
                transition.to( grpScreens, { x = 0, time = 200 })
                newScr(2)
            end
        end
        -- Phone Screens to Init Screen
        if direction == -1 and idxScr == 2 then
            if x < 150 then 
                -- Cancel
                transition.to( bgSplash1, { x = -intW, time = 200 })
                transition.to( grpScreens, { x = 0, time = 200 })
            else 
                -- Do
                transition.to( bgSplash1, { x = 0, time = 200 })
                transition.to( grpScreens, { x = intW, time = 200 })
                newScr(1)
            end
        end
         -- Inter Screens rigth to left
        if direction == 1 and idxScr > 1 then
            if x > -150 then 
                -- Cancel
                transition.to( sshots[idxScr], { x = midW, time = 200 })
                transition.to( sshots[idxScr+1], { x = midW + wScrPhone, time = 200 })
            else 
                -- Do
                transition.to( sshots[idxScr], { x = midW - wScrPhone, time = 200 })
                transition.to( sshots[idxScr+1], { x = midW, time = 200 })
                newScr(idxScr+1)
            end
        end
         -- Inter Screens left to rigth
        if direction == -1 and idxScr > 2 then
            if x < 150 then 
                -- Cancel
                transition.to( sshots[idxScr], { x = midW, time = 200 })
                transition.to( sshots[idxScr-1], { x = midW + wScrPhone, time = 200 })
            else 
                -- Do
                transition.to( sshots[idxScr], { x = midW + wScrPhone, time = 200 })
                transition.to( sshots[idxScr-1], { x = midW, time = 200 })
                newScr(idxScr-1)
            end
        end
        -- Show buttons
        if idxScr > 2 and idxScr < 6 then
            transition.to( btnLoginS[idxScr-2], { alpha = 1, width = propertiesBtn[idxScr-2].w, 
                    height = propertiesBtn[idxScr-2].h, time = 400, delay = 200, tag="transButton" })
        end
    end
end

function newScr(idx)
    idxScr = idx
    direction = 0
    circles[idx]:setFillColor( 75/255, 176/255, 217/255 )
    if idx > 1 then
        circles[idx-1]:setFillColor( 182/255, 207/255, 229/255 )
    end
    if idx < 7 then
        circles[idx+1]:setFillColor( 182/255, 207/255, 229/255 )
    end
    
    -- Changes titles
    if idx == 4 then
        lblTitle1.alpha = 1
        lblTitle2.alpha = 1
        lblTitle3.alpha = 1
        lblTitle4.alpha = 0
        lblTitle5.alpha = 0
        lblTitle6.alpha = 0
    elseif idx == 5 or idx == 6 then
        lblTitle1.alpha = 0
        lblTitle2.alpha = 0
        lblTitle3.alpha = 0
        lblTitle4.alpha = 1
        lblTitle5.alpha = 1
        lblTitle6.alpha = 1
        lblTitle4.text = Globals.language.loginTitle4B
        lblTitle5.text = Globals.language.loginTitle5B 
        lblTitle6.text = Globals.language.loginTitle6B
    elseif idx == 7 then
        lblTitle4.text = Globals.language.loginTitle4C
        lblTitle5.text = Globals.language.loginTitle5C 
        lblTitle6.text = Globals.language.loginTitle6c
    end
end


---------------------------------------------------------------------------------
-- OVERRIDING SCENES METHODS
--------------------------------------------------------------- ------------------
-- Called when the scene's view does not exist:
function scene:createScene( event )

    -- Agregamos el home
	screen = self.view
    
    local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 1 )
	screen:insert(bg)
    
    local posYBg = intH - 200
    propertiesBtn = {
        {x = midW + 100, y = posYBg - 180, w = 180, h = 111},
        {x = midW + 68, y = posYBg - 100, w = 161, h = 101},
        {x = midW - 30, y = posYBg - 170, w = 150, h = 163}
    }
    if (intH > 854) then
        posYBg = 654
    elseif (intH < 710) then
        subFig = "XMin"
        wScrPhone = 182
        wFixScr = .76
        propertiesBtn = {
            {x = midW + 60, y = posYBg - 105, w = 100, h = 61},
            {x = midW + 35, y = posYBg - 55, w = 128, h = 80},
            {x = midW - 15, y = posYBg - 95, w = 101, h = 110}
        }
    elseif (intH < 820) then
        subFig = "Min"
        wScrPhone = 230
        wFixScr = .97
        propertiesBtn = {
            {x = midW + 80, y = posYBg - 135, w = 126, h = 77},
            {x = midW + 45, y = posYBg - 70, w = 161, h = 101},
            {x = midW - 15, y = posYBg - 120, w = 127, h = 138}
        }
    end
    
    bgSplash1 = display.newImage("img/bgk/loginSplash01"..subLang..".png", true) 
	bgSplash1.anchorX = 0
    bgSplash1.x = 0
    bgSplash1.anchorY  = 1
    bgSplash1.y = posYBg
    screen:insert(bgSplash1)
    
    grpScreens = display.newGroup()
    grpScreens.x = intW
	screen:insert(grpScreens)
    
    -- screens
    for i = 2, 7 do
        sshots[i] = display.newImage("img/bgk/screen"..i..subFig..subLang..".png", true) 
        sshots[i].x = midW + 300
        sshots[i].anchorY  = 1
        sshots[i].y = posYBg
        grpScreens:insert(sshots[i])
    end
    sshots[2].x = midW
    
    bgSplash2 = display.newImage("img/bgk/bgPhone"..subFig..".png", true) 
    bgSplash2.x = midW
    bgSplash2.anchorY = 1
    bgSplash2.y = posYBg
    grpScreens:insert(bgSplash2)
    
    -- Title
    lblTitle1 = display.newText( {
        text = Globals.language.loginTitle1A,
        x = midW, y = 50,
        font = "Lato-Regular",  
        fontSize = 20, align = "center"
    })
    lblTitle1:setFillColor( 1 )
    grpScreens:insert(lblTitle1)
    lblTitle2 = display.newText( {
        text = Globals.language.loginTitle2A,
        x = midW, y = 72,
        font = "Lato-Regular",  
        fontSize = 20, align = "center"
    })
    lblTitle2:setFillColor( 1 )
    grpScreens:insert(lblTitle2)
    lblTitle3 = display.newText( {
        text = Globals.language.loginTitle3A,
        x = midW, y = 100,
        font = "Lato-Heavy",  
        fontSize = 21, align = "center"
    })
    lblTitle3:setFillColor( 1 )
    grpScreens:insert(lblTitle3)
    
    -- Title
    lblTitle4 = display.newText( {
        text = Globals.language.loginTitle4B,
        x = midW, y = 50,
        font = "Lato-Regular",  
        fontSize = 14, align = "center"
    })
    lblTitle4:setFillColor( 1 )
    lblTitle4.alpha = 0
    grpScreens:insert(lblTitle4)
    lblTitle5 = display.newText( {
        text = Globals.language.loginTitle5B,
        x = midW, y = 72,
        font = "Lato-Regular",  
        fontSize = 14, align = "center"
    })
    lblTitle5:setFillColor( 1 )
    lblTitle5.alpha = 0
    grpScreens:insert(lblTitle5)
    lblTitle6 = display.newText( {
        text = Globals.language.loginTitle6B,
        x = midW, y = 94,
        font = "Lato-Regular",  
        fontSize = 14, align = "center"
    })
    lblTitle6:setFillColor( 1 )
    lblTitle6.alpha = 0
    grpScreens:insert(lblTitle6)
    
    -- Btns Show
    for i = 1, 3 do
        btnLoginS[i] = display.newImage("img/btn/btnLoginS"..i..subLang..".png", true) 
        btnLoginS[i].x = propertiesBtn[i].x
        btnLoginS[i].y = propertiesBtn[i].y
        btnLoginS[i].height = 2
        btnLoginS[i].width = 2
        btnLoginS[i].alpha = 0
        grpScreens:insert(btnLoginS[i])
    end
    
    
    -- Circles position
    for i = 1, 7 do
        circles[i] = display.newRoundedRect( 140 + (i * 25), posYBg + 27, 15, 15, 8 )
        circles[i]:setFillColor( 182/255, 207/255, 229/255 )
        screen:insert(circles[i])
    end
    circles[1]:setFillColor( 75/255, 176/255, 217/255 )
    
    -- Recalculate position
    if (intH > 854) then
        xtra = intH - (posYBg+200)
        if xtra > 0 then
            posYBg = posYBg + (xtra/4)
        end
    end
    
    -- Btn FB
    local btnShadow = display.newImage("img/btn/bgShadow.png", true) 
    btnShadow.x = midW
    btnShadow.y = posYBg + 115
    screen:insert(btnShadow)
    
    local bgBtn = display.newRoundedRect( midW, posYBg + 85, 350, 70, 10 )
	bgBtn:setFillColor( 0, 51/255, 86/255 )
	screen:insert(bgBtn)
    
    local btn = display.newRoundedRect( midW, posYBg + 83, 350, 65, 10 )
	btn:setFillColor( 0, 109/255, 175/255 )
    btn:addEventListener( "tap", loginFB )
	screen:insert(btn)
    
    local lblBtn = display.newText( {
        text = Globals.language.loginBtnFB,
        x = midW, y = posYBg + 85,
        font = "Lato-Heavy",  
        fontSize = 20, align = "center"
    })
	lblBtn:setFillColor( 1 )
    screen:insert(lblBtn)
    
    -- User / Email
    local bgBtnUserName = display.newRect( 140, posYBg + 164, 160, 50 )
	bgBtnUserName:setFillColor( 1 )
    bgBtnUserName.alpha = .01
    bgBtnUserName:addEventListener( "tap", toLoginUserName )
	screen:insert(bgBtnUserName)
    
    local lblBottom = display.newText( {
        text = Globals.language.loginBtnEmail,
        x = 140, y = posYBg + 164,
        font = "Lato-Heavy",  
        width = 160,
        fontSize = 14, align = "center"
    })
    lblBottom:setFillColor( .2 )
    screen:insert(lblBottom)
    
    local lineSep = display.newRect( midW, posYBg + 164, 2, 20 )
	lineSep:setFillColor( .6 )
	screen:insert(lineSep)
    
    -- Recorrido
    local bgBtnFree = display.newRect( 340, posYBg + 164, 160, 50 )
	bgBtnFree:setFillColor( 1 )
    bgBtnFree.alpha = .01
    bgBtnFree:addEventListener( "tap", toLoginFree )
	screen:insert(bgBtnFree)
    
    local lblFree = display.newText( {
        text = Globals.language.loginBtnFree,
        x = 340, y = posYBg + 164,
        font = "Lato-Heavy",  
        width = 160,
        fontSize = 14, align = "center"
    })
    lblFree:setFillColor( .2 )
    screen:insert(lblFree)
    
    -- Touch Listener
    screen:addEventListener( "touch", touchScreen )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
end

-- Remove Listener
function scene:exitScene( event )
    screen:removeEventListener( "touch", touchScreen )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

    
return scene

