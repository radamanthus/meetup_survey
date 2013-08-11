local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local _ = require "scripts.lib.underscore"
local ui = require "scripts.lib.ui"
local radlib = require "scripts.lib.radlib"

---------------------------------------------------------------------------------
-- BEGINNING OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------
local screen = nil

---------------------------------------------------------------------------------
-- END OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------
local sqlValue = function( val )
  local sql = nil
  if type(val) == "table" then
    sql = _.join( val, ",")
  else
    sql = val
  end
  return "'" .. sql .. "'"
end

local saveCurrentAnswerToDatabase = function()
  local sqlValues = _.map( _G.answers, sqlValue )
  local insertSql = "INSERT INTO answers VALUES (" .. _.join( sqlValues, "," ) .. ");"
  _G.db:exec( insertSql )
end

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
function scene:createScene( event )
  screen = self.view

  txtMessage = display.newText( "Thank you for your answers!", 0, 0, 300, 100, native.systemFont, 24 )
  txtMessage.x = 10 + txtMessage.width/2
  txtMessage.y = 10 + txtMessage.height/2
  txtMessage:setTextColor( 255, 255, 255, 255 )
  screen:insert( txtMessage )

  local startButton = nil
  local function onStartPressed ( event )
    if event.phase == "ended" and startButton.isActive then
      _G.answers = {}
      _G.currentQuestionIndex = 1
      storyboard.gotoScene( "start" )
    end
  end
  startButton = ui.newButton(
    radlib.table.merge(
      _G.buttons['start'],
      { onRelease = onStartPressed, text = "Back to Survey" }
    )
  )
  startButton.x = 160
  startButton.y = 440
  startButton.isActive = true
  screen:insert(startButton)
end

function scene:enterScene( event )
  saveCurrentAnswerToDatabase()
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
