local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local ui = require "scripts.lib.ui"
local radlib = require "scripts.lib.radlib"

---------------------------------------------------------------------------------
-- BEGINNING OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------
local screen = nil

-- Local variables for rendering a question
local txtQuestion = nil
local questionWidget = nil
local choiceWidgets = {}
local choiceLabels = {}

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

local renderChoices = function( question, choiceType )
  local left = 10
  local top = txtQuestion.y + 20

  for i,choiceStr in ipairs( question.choices ) do
    local w = widget.newSwitch
    {
      left = 10,
      top = top,
      id = choiceType .. choiceStr,
      style = choiceType,
      initialSwitchState = false
    }
    w.label = choiceStr
    screen:insert( w )
    table.insert( choiceWidgets, w )

    local choiceText = display.newText( choiceStr, 0, 0, 200, 20, native.systemFont, 16 )
    choiceText.x = left + 40 + choiceText.width/2
    choiceText.y = top + 7 + choiceText.height/2
    screen:insert( choiceText )
    table.insert( choiceLabels, choiceText )

    top = top + 40
  end
end

local renderRadioBoxQuestion = function( question )
  renderChoices( question, "radio" )
end

local renderCheckBoxQuestion = function( question )
  renderChoices( question, "checkbox" )
end

local renderSelectQuestion = function( question )
  questionWidget = widget.newPickerWheel(
    {
      top = txtQuestion.y + 20,
      font = native.systemFont,
      columns = {
        {
          align = "right",
          width = 300,
          startIndex = 1,
          labels = question.choices
        }
      }
    }
  )
  screen:insert( questionWidget )
end

local renderTextAreaQuestion = function( question )
end

local renderQuestionText = function( question )
  txtQuestion = display.newText( question.text, 0, 0, 300, 100, native.systemFont, 16 )
  txtQuestion.x = 10 + txtQuestion.width/2
  txtQuestion.y = 10 + txtQuestion.height/2
  screen:insert( txtQuestion )
end

local renderQuestion = function( question )
  print("Rendering question #" .. _G.currentQuestionIndex)
  renderQuestionText( question )
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

local saveAnswer = function()
  local answer = nil
  local question = getCurrentQuestion()
  if question.questionType == "select" then
    answer = questionWidget:getValues()[1].value
  elseif question.questionType == "checkbox" then
    answer = {}
    for i,v in ipairs(choiceWidgets) do
      if v.isOn then
        table.insert( answer, v )
      end
    end
    print("Answer had " .. #answer .. " checked items")
  end
  _G.answers[ _G.currentQuestionIndex ] = answer
end

local gotoNextQuestion = function()
  saveAnswer()
  local questions = _G.questions
  if _G.currentQuestionIndex < #questions then
    _G.currentQuestionIndex = _G.currentQuestionIndex + 1
    storyboard.gotoScene( "start" )
  end
end

local gotoPreviousQuestion = function()
  saveAnswer()
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

local cleanupCurrentQuestion = function()
  print("Cleaning up..")
  if txtQuestion ~= nil then
    txtQuestion:removeSelf()
  end
  if questionWidget ~= nil then
    questionWidget:removeSelf()
  end

  for i,v in ipairs(choiceWidgets) do
    v:removeSelf()
  end
  choiceWidgets = {}

  for i,v in ipairs(choiceLabels) do
    v:removeSelf()
  end
  choiceLabels = {}
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
  cleanupCurrentQuestion()
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


