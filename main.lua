require("inc/UI")
require("inc/UIButton")
require("inc/Colors")
require("inc/Calc")

local textinput = nil

function love.load()
    love.graphics.setBackgroundColor(Colors.windowBackground)
    love.window.setTitle("Calc!")

    Calc:init()
end

function love.draw()
    UI:draw()
end

function love.mousepressed(x, y, button, istouch, presses)
    UI:mousedown(x, y, button)
end

function love.mousereleased(x, y, button)
    UI:mouseup(x, y, button)
end

function love.mousemoved(x, y, dx, dy, istouch)
    UI:mousemove(x, y, dx, dy, istouch)
end

function love.keypressed(key, scancode, isrepeat)
    UI:keypressed(filterSpecialChars(key), scancode, isrepeat)
end

function love.keyreleased(key, scancode)
    UI:keyreleased(filterSpecialChars(key), scancode)
end

-- В Love есть некоторые проблемы с тем, какой именно символ сейчас вводится,
-- поэтому сложение и умножение приходится обрабатывать отдельно.
-- Можно использовать коллбэк love.textinput, но здесь это не подходит.
function filterSpecialChars(char)
    local shift = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")

    if shift then
        if char == "=" then return "+" end
        if char == "8" then return "*" end
    end

    return char
end
