---------------------------------------------------------------------------------
-- Godeals App
-- Alberto Vera
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

local storyboard = require "storyboard"
local DBManager = require('src.resources.DBManager')

local idUser = DBManager.setupSquema()
storyboard.gotoScene("src.Home")

