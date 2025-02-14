local Player = require('player')
local Alien = require('alien')
local Misc = require('misc')
local Highscore = require('highscore')
local StartMenu = require('startmenu')

local game = {
    background = nil,
    restartTimer = nil,
    font = nil,
    ground = 450,
    score = 0,
    highScore = 0,
    gameOver = false,
    shakeDuration = 0,
    shakeMagnitude = 5,
    music = nil,
    gameState = "menu"  
}

function love.load()
    local icon = love.image.newImageData("assets/images/player.png")
    love.window.setIcon(icon)
    
    math.randomseed(os.time())
    
    
    game.startMenu = StartMenu:new()
    game.startMenu:load()
    
    
    game.highScore = Highscore.loadHighScore()
    
    
    game.player = Player:new()
    game.alien = Alien:new()
    game.misc = Misc:new()
    
    game.player:load()
    game.alien:load()
    game.misc:load()
    
    
    game.background = love.graphics.newImage("assets/images/space_gradient.jpg")
    game.font = love.graphics.newFont("assets/font/font.ttf", 20)
    game.music = love.audio.newSource("assets/sounds/music.mp3", "stream")
    
    
    love.graphics.setFont(game.font)
    love.window.setTitle("Space Perditor")
    love.window.setMode(800, 500)
end

function love.update(dt)
    if game.gameState == "menu" then
        game.startMenu:update(dt)
        return
    end
    
    
    if game.restartTimer then
        game.restartTimer = game.misc:updateRestartTimer(dt, game.restartTimer, resetGame)
        return
    end

    if game.player.health <= 0 or game.player.amtBullets == 0 then
        restart()
    end

    if game.shakeDuration > 0 then
        game.shakeDuration = game.shakeDuration - dt
    end

    game.player:update(dt)
    if game.alien:update(dt, game.score) then 
        game.player.health = game.player.health - 10
        game.shakeDuration = 0.5
    end

    for i = #game.player.bullets, 1, -1 do
        if game.alien:checkCollision(game.player.bullets[i]) then
            table.remove(game.player.bullets, i)
            game.score = game.score + 1
            game.player.amtBullets = game.player.amtBullets + 1
        end
    end

    game.music:setLooping(true)
    game.music:setVolume(0.4)
    if game.state == "menu" then
        
    else
        
    end
    game.music:play()

    game.misc:updatePlanets(dt)
end

function love.draw()
    if game.gameState == "menu" then
        game.startMenu:draw()
        return
    end
    
    
    love.graphics.draw(game.background, 0, 0, 0, 
        love.graphics.getWidth() / game.background:getWidth(),
        love.graphics.getHeight() / game.background:getHeight()
    )

    if game.shakeDuration > 0 then
        local dx = love.math.random(-game.shakeMagnitude, game.shakeMagnitude)
        local dy = love.math.random(-game.shakeMagnitude, game.shakeMagnitude)
        love.graphics.translate(dx, dy)
    end

    game.misc:drawPlanets()

    love.graphics.setColor(0.5, 0.6, 0.4)
    love.graphics.rectangle("fill", 0, game.ground, 800, 50)

    game.misc:drawHealthBar(game.player.health, game.player.maxHealth)

    game.player:draw()
    game.alien:draw()

    love.graphics.origin()
    game.misc:drawUI(game.score, game.player.amtBullets, game.gameOver, game.highScore)
end

function love.mousepressed(x, y, button)
    if game.gameState == "menu" then
        if game.startMenu:handleInput(x, y, button) then
            game.gameState = "playing"
            resetGame()
        end
        return
    end
    
    if game.gameOver then
        resetGame()
    elseif button == 1 then
        game.player:shoot()
    end
end

function love.keypressed(key)
    if game.gameState == "playing" then
        if game.gameOver then
            resetGame()
        elseif key == "space" then
            game.player:shoot()
        end
    end
end

function restart()
    if game.score > game.highScore then
        game.highScore = game.score
        Highscore.storeHighScore(game.highScore)
    end
    game.gameOver = true
end

function resetGame()
    game.gameOver = false
    game.score = 0
    game.restartTimer = nil
    
    game.player:reset()
    game.alien:reset()
    game.misc:initializePlanets()
end