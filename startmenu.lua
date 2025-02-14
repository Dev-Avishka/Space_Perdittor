local StartMenu = {
    background = nil,
    titleFont = nil,
    subtitleFont = nil,
    highScore = 0,
    isActive = true,
    
    baseTextSize = 30,
    maxTextSize = 35,
    minTextSize = 25,
    currentTextSize = 30,
    animationTime = 0,
    animationSpeed = 2  
}

function StartMenu:new()
    local menu = setmetatable({}, { __index = StartMenu })
    return menu
end

function StartMenu:load()
    
    player_image = love.graphics.newImage("assets/images/planet1.png")
    self.background = love.graphics.newImage("assets/images/space_gradient.jpg")
    music = love.audio.newSource("assets/sounds/menutheme.mp3", "stream")
    music:play()
    self.titleFont = love.graphics.newFont("assets/font/Title.ttf", 80)
    
    
    local Highscore = require('highscore')
    self.highScore = Highscore.loadHighScore()
end

function StartMenu:update(dt)
    
    self.animationTime = self.animationTime + dt
    
    
    
    
    local wave = math.sin(self.animationTime * math.pi * self.animationSpeed)
    local sizeRange = self.maxTextSize - self.minTextSize
    self.currentTextSize = self.minTextSize + (sizeRange * (wave + 1) / 2)
    
    
    self.subtitleFont = love.graphics.newFont("assets/font/font.ttf", self.currentTextSize)
end

function StartMenu:draw()
    
    
    love.graphics.draw(self.background, 0, 0, 0,
        love.graphics.getWidth() / self.background:getWidth(),
        love.graphics.getHeight() / self.background:getHeight()
    )
    love.graphics.draw(player_image, 500, -50, math.rad(80), 1, 1)
    
    love.graphics.setFont(self.titleFont)
    love.graphics.setColor(0, 0, 0)
    local titleText = "Space Perditor"
    local titleWidth = self.titleFont:getWidth(titleText)
    love.graphics.print(titleText, (800 - titleWidth) / 2, 150)
    
    love.graphics.setColor(1, 1, 1)
    local baseFont = love.graphics.newFont("assets/font/font.ttf", self.baseTextSize)
    love.graphics.setFont(baseFont)
    local highScoreText = "High Score: " .. self.highScore
    local highScoreWidth = baseFont:getWidth(highScoreText)
    love.graphics.print(highScoreText, (800 - highScoreWidth) / 2, 250)
    
    
    love.graphics.setFont(self.subtitleFont)
    local startText = "Click Anywhere to Start"
    local startWidth = self.subtitleFont:getWidth(startText)
    
    local yOffset = (self.maxTextSize - self.currentTextSize) / 2
    love.graphics.print(startText, (800 - startWidth) / 2, 350 + yOffset)
end

function StartMenu:handleInput(x, y, button)
    if button == 1 then  
        self.isActive = false
        music:stop()
        return true  
    end
    return false
end

return StartMenu