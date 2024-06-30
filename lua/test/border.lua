local CORNER_LEFT_TOP = "leftCornerTop"
local CORNER_RIGHT_TOP = "rightCornerTop"

local LEFT_CORNER_BOTTOM = "leftCornerBottom"
local RIGHT_CORNER_BOTTOM = "rightCornerBottom"
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
double_border[LEFT_CORNER_BOTTOM] = "╚"
double_border[RIGHT_CORNER_BOTTOM] = "╝"
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
simple_border[LEFT_CORNER_BOTTOM] = "└"
simple_border[RIGHT_CORNER_BOTTOM] = "┘"
simple_border[SIDE] = "│"
simple_border[SIDE_BOTTOM] = "─"
simple_border[SPLIT_TOP] = "┬"
simple_border[SPLIT_BOTTOM] = "┴"
simple_border[SPLIT_MIDLE] = "┼"
simple_border[SPLIT_LEFT_SIDE] = "├"
simple_border[SPLIT_RIGHT_SIDE] = "┤"
simple_border["CornerLeftTopRounder"] = "╭"
simple_border["CornerRightTopRounder"] = "╮"
simple_border["CornerRightBottomRounder"] = "╯"
simple_border["CornerLeftBottomRounder"] = "╰	"

local simple_thick_border = { }
simple_thick_border[CORNER_LEFT_TOP] = "┏"
simple_thick_border[CORNER_RIGHT_TOP] = "┓"
simple_thick_border[LEFT_CORNER_BOTTOM] = "┗"
simple_thick_border[RIGHT_CORNER_BOTTOM] = "┛"
simple_thick_border[SIDE] = "┃"
simple_thick_border[SIDE_BOTTOM] = "━"
simple_thick_border[SPLIT_TOP] = "┳"
simple_thick_border[SPLIT_BOTTOM] = "┻"
simple_thick_border[SPLIT_MIDLE] = "╋"
simple_thick_border[SPLIT_LEFT_SIDE] = "┣"
simple_thick_border[SPLIT_RIGHT_SIDE] = "┫"

return {
  doubleBorder = double_border,
  simpleBorder = simple_border,
  simpleThickBorder = simple_thick_border
}
