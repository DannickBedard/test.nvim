local CORNER_LEFT_TOP = "leftCornerTop"
local CORNER_RIGHT_TOP = "rightCornerTop"
local CORNER_LEFT_TOP_ROUNDED = "leftCornerTopRounded"
local CORNER_RIGHT_TOP_ROUNDED = "rightCornerTopRounded"
local CORNER_LEFT_BOTTOM = "leftCornerBottom"
local CORNER_RIGHT_BOTTOM = "rightCornerBottom"
local CORNER_LEFT_BOTTOM_ROUNDED = "leftCornerBottomRounded"
local CORNER_RIGHT_BOTTOM_ROUNDED = "rightCornerBottomRounded"
local SIDE = "side"
local SIDE_BOTTOM = "sideBottom"
local SPLIT_TOP = "split_top"
local SPLIT_BOTTOM = "splitBottom"
local SPLIT_LEFT_SIDE = "splitLeftSide"
local SPLIT_RIGHT_SIDE = "splitRightSide"
local SPLIT_MIDLE = "splitMidle"

local double_border = { }
double_border[CORNER_LEFT_TOP] = "╔"
double_border[CORNER_RIGHT_TOP] = "╗"
double_border[CORNER_LEFT_BOTTOM] = "╚"
double_border[CORNER_RIGHT_BOTTOM] = "╝"
double_border[SIDE] = "║"
double_border[SIDE_BOTTOM] = "═"
double_border[SPLIT_TOP] = "═"
double_border[SPLIT_BOTTOM] = "═"
double_border[SPLIT_MIDLE] = "╬"
double_border[SPLIT_LEFT_SIDE] = "╠"
double_border[SPLIT_RIGHT_SIDE] = "╣"

local simple_border = { }
simple_border[CORNER_LEFT_TOP] = "┌"
simple_border[CORNER_RIGHT_TOP] = "┐"
simple_border[CORNER_LEFT_BOTTOM] = "└"
simple_border[CORNER_RIGHT_BOTTOM] = "┘"
simple_border[SIDE] = "│"
simple_border[SIDE_BOTTOM] = "─"
simple_border[SPLIT_TOP] = "┬"
simple_border[SPLIT_BOTTOM] = "┴"
simple_border[SPLIT_MIDLE] = "┼"
simple_border[SPLIT_LEFT_SIDE] = "├"
simple_border[SPLIT_RIGHT_SIDE] = "┤"
simple_border[CORNER_LEFT_TOP_ROUNDED] = "╭"
simple_border[CORNER_RIGHT_TOP_ROUNDED] = "╮"
simple_border[CORNER_RIGHT_BOTTOM_ROUNDED] = "╯"
simple_border[CORNER_LEFT_BOTTOM_ROUNDED] = "╰"

local simple_thick_border = { }
simple_thick_border[CORNER_LEFT_TOP] = "┏"
simple_thick_border[CORNER_RIGHT_TOP] = "┓"
simple_thick_border[CORNER_LEFT_BOTTOM] = "┗"
simple_thick_border[CORNER_RIGHT_BOTTOM] = "┛"
simple_thick_border[SIDE] = "┃"
simple_thick_border[SIDE_BOTTOM] = "━"
simple_thick_border[SPLIT_TOP] = "┳"
simple_thick_border[SPLIT_BOTTOM] = "┻"
simple_thick_border[SPLIT_MIDLE] = "╋"
simple_thick_border[SPLIT_LEFT_SIDE] = "┣"
simple_thick_border[SPLIT_RIGHT_SIDE] = "┫"

function countOccurrences(str, char)
    local count = 0
    for i = 1, #str do
        if string.sub(str, i, i) == char then
            count = count + 1
        end
    end
    return count
end
local stringLen = function(text)
  local currentLenght = string.len(text)
  if (string.find(text, ':')) then
    return currentLenght -- + countOccurrences(text, ':')
  end
  return currentLenght
end

local insertTextContent = function(text, currentBorder, win_width)
  text = " " .. text
  local content = text .. string.rep(' ', win_width - (stringLen(text)))

  if string.len(content) > win_width then
    print("ho nooo...")
    content = content .. "0"
  end

  local contentLine =  currentBorder[SIDE] .. content .. currentBorder[SIDE]
  return contentLine
end

local insertEmptyContent = function(currentBorder, win_width)
  local contentLine =  currentBorder[SIDE] .. string.rep(' ', win_width) .. currentBorder[SIDE]
  return contentLine;
end


local insertTextInsideTopBorder = function(text, currentBorder, win_width)
  local top_border =  currentBorder[CORNER_LEFT_TOP] .. text .. string.rep(currentBorder[SIDE_BOTTOM], win_width - (stringLen(text))) .. currentBorder[CORNER_RIGHT_TOP] 
  return top_border
end

local insertEmptyTopBorder = function(currentBorder, win_width)
  local top_border =  currentBorder[CORNER_LEFT_TOP] .. string.rep(currentBorder[SIDE_BOTTOM], win_width) .. currentBorder[CORNER_RIGHT_TOP] 
  return top_border
end

local insertTextInsideBottomBorder = function()

end

local insertEmptyBottomBorder = function(currentBorder, win_width)
  local bottom_border =  currentBorder[CORNER_LEFT_BOTTOM] .. string.rep(currentBorder[SIDE_BOTTOM], win_width) .. currentBorder[CORNER_RIGHT_BOTTOM] 
  return bottom_border
end

return {
  doubleBorder = double_border,
  simpleBorder = simple_border,
  simpleThickBorder = simple_thick_border,
  CORNER_LEFT_TOP =  CORNER_LEFT_TOP ,
  CORNER_RIGHT_TOP =  CORNER_RIGHT_TOP ,
  CORNER_LEFT_TOP_ROUNDED =  CORNER_LEFT_TOP_ROUNDED ,
  CORNER_RIGHT_TOP_ROUNDED =  CORNER_RIGHT_TOP_ROUNDED ,
  CORNER_LEFT_BOTTOM =  CORNER_LEFT_BOTTOM ,
  CORNER_RIGHT_BOTTOM =  CORNER_RIGHT_BOTTOM ,
  CORNER_LEFT_BOTTOM_ROUNDED =  CORNER_LEFT_BOTTOM_ROUNDED ,
  CORNER_RIGHT_BOTTOM_ROUNDED =  CORNER_RIGHT_BOTTOM_ROUNDED ,
  SIDE =  SIDE ,
  SIDE_BOTTOM =  SIDE_BOTTOM ,
  SPLIT_TOP =  SPLIT_TOP ,
  SPLIT_BOTTOM =  SPLIT_BOTTOM ,
  SPLIT_LEFT_SIDE =  SPLIT_LEFT_SIDE ,
  SPLIT_RIGHT_SIDE =  SPLIT_RIGHT_SIDE ,
  SPLIT_MIDLE =  SPLIT_MIDLE,
  fn = {
    topBorder = insertEmptyTopBorder,
    topBorderText = insertTextInsideTopBorder,
    bottomBorder = insertEmptyBottomBorder,
    bottomBorderText = insertTextInsideBottomBorder,
    middleBorder = insertEmptyContent,
    middleBorderText = insertTextContent,
  }

}
