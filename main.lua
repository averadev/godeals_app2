---------------------------------------------------------------------------------
-- Godeals App
-- Alberto Vera
-- GeekBucket Software Factory
---------------------------------------------------------------------------------
local launchArgs = ...      -- at the top of your program code
display.setStatusBar( display.DarkStatusBar )

local storyboard = require "storyboard"
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

local redimirObj;
local platformName = system.getInfo( "platformName" )
if platformName == "iPhone OS" then
	redimirObj = require( "plugin.redimir" )
end


local isUser = DBManager.setupSquema()
------------------------ Delete before deploy
--DBManager.updateUser(1, "mrfeto@gmail.com", '', 'Alberto Vera', '10152713865899218', '') -- Temporal
--DBManager.updateUser(1, "conomia_alfredo@hotmail.com", '', 'Alfredo chi Zum', '100001525033547', '')

-- isUser = true
------------------------

-- Verify is Beacon
local partnerId = 0
local function isBeacon(args)
    if args.androidIntent then
        if args.androidIntent.extras then
            local optsExtras = args.androidIntent.extras
            if optsExtras.type then
                if optsExtras.type == "beacon" then
                    -- Send Alert
                    local typeTxt = "StartApp"
                    if args.type then typeTxt = args.type end
                    
                    if optsExtras.partnerId then
                        partnerId = optsExtras.partnerId
                        storyboard.gotoScene("src.Partner", {params = { idPartner = partnerId }})
                    end
                    
                    if optsExtras.adId then
                        adId = optsExtras.adId
                        storyboard.gotoScene("src.WelcomePartner", {params = { idAd = adId }})
                    end
                    
                end
            end
        end
    end
end
if launchArgs then 
    isBeacon(launchArgs)
end
-- Verify on App running
local function onSystemEvent(event)
	if (event.type == "applicationOpen") then
		isBeacon(event)
	end
end
Runtime:addEventListener("system", onSystemEvent) 


if redimirObj then
    local function listenerBconIOS( event )
        listenerBeaconIOS(event)
    end
    redimirObj.init( listenerBconIOS )
end

if platformName == "iPhone OS" and isUser then
    local lealtad = DBManager.lealtad()
    for y = 1, #lealtad, 1 do 
        RestManager.lealtad(idUser, lealtad[y].major, lealtad[y].fecha)
    end
end

if partnerId > 0 then
    -- Do nothing
elseif isUser then
	storyboard.gotoScene("src.Home")
else
    storyboard.gotoScene("src.Login")
end
