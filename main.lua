---------------------------------------------------------------------------------
-- Godeals App
-- Alberto Vera
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

local storyboard = require "storyboard"
local DBManager = require('src.resources.DBManager')

local idUser = DBManager.setupSquema()
DBManager.updateUser(1, "mrfeto@gmail.com", '', 'Alberto Vera', '10152713865899218', '') -- Temporal

storyboard.gotoScene("src.Home")

