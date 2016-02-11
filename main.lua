---------------------------------------------------------------------------------
-- Godeals App
-- Alberto Vera
-- GeekBucket Software Factory
---------------------------------------------------------------------------------
local launchArgs = ...      -- at the top of your program code
display.setStatusBar( display.DarkStatusBar )

local storyboard = require( "storyboard" )
local DBManager = require('src.resources.DBManager')
local Globals = require('src.resources.Globals')

local isUser = DBManager.setupSquema()
local OneSignal = require("plugin.OneSignal")

-------- BEGIN Verify is Beacon for Android --------
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
                        partnerId = optsExtras.adId
                        storyboard.gotoScene("src.PartnerWelcome", {params = { idAd = partnerId }})
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
    -- Validate Notification IOS
    if (event.type == "applicationStart" or event.type == "applicationResume") then
		local notif = DBManager.isNotification()
        if notif then
            native.setProperty( "applicationIconBadgeNumber", 0 )
            if notif.type == 1 then
                partnerId = notif.partnerId
                storyboard.gotoScene("src.Partner", {params = { idPartner = partnerId }})
            elseif notif.type == 2 then
                partnerId = notif.id
                storyboard.gotoScene("src.PartnerWelcome", {params = { idAd = partnerId }})
            end
        end
	end
end
Runtime:addEventListener("system", onSystemEvent) 
-------- END Verify is Beacon for Android --------


if redimirObj then
    local function listenerBconIOS( event )
        listenerBeaconIOS(event)
    end
    redimirObj.init( listenerBconIOS )
end

if partnerId == 0 then
    if isUser then
		storyboard.gotoScene("src.Home")
    else
        storyboard.gotoScene("src.LoginSplash")
    end
end

--se diapara cuando llega una notificacion
-- This function gets called when the user opens a notification or one is received when the app is open and active.
-- Change the code below to fit your app's needs.
function DidReceiveRemoteNotification(message, additionalData, isActive)
	--detecta si la app esta activa
	if isActive then
		system.vibrate()
		local RestManager = require('src.resources.RestManager')
		RestManager.getNotificationsUnRead()
		require('src.Header')
		alertNewNotifications()
		system.vibrate()
		
	else
		if (additionalData) then
			if additionalData.type == "1" then
				local RestManager = require('src.resources.RestManager')
				
				storyboard.gotoScene( "src.Message", {
					params = { item = additionalData.id }
				})
				RestManager.getNotificationsUnRead()
				--composer.removeScene( "src.Home" )
			end
		end
	end
end

--iniciamos el plugin oneSignal
-- Uncomment SetLogLevel to debug issues.
-- OneSignal.SetLogLevel(4, 4)
OneSignal.Init("9b847680-41de-11e5-8ecb-63a70d804e87", 386747265171, DidReceiveRemoteNotification)


function IdsAvailable(playerID, pushToken)
  --print("PLAYER_ID:" .. playerID)
	Globals.playerIdToken = playerID
end

OneSignal.IdsAvailableCallback(IdsAvailable)

