local Player = {
    x = 100,
    health = 100,
    maxHealth = 100,
    width = 0,
    height = 0,
    image = nil,
    ground = 450,
    bullets = {},
    amtBullets = 10
}

function Player:new()
    local player = setmetatable({}, { __index = Player })
    return player
end

function Player:load()
    self.image = love.graphics.newImage("assets/images/player.png")
    self.width = self.image:getWidth() * 0.2
    self.height = self.image:getHeight() * 0.2
    
    shoot_sound = love.audio.newSource("assets/sounds/shoot.wav", "static")
    local playerIconData = love.image.newImageData("assets/images/player.png")
    love.window.setIcon(playerIconData)
end

function Player:update(dt)
    if love.keyboard.isDown("right") or love.keyboard.isDown("d") then
        self.x = self.x + 200 * dt
    elseif love.keyboard.isDown("left") or love.keyboard.isDown("a") then
        self.x = self.x - 200 * dt
    end

    if self.x < 0 then self.x = 790 elseif self.x > 800 then self.x = 0 end

    
    for i, bullet in ipairs(self.bullets) do
        bullet.y = bullet.y - bullet.speed * dt
        if bullet.y < 0 then table.remove(self.bullets, i) end
    end
end

function Player:shoot()
    if self.amtBullets > 0 then
        local bulletWidth = 5
        local bulletX = self.x + (self.width / 2) - (bulletWidth / 2)
        table.insert(self.bullets, {
            x = bulletX,
            y = self.ground - self.height,
            width = bulletWidth,
            height = 10,
            speed = 200
        })
        self.amtBullets = self.amtBullets - 1
        shoot_sound:play()
    end
end

function Player:draw()
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.image, self.x, self.ground - 100, 0, 0.2, 0.2)
    
    
    love.graphics.setColor(1, 0, 0)
    for _, bullet in ipairs(self.bullets) do
        love.graphics.rectangle("fill", bullet.x, bullet.y, bullet.width, bullet.height)
    end
    love.graphics.setColor(1, 1, 1)
end

function Player:reset()
    self.health = 100
    self.x = 100
    self.bullets = {}
    self.amtBullets = 10
end

return Player