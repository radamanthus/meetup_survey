local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local ui = require "scripts.lib.ui"
local radlib = require "scripts.lib.radlib"

---------------------------------------------------------------------------------
-- BEGINNING OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------
local screen = nil
local menuTableView = nil

---------------------------------------------------------------------------------
-- END OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------
local showSoftwareDevExperienceAnswers = function()
end

local showMobileDevExperienceAnswers = function()
end

local showDevPlatformsAnswers = function()
end

local showTargetPlatformsAnswers = function()
end

local showContentRatingAnswers = function()
end

local showDurationRatingAnswers = function()
end

local showCommentsAnswers = function()
end

local showEmails = function()
end

local onMenuRowRender = function( event )
end

local onMenuRowTouch = function( event )
  if "release" == phase then
  end
end

local showResultsMenu = function()
end

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
function scene:createScene( event )
  screen = self.view
  menuTableView = widget.newTableView
  {
    width = 320,
    height = 480,
    onRowRender = onMenuRowRender,
    onRowTouch = onMenuRowTouch
  }
end

function scene:enterScene( event )
  showResultsMenu()
end

function scene:exitScene( event )
  -- stop timers, sound, etc.
end

function scene:destroyScene( event )
  -- free up resources here
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )
---------------------------------------------------------------------------------

return scene

