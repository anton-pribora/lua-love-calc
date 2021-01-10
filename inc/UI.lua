UI = {
    elements = {},
    keyBindings = {},
}

function UI:updateKeyBindings()
    local bindings = {}

    for i, v in ipairs(self.elements) do
        if v.keys then
            for _, key in ipairs(v.keys) do
                if bindings[key] then
                    table.insert(bindings[key], v)
                else
                    bindings[key] = {v}
                end
            end
        end
    end

    self.keyBindings = bindings
end

function UI:newButton(props)
    local button = UIButton.new(props)
    table.insert(self.elements, button)
    self:updateKeyBindings()
    return button
end

function UI:draw()
    love.graphics.setBackgroundColor(Colors.windowBackground)

    for i, v in ipairs(self.elements) do
        if v.draw and v.visible then
            v:draw()
        end
    end
end

function UI:mousedown(x, y, button)
    for i, v in ipairs(self.elements) do
        if v.isMouseHover then
            v.isPressed = button == 1
            v.mouseDown = button
        end
    end
end

function UI:mouseup(x, y, button)
    for i, v in ipairs(self.elements) do
        if v.isMouseHover and v.mouseDown then
            if v.mouseDown == button then
                if v.clicked then
                    v:clicked(x, y, button)
                end

                if button == 1 and v.pressed then
                    v:pressed()
                end
            end
        end

        v.mouseDown = nil
        v.isPressed = nil
    end
end

function UI:mousemove(x, y, dx, dy, istouch)
    for i, v in ipairs(self.elements) do
        v.isMouseHover = v.visible and (not v.disabled) and x >= v.x and x <= v.x + v.width and y >= v.y and y <= v.y + v.height
    end
end

function UI:keypressed(key, scancode, isrepeat)
    if self.keyBindings[key] then
        for i, v in ipairs(self.keyBindings[key]) do
            v.isPressed = true

            if v.pressed then
                v:pressed()
            end
        end
    end
end

function UI:keyreleased(key, scancode)
    if self.keyBindings[key] then
        for i, v in ipairs(self.keyBindings[key]) do
            v.isPressed = nil
        end
    end
end
