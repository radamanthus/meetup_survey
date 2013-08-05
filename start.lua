local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local ui = require "scripts.lib.ui"
local radlib = require "scripts.lib.radlib"

---------------------------------------------------------------------------------
-- BEGINNING OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------
local screen = nil

---------------------------------------------------------------------------------
-- END OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------

-- Returns the current question
-- Defaults to the first question if _G.currentQuestionIndex contains an invalid value
local getCurrentQuestion = function()
  local questions = _G.questions
  local currentQuestionIndex = _G.currentQuestionIndex
  if (currentQuestionIndex == nil) or (currentQuestionIndex < 1) or (currentQuestionIndex > #questions) then
    currentQuestionIndex = 1
  end

  return _G.questions[currentQuestionIndex]
end

local renderTextBoxQuestion = function( question )
end

local renderRadioBoxQuestion = function( question )
end

local renderCheckBoxQuestion = function( question )
end

local renderSelectQuestion = function( question )
end

local renderTextAreaQuestion = function( question )
end

local renderQuestion = function( question )
  print("Rendering question #" .. _G.currentQuestionIndex)
  if question.questionType == "textbox" then
    renderTextBoxQuestion( question )
  elseif question.questionType == "radiobox" then
    renderRadioBoxQuestion( question )
  elseif question.questionType == "checkbox" then
    renderCheckBoxQuestion( question )
  elseif question.questionType == "select" then
    renderSelectQuestion( question )
  elseif question.questionType == "textarea" then
    renderTextAreaQuestion( question )
  else
    renderTextBoxQuestion( question )
  end
end

local gotoNextQuestion = function()
  local questions = _G.questions
  if _G.currentQuestionIndex < #questions then
    _G.currentQuestionIndex = _G.currentQuestionIndex + 1
    storyboard.gotoScene( "start" )
  end
end

local gotoPreviousQuestion = function()
  local questions = _G.questions
  if _G.currentQuestionIndex > 1 then
    _G.currentQuestionIndex = _G.currentQuestionIndex - 1
    storyboard.gotoScene( "start" )
  end
end

local renderNextPreviousButtons = function()
  local nextButton = nil
  local function onNextPressed ( event )
    if event.phase == "ended" and nextButton.isActive then
      gotoNextQuestion()
    end
  end
  nextButton = ui.newButton(
    radlib.table.merge(
      _G.buttons['nxt'],
      { onRelease = onNextPressed }
    )
  )
  nextButton.x = 270
  nextButton.y = 440
  nextButton.isActive = true
  screen:insert(nextButton)

  local previousButton = nil
  local function onPreviousPressed ( event )
    if event.phase == "ended" and previousButton.isActive then
      gotoPreviousQuestion()
    end
  end
  previousButton = ui.newButton(
    radlib.table.merge(
      _G.buttons['previous'],
      { onRelease = onPreviousPressed }
    )
  )
  previousButton.x = 50
  previousButton.y = 440
  previousButton.isActive = true
  screen:insert(previousButton)
end

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
function scene:createScene( event )
  screen = self.view
  renderNextPreviousButtons()
end

function scene:enterScene( event )
  renderQuestion( getCurrentQuestion() )
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

