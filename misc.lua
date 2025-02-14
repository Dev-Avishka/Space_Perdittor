local Misc = {
    planets = {
        positions = {},
        images = {},
        rotations = {0, 0, 0},
        scales = {},
        rotationTimer = 0,
        rotationInterval = 2
    },
    barWidth = 200,
    barHeight = 30,
    barX = 10,
    barY = 20
}

function Misc:new()
    local misc = setmetatable({}, { __index = Misc })
    return misc
end

function Misc:load()
    
    self.planets.images = {
        love.graphics.newImage("assets/images/planet1.png"),
        love.graphics.newImage("assets/images/planet2.png"),
        love.graphics.newImage("assets/images/planet3.png")
    }
    
    self:initializePlanets()
end

function Misc:initializePlanets()
    
    for i = 1, 3 do
        self.planets.scales[i] = math.random() * (0.5 - 0.2) + 0.2
    end
    
    
    self.planets.positions = {}
    for i = 1, 3 do
        local x, y = self:getValidPlanetPosition()
        table.insert(self.planets.positions, {x = x, y = y})
    end
end

function Misc:getValidPlanetPosition()
    local function distance(x1, y1, x2, y2)
        return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
    end

    local x, y
    local isValid = false
    local ground = 450

    while not isValid do
        x = math.random(50, 750)
        y = math.random(50, ground - 100)
        
        isValid = true
        for _, pos in ipairs(self.planets.positions) do
            if distance(x, y, pos.x, pos.y) < 300 then
                isValid = false
                break
            end
        end
    end

    return x, y
end

function Misc:updatePlanets(dt)
    for i = 1, 3 do
        self.planets.rotations[i] = self.planets.rotations[i] + math.rad(30) * dt
    end

end

function Misc:drawPlanets()
    for i = 1, 3 do
        love.graphics.draw(
            self.planets.images[i],
            self.planets.positions[i].x,
            self.planets.positions[i].y,
            self.planets.rotations[i],
            self.planets.scales[i],
            self.planets.scales[i],
            self.planets.images[i]:getWidth() / 2,
            self.planets.images[i]:getHeight() / 2
        )
    end
end

function Misc:drawHealthBar(health, maxHealth)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.barX, self.barY, self.barWidth, self.barHeight)
    
    if health > 30 then
        love.graphics.setColor(0.2, 1, 0.4)
        love.graphics.rectangle("fill", self.barX, self.barY, (health / maxHealth) * self.barWidth, self.barHeight)
    else   
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.rectangle("fill", self.barX, self.barY, (health / maxHealth) * self.barWidth, self.barHeight)
    end
    
    
    love.graphics.setColor(1, 1, 1)
end
 
function Misc:drawUI(score, amtBullets, gameOver, highScore)
    
    local general = love.graphics.newFont("assets/font/font.ttf", 35)
    love.graphics.setFont(general)
    love.graphics.print("Score: " .. score, 630, 15)
    love.graphics.print("Bullets Left: " .. amtBullets, 510, 60)
    
    
    if gameOver then
        love.graphics.setColor(1, 0.4, 0.2)
        local gameOverFont = love.graphics.newFont("assets/font/font.ttf", 100)
        love.graphics.setFont(gameOverFont)
        
        local gameOverText = "Game Over"
        local textWidth = gameOverFont:getWidth(gameOverText)
        local textHeight = gameOverFont:getHeight(gameOverText)
        love.graphics.print(gameOverText, (800 - textWidth) / 2, (500 - textHeight) / 2 - 100)
        
        
        love.graphics.setColor(1, 1, 1)
        local highScoreFont = love.graphics.newFont("assets/font/font.ttf", 40)
        love.graphics.setFont(highScoreFont)
        local highScoreText = "High Score: " .. highScore
        local highScoreWidth = highScoreFont:getWidth(highScoreText)
        love.graphics.print(highScoreText, (800 - highScoreWidth) / 2, (500 - textHeight) / 2)
        
        
        love.graphics.setFont(love.graphics.newFont("assets/font/font.ttf", 30))
        love.graphics.printf("Press any key or click to restart", 0, (500 - textHeight) / 2 + 100, 800, "center")
    end
end

function Misc:updateRestartTimer(dt, restartTimer, resetCallback)
    if restartTimer then
        restartTimer = restartTimer - dt
        if restartTimer <= 0 then
            resetCallback()
            return nil
        end
        return restartTimer
    end
    return nil
end

return Misc