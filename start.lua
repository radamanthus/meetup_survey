local widget = require( "widget" )
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local _ = require "scripts.lib.underscore"

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

local renderTextWidget = function( question, fieldType, answer )
  local left = 10
  local top = txtQuestion.y
  local width = 300
  local height = 20

  if fieldType == "textbox" then
    questionWidget = native.newTextBox(
      left, top,
      width, 100
    )
  else
    questionWidget = native.newTextField(
      left, top,
      width, 20
    )
  end
  questionWidget.text = answer
  questionWidget.isEditable = true
end

local renderTextFieldQuestion = function( question, answer )
  renderTextWidget( question, "textfield", answer )
end

local renderRadioQuestion = function( question, answer )
  local left = 10
  local top = txtQuestion.y + 20

  for i,choiceStr in ipairs( question.choices ) do
    local w = widget.newSwitch
    {
      left = 10,
      top = top,
      style = "radio",
      initialSwitchState = (answer == choiceStr)
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

local renderCheckBoxQuestion = function( question, selectedAnswers )
  local left = 10
  local top = txtQuestion.y + 20
  local selected = false

  for i,choiceStr in ipairs( question.choices ) do
    selected = _.include( selectedAnswers, choiceStr )
    local w = widget.newSwitch
    {
      left = 10,
      top = top,
      style = "checkbox",
      initialSwitchState = selected
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

local renderSelectQuestion = function( question, answer )
  local selectedIndex = 2
  for i,choiceStr in ipairs( question.choices ) do
    if ( choiceStr == answer ) then
      selectedIndex = i
    end
  end
  questionWidget = widget.newPickerWheel(
    {
      top = txtQuestion.y + 20,
      font = native.systemFont,
      columns = {
        {
          align = "left",
          width = 300,
          startIndex = selectedIndex,
          labels = question.choices
        }
      }
    }
  )
  screen:insert( questionWidget )
end

local renderTextAreaQuestion = function( question, answer )
  renderTextWidget( question, "textbox", answer )
end

local renderQuestionText = function( question )
  txtQuestion = display.newText( question.text, 0, 0, 300, 100, native.systemFont, 16 )
  txtQuestion.x = 10 + txtQuestion.width/2
  txtQuestion.y = 10 + txtQuestion.height/2
  screen:insert( txtQuestion )
end

local renderQuestion = function( question )
  local answer = _G.answers[_G.currentQuestionIndex]
  renderQuestionText( question )
  if question.questionType == "textfield" then
    renderTextFieldQuestion( question, answer )
  elseif question.questionType == "radio" then
    renderRadioQuestion( question, answer )
  elseif question.questionType == "checkbox" then
    renderCheckBoxQuestion( question, answer )
  elseif question.questionType == "select" then
    renderSelectQuestion( question, answer )
  elseif question.questionType == "textarea" then
    renderTextAreaQuestion( question, answer )
  else
    renderTextBoxQuestion( question, answer )
  end
end

local saveAnswer = function()
  local answer = nil
  local question = getCurrentQuestion()
  if question.questionType == "select" then
    answer = questionWidget:getValues()[1].value
  elseif question.questionType == "radio" then
    for i,choiceWidget in ipairs(choiceWidgets) do
      if choiceWidget.isOn then
        answer = choiceWidget.label
      end
    end
  elseif question.questionType == "checkbox" then
    answer = {}
    for i,choiceWidget in ipairs(choiceWidgets) do
      if choiceWidget.isOn then
        answer[#answer+1] = choiceWidget.label
      end
    end
  elseif ( question.questionType == "textarea" ) or ( question.questionType == "textfield" ) then
    answer = questionWidget.text
  end
  _G.answers[ _G.currentQuestionIndex ] = answer
  if (question.questionType ~= "checkbox") and (_G.answers[_G.currentQuestionIndex] ~= nil) then
  end
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


