TILE_SIZE = 32
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

MAX_TILES_X = WINDOW_WIDTH / TILE_SIZE
MAX_TILES_Y = math.floor(WINDOW_HEIGHT / TILE_SIZE)

TILE_EMPTY = 0
TILE_SNAKE_HEAD = 1
TILE_SNAKE_BODY = 2
TILE_APPLE = 3

-- time in seconds that the snake moves one tile
SNAKE_SPEED = 0.1

local largeFont = love.graphics.newFont(32)

local score = 0

local tileGrid = {}

local snakeX, snakeY = 1, 1
local snakeMoving = 'right'
local snakeTimer = 0

-- snake data structure
local snakeTiles = {
    {snakeX, snakeY}
}


function love.load()
    love.window.setTitle('Snake50')

    love.graphics.setFont(largeFont)

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false
    })

    math.randomseed(os.time())
    initializeGrid()

    tileGrid[1][1] = TILE_SNAKE_HEAD
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'left' then
        snakeMoving = 'left'
    elseif key == 'right' then
        snakeMoving = 'right'
    elseif key == 'up' then
        snakeMoving = 'up'
    elseif key == 'down' then
        snakeMoving = 'down'    
    end
end

function love.update(dt)
    snakeTimer = snakeTimer + dt

    local priorHeadX, priorHeadY = snakeX, snakeY

    if snakeTimer >= SNAKE_SPEED then
        if snakeMoving == 'up' then
            if snakeY <= 1 then
                snakeY = MAX_TILES_Y
            else
                snakeY = snakeY -  1
            end
        elseif snakeMoving == 'down' then
            if snakeY >= MAX_TILES_Y then
                snakeY = 1
            else
                snakeY = snakeY + 1
            end
        elseif snakeMoving == 'left' then
            if snakeX <= 1 then
                snakeX = MAX_TILES_X
            else
                snakeX = snakeX - 1
            end
        else
            if snakeX >= MAX_TILES_X then
                snakeX = 1
            else
                snakeX = snakeX + 1
            end
        end

        -- check for apple and add to score
        if tileGrid[snakeY][snakeX] == TILE_APPLE then
            score = score + 1

            local newAppleX, newAppleY = math.random(MAX_TILES_X), math.random(MAX_TILES_Y)

            tileGrid[newAppleY][newAppleX] = TILE_APPLE
        end

        -- update the head location
        tileGrid[snakeY][snakeX] = TILE_SNAKE_HEAD

        if #snakeTiles > 1 then
            -- ToDo
        else
            tileGrid[priorHeadY][priorHeadX] = TILE_EMPTY
        end

        snakeTimer = 0
    end
end

function love.draw()
    drawGrid()
    -- drawSnake()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print('Score: ' .. tostring(score), 10, 10)
end

function drawGrid()
    for y = 1, MAX_TILES_Y do
        for x = 1, MAX_TILES_X do
            if tileGrid[y][x] == TILE_EMPTY then

                -- change the color to white for the grid
                -- love.graphics.setColor(1, 1, 1, 1)
                -- love.graphics.rectangle('line', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE,
                -- TILE_SIZE, TILE_SIZE)

            elseif tileGrid[y][x] == TILE_APPLE then

                -- change the color to red for the apple
                love.graphics.setColor(1, 0, 0, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE,
                TILE_SIZE, TILE_SIZE)

            elseif tileGrid[y][x] == TILE_SNAKE_HEAD then

                -- change the color to red for the snakehead
                love.graphics.setColor(0, 1, 0.1, 1)
                love.graphics.rectangle('fill', (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE,
                TILE_SIZE, TILE_SIZE)
            end
        end
    end
end

function drawSnake()
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.rectangle('fill', (snakeX - 1) * TILE_SIZE, (snakeY - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)
end

function initializeGrid()
    for y = 1, MAX_TILES_Y do

        table.insert(tileGrid, {})

        for x = 1, MAX_TILES_X do
            table.insert(tileGrid[y], TILE_EMPTY)
        end
    end

    local appleX, appleY = math.random(MAX_TILES_X), math.random(MAX_TILES_Y)

    tileGrid[appleY][appleX] = TILE_APPLE
end