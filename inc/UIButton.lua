UIButton = {}

function UIButton.new(props)
    return {
        visible = props.visible or true,
        text = props.text or "Button",
        textAlign = props.textAlign or "center",
        x = props.x or 0,
        y = props.y or 0,
        width = props.width or 100,
        height = props.height or 40,
        border = props.border or true,
        isMouseHover = nil,
        isPressed = nil,
        backgroundColor = props.backgroundColor or nil,
        buttonBackgroundPressed = props.buttonBackgroundPressed or nil,
        backgroundColorHover = props.backgroundColorHover or nil,
        borderColorDark = props.borderColorDark or nil,
        borderColorLight = props.borderColorLight or nil,
        textColor = props.textColor or nil,
        font = props.font or nil,
        keys = props.keys or nil,
        disabled = props.disabled or nil,

        draw = props.draw or UIButton.draw,
        pressed = props.pressed or nil,
        clicked = props.clicked or nil,
    }
end

function UIButton.draw(self)
    local borderColorLeftTop
    local borderColorRightBottom

    if self.isPressed then
        borderColorLeftTop = self.borderColorDark or Colors.buttonBorderDark
        borderColorRightBottom = self.borderColorLight or Colors.buttonBorderLight
    else
        borderColorLeftTop = self.borderColorLight or Colors.buttonBorderLight
        borderColorRightBottom = self.borderColorDark or Colors.buttonBorderDark
    end

    love.graphics.setColor(borderColorLeftTop)
    love.graphics.line(self.x, self.y + self.height, self.x, self.y, self.x + self.width, self.y)
    love.graphics.setColor(borderColorRightBottom)
    love.graphics.line(self.x + self.width, self.y, self.x + self.width, self.y + self.height, self.x + 1, self.y + self.height)

    if self.isPressed then
        love.graphics.setColor(self.buttonBackgroundPressed or Colors.buttonBackgroundPressed)
    elseif self.isMouseHover then
        love.graphics.setColor(self.backgroundColorHover or Colors.buttonBackgroundHover)
    else
        love.graphics.setColor(self.backgroundColor or Colors.buttonBackground)
    end

    love.graphics.rectangle("fill", self.x + 1, self.y + 1, self.width - 2, self.height - 2)

    local font = self.font or love.graphics.getFont()
    local textWidth = font:getWidth(self.text)
    local textHeight = font:getHeight(self.text)

    local dx = self.isPressed and 1 or 0
    local dy = dx

    love.graphics.setColor(self.textColor or Colors.buttonText)

    if self.textAlign == "center" then
        love.graphics.print(self.text, font, self.x + dx + self.width / 2 - textWidth / 2, self.y + dy + self.height / 2 - textHeight / 2)
    elseif self.textAlign == "left" then
        love.graphics.print(self.text, font, self.x + dx, self.y + dy + self.height / 2 - textHeight / 2)
    elseif self.textAlign == "right" then
        love.graphics.print(self.text, font, self.x + dx + self.width - textWidth, self.y + dy + self.height / 2 - textHeight / 2)
    end
end
