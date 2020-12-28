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



function love.load()

    playingAreaWidth = 670
    playingAreaHeight = 388

    barrleX = playingAreaWidth
    barrle2X = playingAreaWidth +200
    flameX = playingAreaWidth +100


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





end

function love.keypressed(key)
    love.load()
end



function love.draw()

love.graphics.draw( bacground, 0, 0, rotation, scaleX, scaleY )

      local barrleSpaceY = 450

      local FlameSpaceY = 300


love.graphics.draw( barrle, barrleX, barrleSpaceY,0, scaleXB, scaleYB )

love.graphics.draw( barrle,barrle2X, barrleSpaceY,0, scaleXB, scaleYB )

love.graphics.draw( flame,flameX, 200,0, scaleXF, scaleYF )




end
