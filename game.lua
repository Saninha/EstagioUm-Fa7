local composer = require( "composer" )
local scene = composer.newScene()

local physics = require "physics"
physics.start()
physics.setGravity( 0, 50 )
--physics.setDrawMode( "hybrid" )

local dados = require("dados")

local gameStarted = false

local teto = display.newRect(1, display.actualContentHeight- 800, display.contentWidth*3, 1)
physics.addBody(teto, "static", {friction = 0.1})


function backgroundScroller(self,event)
  if self.x < (-self.width + (self.speed*2))   then
    self.x = self.width
  else
    self.x = self.x - self.speed
  end
end

function flyUp(event)
   if event.phase == "began" then
    if gameStarted == false then
       player.bodyType = "dynamic"
       gameStarted = true
       score.alpha = 1
       adicionarColunasTimer = timer.performWithDelay (1500, adicionarColunas, -1)
       andarColunasTimer = timer.performWithDelay (2, andarColunas, -1)
       player:applyForce(0, -600, player.x, player.y)
    else
      player:applyForce(0, -900, player.x, player.y)
    end
  end
end

function onCollision( event )
  if ( event.phase == "began" ) then
    composer.gotoScene( "restart" )
  end
end


function andarColunas()
  for a = elements.numChildren,1,-1 do
    if(elements[a].x < player.x - 10) then
     if elements[a].scoreAdded == false then
       dados.score = dados.score + 1
       score.text = dados.score
       elements[a].scoreAdded = true
     end
    end
    if (elements[a].x > -100) then
      elements[a].x = elements [a].x - groundSpeed
    else
      elements:remove(elements[a])
    end
  end        
end


function adicionarColunas() 
  
  height = math.random (display.contentCenterY  , display.contentCenterY )
  topColumn = math.random (50, 100) 

  topColumn = display.newImageRect('images/cactu.png', 200 , 200)
  topColumn.anchorX = 0.5
  topColumn.anchorY = 0
  topColumn.x = display.contentWidth -1.5
  topColumn.y = height - 20
  topColumn.scoreAdded = false
  physics.addBody(topColumn, "static", {density=1,bounce=0.1, friction=0.2})
  elements:insert(topColumn)


  downColumn = display.newImageRect('images/cactudown.png', 150 , 150)
  downColumn.anchorX = -0.5
  downColumn.anchorY =  10
  downColumn.x = display.contentWidth + 100
  downColumn.y = height - 210
  physics.addBody(downColumn, "static", {density=1,bounce=0.1, friction=0.2})
  elements:insert(downColumn)
end 

function scene:create( event )

  dados.score = 0		
  gameStarted = false
  local sceneGroup = self.view
  skySpeed = .2
  backgroundSpeed = 4
  groundSpeed = 10
  backgroundSize = display.contentWidth
  groundSize = display.contentWidth


  background1 = display.newImageRect('images/sky_dune001.png', display.contentWidth,550)
  background1.anchorX = 0
  background1.anchorY = 1
  background1.x = 1
  background1.y = display.contentHeight - 200
  background1.speed = backgroundSpeed
  sceneGroup:insert(background1)

  background2 = display.newImageRect('images/sky_dune001.png',display.contentWidth ,550)
  background2.anchorX = 0
  background2.anchorY = 1
  background2.x = backgroundSize
  background2.y = display.contentHeight - 200
  background2.speed = backgroundSpeed
  sceneGroup:insert(background2)

  elements = display.newGroup()
  elements.anchorChildren = true
  elements.anchorX = 0
  elements.anchorY = 1
  elements.x = 0
  elements.y = 0
  sceneGroup:insert(elements)

  coisa1 = display.newImageRect("images/Skeleton.png", 100, 220 )
  coisa1.anchorX = 10
  coisa1.anchorY = 1
  coisa1.x = 1
  coisa1.y = 10
  coisa1.speed = groundSpeed
  sceneGroup:insert(coisa1)

  coisa2 = display.newImageRect("images/Skeleton.png", 100, 220 )
  coisa2.anchorX = 10
  coisa2.anchorY = 1
  coisa2.x = 1
  coisa2.y = 10
  coisa2.speed = groundSpeed
  sceneGroup:insert(coisa2)


  ground1 = display.newImageRect("images/ground.png", groundSize, 220 )
  ground1.anchorX = 0
  ground1.anchorY = 1
  ground1.x = 0
  ground1.y = display.contentHeight
  ground1.speed = groundSpeed
  sceneGroup:insert(ground1)

  ground2 = display.newImageRect("images/ground.png", groundSize, 220 )
  ground2.anchorX = 0
  ground2.anchorY = 1
  ground2.x = backgroundSize
  ground2.y = display.contentHeight
  ground2.speed = groundSpeed
  sceneGroup:insert(ground2)

    p_options =
    {
      -- Required params
      width = 90,
      height = 80,
      numFrames = 2,
      -- content scaling
      sheetContentWidth = 180,
      sheetContentHeight = 80,
    }

  playerSheet = graphics.newImageSheet( "images/pigeon.png", p_options )
  player = display.newSprite( playerSheet, { name="player", start=1, count=2, time=150 } )
  player.anchorX = 0.5
  player.anchorY = 0.5
  player.x = display.contentCenterX - 100
  player.y = display.contentCenterY
  physics.addBody(player, "static", {density=.1, bounce=0.1, friction=1})
  player:play()
  sceneGroup:insert(player)

  score = display.newText(dados.score, display.contentCenterX, 90, native.systemFont, 60)
  score:setFillColor (0,0,0)
  score.alpha = 0
  sceneGroup:insert(score)

  ground = display.newRect( display.contentCenterX, display.contentHeight -100, backgroundSize, 10 )
  ground.alpha = 0
  physics.addBody(ground, "static", {density=.1, bounce=0.1, friction=.2})
  sceneGroup:insert(ground)
end

function scene:show( event )
 local sceneGroup = self.view
 local phase = event.phase

  if ( phase == "did" ) then

    composer.removeScene("main")
    Runtime:addEventListener("collision", onCollision)

    background1.enterFrame = backgroundScroller
    Runtime:addEventListener("enterFrame", background1)

    background2.enterFrame = backgroundScroller
    Runtime:addEventListener("enterFrame", background2)

    ground1.enterFrame = backgroundScroller
    Runtime:addEventListener("enterFrame", ground1)

    ground2.enterFrame = backgroundScroller
    Runtime:addEventListener("enterFrame", ground2)

    
    Runtime:addEventListener("enterFrame", elements)


    Runtime:addEventListener("touch", flyUp)
    
   
 end
end

function scene:hide( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "will" ) then
    Runtime:removeEventListener("touch", flyUp)
    Runtime:removeEventListener("enterFrame", sky1)
    Runtime:removeEventListener("enterFrame", sky2)
    Runtime:removeEventListener("enterFrame", ground1)
    Runtime:removeEventListener("enterFrame", ground2)
    Runtime:removeEventListener("enterFrame", background1)
    Runtime:removeEventListener("enterFrame", background2)
    Runtime:removeEventListener("collision", onCollision)
    Runtime:removeEventListener("enterFrame", elements)
   	timer.cancel(adicionarColunasTimer)
   	timer.cancel(andarColunasTimer)
   end
end

function scene:destroy( event )
   local sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene