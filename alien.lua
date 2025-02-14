local Alien = {
    aliens = {},
    spawnTimer = 0,
    images = {},
    ground = 400
}



function Alien:new()
    local alien = setmetatable({}, { __index = Alien })
    return alien
end

function Alien:load()
    self.images = {
        love.graphics.newImage("assets/images/m2.png"),
        love.graphics.newImage("assets/images/m2.png"),
        love.graphics.newImage("assets/images/m2.png")
    }
    hit_sound = love.audio.newSource("assets/sounds/hit.mp3", "static")
    impact_sound = love.audio.newSource("assets/sounds/impact.mp3", "static")

end

function Alien:update(dt,score)
    
    local rate = 2
    if score > 40 then
        rate = 1.5
    elseif score > 50 then
        rate = 1
    end
    self.spawnTimer = self.spawnTimer + dt
    if self.spawnTimer > rate then
        self:spawn(score)
        self.spawnTimer = 0
    end

    
    for i, alien in ipairs(self.aliens) do
        alien.y = alien.y + alien.speed * dt
        if alien.y > self.ground then 
            table.remove(self.aliens, i)
            impact_sound:play()
            return true 
        end
    end
    return false
end

function Alien:spawn(score)
    local alienWidth = 60
    local alienHeight = 60
    local imageIndex = math.random(1, 3)

    local aspeed = 100
    if score > 40 then
        aspeed = 100
    elseif score > 30 then
        aspeed = 220
    elseif score > 20 then
        aspeed = 190
    elseif score > 10 then
        aspeed = 150
    end

    local alien = {
        x = math.random(0, 800 - alienWidth),
        y = 0,
        width = alienWidth,
        height = alienHeight,
        speed = 100,
        image = self.images[imageIndex]
    }

    table.insert(self.aliens, alien)
end

function Alien:checkCollision(bullet)
    for i, alien in ipairs(self.aliens) do
        local hit = bullet.x < alien.x + alien.width and
                   bullet.x + bullet.width > alien.x and
                   bullet.y < alien.y + alien.height and
                   bullet.y + bullet.height > alien.y

        if hit then
            table.remove(self.aliens, i)
            hit_sound:play()
            return true
        end
    end
    return false
end

function Alien:draw()
    love.graphics.setColor(1, 1, 1)
    for _, alien in ipairs(self.aliens) do
        love.graphics.draw(alien.image, alien.x, alien.y, 0, 0.1, 0.1)
    end
end

function Alien:reset()
    self.aliens = {}
    self.spawnTimer = 0
end

return Alien