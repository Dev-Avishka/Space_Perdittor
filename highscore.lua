local Highscore = {}

function Highscore.loadHighScore()
    if love.filesystem.getInfo("highscore.txt") then
        local contents = love.filesystem.read("highscore.txt")
        return tonumber(contents) or 0 
    end
    return 0 
end

function Highscore.storeHighScore(highScore)
    love.filesystem.write("highscore.txt", tostring(highScore))
end

return Highscore
