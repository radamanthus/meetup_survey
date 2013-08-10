local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local ui = require "scripts.lib.ui"
local radlib = require "scripts.lib.radlib"

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local screen = nil

function scene:createScene( event )
  screen = self.view

  local startButton = nil
  local function onStartPressed ( event )
    if event.phase == "ended" and startButton.isActive then
      _G.currentQuestionIndex = 1
      storyboard.gotoScene( "start" )
    end
  end
  startButton = ui.newButton(
    radlib.table.merge(
      _G.buttons['start'],
      { onRelease = onStartPressed }
    )
  )
  startButton.x = 160
  startButton.y = 80
  startButton.isActive = true
  screen:insert(startButton)

  local resultsButton = nil
  local function onResultsPressed( event )
    if event.phase == "ended" and resultsButton.isActive then
      storyboard.gotoScene( "results" )
    end
  end
  resultsButton = ui.newButton(
    radlib.table.merge(
      _G.buttons['results'],
      { onRelease = onResultsPressed }
    )
  )
  resultsButton.x = 160
  resultsButton.y = 130
  resultsButton.isActive = true
  screen:insert(resultsButton)
end

function scene:enterScene( event )
  print("Menu loaded...")
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
