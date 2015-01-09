-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

--local composer = require "composer"
local launchArgs = ...
local storyboard = require "storyboard"
local DBManager = require('src.resources.DBManager')
local Globals = require('src.resources.Globals')

storyboard.gotoScene("src.Home")

local idUser = DBManager.setupSquema()