local sqlite3 = require "sqlite3"
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local screen = nil

local initializeDatabase = function()
  local path = system.pathForFile( "data.db", system.DocumentsDirectory )
  _G.db = sqlite3.open( path )
  local createTableSql = [[CREATE TABLE IF NOT EXISTS answers(software_dev_experience, mobile_dev_experience, dev_platforms, target_platforms, content_rating, duration_rating, suggestions, email);]]
end

local onSystemEvent = function( event )
  if ( "applicationExit" == event.type ) then
    _G.db:close()
  end
end

function initializeGame()
  require 'init_buttons'
  require 'init_questions'

  math.randomseed( os.time() )

  initializeDatabase()
  Runtime:addEventListener( "system", onSystemEvent )

  _G.answers = {}
end

function scene:createScene( event )
  screen = self.view

  local loadingImage = display.newImageRect( "images/splash_screen.png", 480, 320 )
  loadingImage.x = display.contentWidth/2
  loadingImage.y = display.contentHeight/2
  screen:insert(loadingImage)

  local gotoMainMenu = function()
    storyboard.gotoScene( "menu" )
  end

  initializeGame()

  local loadMenuTimer = timer.performWithDelay( 1000, gotoMainMenu, 1 )
end

function scene:enterScene( event )
  print("Loading screen loaded...")

  storyboard.removeAll()
end

function scene:exitScene( event )
end

function scene:destroyScene( event )
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
--
-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )
---------------------------------------------------------------------------------

return scene

