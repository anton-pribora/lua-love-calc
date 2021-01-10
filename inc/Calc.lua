Calc = {
    registerA,
    registerB,
    operation,
    chain,
    inputMode,
}

function Calc:init()
    local px = 20
    local py = 20
    local buttonWidth = 60
    local buttonHeight = 50
    local space = 10
    local font = love.graphics.newFont(22)
    local pressed = function(self)
        Calc:buttonPressed(self.text)
    end

    -- Сбрасываем состояние калькулятора
    self:clear()

    -- Рисуем красивости
    table.insert(UI.elements, {
        disabled = true,
        visible = true,
        draw = Calc.drawLabels
    })

    -- Рисуем дисплей
    table.insert(UI.elements, {
        x = px,
        y = 20,
        width = buttonWidth * 4 + space * 3,
        height = 60,
        font = love.graphics.newFont(36),
        borderColor = Colors.black,
        textColor = Colors.black,
        backgroundColor = Colors.white,
        disabled = true,
        visible = true,
        draw = Calc.drawDisplay
    })

    py = py + 60 + space + space + space

    local row = 0

    UI:newButton({x = px + (space + buttonWidth) * 0, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = "AC", keys = {"escape", "backspace", "delete"}, font = font, pressed = pressed})
    UI:newButton({x = px + (space + buttonWidth) * 1, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = "+-", keys = {}, font = font, pressed = pressed})
    UI:newButton({x = px + (space + buttonWidth) * 2, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = "/", keys = {"/", "kp/"}, font = font, pressed = pressed})
    UI:newButton({x = px + (space + buttonWidth) * 3, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = "*", keys = {"*", "kp*"}, font = font, pressed = pressed})

    row = row + 1

    UI:newButton({x = px + (space + buttonWidth) * 0, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = 7, keys = {"7", "kp7"}, font = font, pressed = pressed})
    UI:newButton({x = px + (space + buttonWidth) * 1, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = 8, keys = {"8", "kp8"}, font = font, pressed = pressed})
    UI:newButton({x = px + (space + buttonWidth) * 2, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = 9, keys = {"9", "kp9"}, font = font, pressed = pressed})
    UI:newButton({x = px + (space + buttonWidth) * 3, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = "-", keys = {"-", "kp-"}, font = font, pressed = pressed})

    row = row + 1

    UI:newButton({x = px + (space + buttonWidth) * 0, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = 4, keys = {"4", "kp4"}, font = font, pressed = pressed})
    UI:newButton({x = px + (space + buttonWidth) * 1, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = 5, keys = {"5", "kp5"}, font = font, pressed = pressed})
    UI:newButton({x = px + (space + buttonWidth) * 2, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = 6, keys = {"6", "kp6"}, font = font, pressed = pressed})
    UI:newButton({x = px + (space + buttonWidth) * 3, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = "+", keys = {"+", "kp+"}, font = font, pressed = pressed})

    row = row + 1

    UI:newButton({x = px + (space + buttonWidth) * 0, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = 1, keys = {"1", "kp1"}, font = font, pressed = pressed})
    UI:newButton({x = px + (space + buttonWidth) * 1, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = 2, keys = {"2", "kp2"}, font = font, pressed = pressed})
    UI:newButton({x = px + (space + buttonWidth) * 2, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = 3, keys = {"3", "kp3"}, font = font, pressed = pressed})

    row = row + 1

    UI:newButton({x = px + (space + buttonWidth) * 0, y = py + (space + buttonHeight) * row, width = buttonWidth * 2 + space, height = buttonHeight, text = 0, keys = {"0", "kp0"}, font = font, pressed = pressed})
    UI:newButton({x = px + (space + buttonWidth) * 2, y = py + (space + buttonHeight) * row, width = buttonWidth, height = buttonHeight, text = ".", keys = {",", ".", "kp."}, font = font, pressed = pressed})

    UI:newButton({
        x = px + (space + buttonWidth) * 3,
        y = py + (space + buttonHeight) * (row - 1),
        width = buttonWidth,
        height = buttonHeight * 2 + space,
        text = "=",
        keys = {"=", "kpenter", "return"},
        font = font,
        pressed = pressed,
        buttonBackgroundPressed = {.97 * .85, .33 * .85, .19 * .85, 1},
        backgroundColorHover = {.97 * 1.1, .33 * 1.1, .19 * 1.1, 1},
        backgroundColor = {.97, .33, .19, 1},
        borderColorDark = {.97 * .8, .33 * .8, .19 * .8, 1},
        borderColorLight = {.97 * .95, .33 * .95, .19 * .95, 1},
    })

    love.window.setMode(px * 2 + (buttonWidth + space) * 4 - space, py + (space + buttonHeight) * (row + 1) + space, {})
end

function Calc:buttonPressed(text)
    if tonumber(text) then
        if self.inputMode then
            self.registerB = self.registerB .. text
        else
            self.registerB = text
            self.inputMode = true
        end
    end

    if text == "." then
        if self.inputMode then
            if not string.find(self.registerB, "%.") then
                self.registerB = self.registerB .. "."
            end
        else
            self.registerB = "0."
            self.inputMode = true
        end
    end

    if text == "+" or text == "-" or text == "*" or text == "/" then
        if self.inputMode then
            if self.chain then
                self.registerA = self:doOperation()
            else
                self.registerA = self.registerB
            end
        end

        self.chain = true
        self.operation = text
        self.inputMode = nil
    end

    if text == "+-" then
        if self.inputMode then
            self.registerB = - tonumber(self.registerB)
        else
            self.registerA = - tonumber(self.registerA)
        end
    end

    if text == "=" then
        if self.operation then
            if not self.inputMode and self.chain then
                self.registerB = self.registerA
            end

            self.registerA = self:doOperation()
            self.inputMode = nil
            self.chain = nil
        end
    end

    if text == "AC" then
        self:clear()
    end
end

function Calc:clear()
    self.registerA = 0
    self.registerB = 0
    self.operation = nil
    self.inputMode = nil
end

function Calc:doOperation()
    local a = tonumber(self.registerA)
    local b = tonumber(self.registerB)

    local result = a

    -- Выполняем операцию
    if self.operation == "+" then
        result = a + b
    end

    if self.operation == "-" then
        result = a - b
    end

    if self.operation == "*" then
        result = a * b
    end

    if self.operation == "/" then
        result = a / b
    end

    return result
end

function Calc.drawDisplay(self)
    -- Рисуем рамочку
    love.graphics.setColor(self.borderColor)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

    love.graphics.setColor(self.backgroundColor)
    love.graphics.rectangle("fill", self.x + 1, self.y + 1, self.width - 2, self.height - 2)

    -- Выводим текст
    local text
    local textLimit = 10
    local len
    local font = self.font or love.graphics.getFont()

    if Calc.inputMode then
        text = Calc.registerB
        len = string.len(text)

        -- Обрезаем слева
        if len > textLimit then
            text = string.sub(text, len - textLimit)
        end
    else
        text = Calc.registerA
        len = string.len(text)

        -- Обрезаем справа
        if len > textLimit then
            local dotPosition = string.find(text, "%.")

            if dotPosition then
                if dotPosition < textLimit then
                    text = tonumber(string.format("%." .. tostring(textLimit - dotPosition) .. "f", text))
                end
            end
        end

        text = tostring(text)

        if font:getWidth(text) > self.width - 2 then
            text = string.sub(text, 1, textLimit) .. "+"
        end
    end


    local textWidth = font:getWidth(text)
    local textHeight = font:getHeight(text)

    local dx = 2
    local dy = 2

    love.graphics.setColor(self.textColor)
    love.graphics.print(text, font, self.x - dx + self.width - textWidth, self.y + dy + self.height / 2 - textHeight / 2)
end

function Calc.drawLabels(self)
    -- Красивости калькулятора
    love.graphics.setColor({.31 * 1.1, .32 * 1.1, .40 * 1.1, 1})
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 100)

    love.graphics.setColor(Colors.white)
    love.graphics.polygon('fill', 40, 99, love.graphics.getWidth() - 80, 1, love.graphics.getWidth() - 40, 1, 80, 99)
end
