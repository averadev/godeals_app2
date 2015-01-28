---------------------------------------------------------------------------------
-- Godeals App
-- Alberto Vera
-- GeekBucket Software Factory
---------------------------------------------------------------------------------
local launchArgs = ...      -- at the top of your program code
display.setStatusBar( display.DarkStatusBar )

local storyboard = require "storyboard"
local DBManager = require('src.resources.DBManager')
local isUser = DBManager.setupSquema()
--DBManager.updateUser(1, "alfredo@hotmail.com", '', 'Alfredo Chi Zum', '100001525033547', '') -- Temporal

local partnerId = 0
if launchArgs then
    if launchArgs.androidIntent then
        if launchArgs.androidIntent.extras then
            if launchArgs.androidIntent.extras.type then
                partnerId = launchArgs.androidIntent.extras.partnerId
            end
        end
    end
end


-- Read from local notification
local function notificationListener( event )
    if ( event.type == "local" ) then
        -- Handle the local notification
        print("On local notif")
        partnerId = native.getProperty( "partnerId" )
    end
end
Runtime:addEventListener( "notification", notificationListener )

if partnerId > 0 then
    storyboard.gotoScene("src.Partner", {params = { idPartner = partnerId }})
else
    if isUser then
		storyboard.gotoScene("src.Home")
	else
		print("hola")
		storyboard.gotoScene("src.Login")
	end
end
