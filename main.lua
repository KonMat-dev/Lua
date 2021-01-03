function getImageScaleForNewDimensions( image, newWidth, newHeight )
    local currentWidth, currentHeight = image:getDimensions()
    return ( newWidth / currentWidth ), ( newHeight / currentHeight )
end

local bacground=love.graphics.newImage('bacground.png')
local scaleX, scaleY = getImageScaleForNewDimensions( bacground, 1000, 600 )
local barrle=love.graphics.newImage('beczka.png')
local scaleXB, scaleYB = getImageScaleForNewDimensions( barrle, 100, 100 )
local flame =love.graphics.newImage('flame2.png')
local scaleXF, scaleYF = getImageScaleForNewDimensions( flame, 200, 200 )
local pom

local player=love.graphics.newImage('player.png')
local scaleXP,scaleYP=getImageScaleForNewDimensions( player, 50, 100 )



function love.load()
    gameState = 1   -- 1-menu   2-play
    gameFont=love.graphics.newFont(40)  
    score=0
    lives=3

    playingAreaWidth = 670
    playingAreaHeight = 388

    barrleX = playingAreaWidth
    barrle2X = playingAreaWidth +200
    flameX = playingAreaWidth +100

    playerY=playingAreaHeight+50
    playerX=10
    playerWidth=50
    playerHeight=100

    barrleSpaceHeight = 100
    barrleWidth = 54
    flameWidth = 70

        function resetBarrle()
            barrleX = playingAreaWidth +100
        end
        resetBarrle()

        function resetBarrle2()
            barrle2X = playingAreaWidth + love.math.random(200,300)  + 100
        end
        resetBarrle2()

        function resetFlame()
            flameX = playingAreaWidth + love.math.random(200,300)  + 100
        end
        resetFlame()

        function resetPlayer()
            playerY=playingAreaHeight+50
        end
    

end

function love.update(dt)


     barrleX = barrleX - (100 * dt)
     if (barrleX + barrleWidth) < -130 then
            resetBarrle()
        end

    barrle2X = barrle2X - (100 * dt)
    if (barrle2X + barrleWidth) < -130 then
           resetBarrle2()
       end



       flameX = flameX - (100 * dt)
       if (flameX + flameWidth) < 10 then
              resetFlame()
          end

    if lives>0 and gameState==2 then --updating score
            score=score+0.09
    end

    if lives<=0 then --checking lives 
        score=score
        gameState=1
    end



end

function love.keypressed(key)
    if key=="space" then  --test if statement just for decrising live to test 'menu' 
        lives=lives-1
    end
    if key=="down" then
        if playerY+10<playingAreaHeight then
            playerY=playerY+10
        end
    elseif key=="up" then
        if playerY-10>playingAreaHeight-100 then
            playerY=playerY-10
        end
    end
    
end



function love.draw()

love.graphics.draw( bacground, 0, 0, rotation, scaleX, scaleY )

      local barrleSpaceY = 450

      local FlameSpaceY = 300

    
    love.graphics.setFont(gameFont)
    love.graphics.print("Score: "..math.ceil(score),5,5)
    love.graphics.print("Lives: "..lives,300,5)

    if gameState==1 then
        love.graphics.setColor(0,0,0)
        love.graphics.printf("Cick anywhere to begin!",0,250,love.graphics.getWidth(),"center")
        love.graphics.setColor(1,1,1)
    end
    if gameState==2 then
    
        love.graphics.draw( barrle, barrleX, barrleSpaceY,0, scaleXB, scaleYB )
        love.graphics.draw( barrle,barrle2X, barrleSpaceY,0, scaleXB, scaleYB )
        love.graphics.draw( flame,flameX, 200,0, scaleXF, scaleYF )
        love.graphics.draw( player,playerX,playerY ,0, scaleXP, scaleYP )
    end

end

function love.mousepressed(x,y,button,istouch,press) --function to start the game fom the menu
    if button==1 and gameState==1 then
        gameState=2
        lives=3
        score=0
    end

end

function collisionCheck(x,y,w,h) --function gets x,y, width, height of obstacle
    return playerX < x+w and x < playerX + playerWidth and
    playerY < y+h and y < playerY +playerHeight


end