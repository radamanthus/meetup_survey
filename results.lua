local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local ui = require "scripts.lib.ui"
local radlib = require "scripts.lib.radlib"

---------------------------------------------------------------------------------
-- BEGINNING OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------
local screen = nil
local numberOfAnswers = nil

local getNumberOfAnswers = function()
  local rowCount = 0
  for row in _G.db:nrows("SELECT COUNT(*) as rowcount FROM answers") do
    rowCount = row.rowcount
  end
  return rowCount
end

local getAllAnswers = function()
  local result = {}
  local sql = "SELECT software_dev_experience, mobile_dev_experience, dev_platforms, target_platforms, content_rating, duration_rating, suggestions, email FROM answers"
  for row in _G.db:nrows( sql ) do
    result[#result+1] = row
  end
  return result
end

local selectCountFromTable = function( tableName, filter )
  local result = nil
  local sql = "SELECT COUNT(*) as rowcount FROM " .. tableName .. " WHERE " .. filter
  for row in _G.db:nrows( sql ) do
    result = row.rowcount
  end
  return result
end

---------------------------------------------------------------------------------
-- END OF VARIABLE DECLARATIONS
---------------------------------------------------------------------------------
local showAnswers = function( questionIndex, columnName, options )
  local answerChoices = _G.questions[questionIndex].choices
  local answerResults = {}
  local answersTotal = 0
  for i,answerChoice in ipairs(answerChoices) do
    answerResults.choice = answerChoice
    answerResults.count = selectCountFromTable( "answers", columnName .. " = '" .. answerChoice .. "'")
    answerResults.percentage = 100 * answerResults.count / numberOfAnswers
    print(answerChoice .. ": " .. answerResults.count)
    print(answerChoice .. ": " .. answerResults.percentage .. "%")
    answersTotal = answersTotal + answerResults.count
  end
  if options.includeBlankAnswers then
    noAnswerCount = numberOfAnswers - answersTotal
    noAnswerResult = {
      choice = "No answer",
      count = noAnswerCount,
      percentage = 100 * noAnswerCount / numberOfAnswers
    }
    answerResults[#answerResults + 1] = noAnswerResult
    print("No answer: " .. noAnswerResult.count)
    print("No answer: " .. noAnswerResult.percentage .. "%")
  end
end

local showSoftwareDevExperienceAnswers = function()
  showAnswers( 1, "software_dev_experience", {} )
end

local showMobileDevExperienceAnswers = function()
  showAnswers( 2, "mobile_dev_experience", {} )
end

local showDevPlatformsAnswers = function()
end

local showTargetPlatformsAnswers = function()
end

local showContentRatingAnswers = function()
  showAnswers( 5, "content_rating", {includeBlankAnswers = true} )
end

local showDurationRatingAnswers = function()
  showAnswers( 6, "duration_rating", {includeBlankAnswers = true} )
end

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
function scene:createScene( event )
  screen = self.view
end

function scene:enterScene( event )
  numberOfAnswers = getNumberOfAnswers()
  print( "Number of answers: " .. numberOfAnswers )
  showSoftwareDevExperienceAnswers()
  showMobileDevExperienceAnswers()
  showContentRatingAnswers()
  showDurationRatingAnswers()
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

