function love.load()
  font = love.graphics.setNewFont('assets/computer_pixel-7.ttf', 65)

  frame = 0
  math.randomseed(os.time())
  queue = require("queue")

  width = love.graphics.getWidth()
  height = love.graphics.getHeight()

  up = 0
  down = 1
  left = 2
  right = 3
  side = left


  speed = 0.1

  collision = false

  pause = false

  apple_placed = false
  apple = {}

  score = 0

  board_size = {x = 64*1.5, y = 36*1.5}
  cell_size = {x = width / board_size.x,
               y = height / board_size.y}
  snake = queue.new()
  place_snake()
  --local first, last = queue.getedges(snake)
  --for i = first, last do
  --  print(queue.getn(snake, i).x)
  --end
end

function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  elseif key == 'up' or key == 'w' then
    if side == left or side == right then
      side = up
    end
  elseif key == 'down' or key == 's' then
    if side == left or side == right then
      side = down
    end
  elseif key == 'left' or key == 'a' then
    if side == up or side == down then
      side = left
    end
  elseif key == 'right' or key == 'd' then
    if side == up or side == down then
      side = right
    end
  elseif key == 'p' then
    if pause then
      love.window.setTitle(string.format('snake by kupp | score: %s', score))
    end
    pause = not pause
  end
end

function love.update(dt)
  frame = frame + dt
  if frame >= speed and not collision and not pause then 
    frame = 0
    queue.pop(snake)
    push_to_snake()
  end
  check_apple()
  check_collision()
 end

function love.draw()
    if collision then
      love.graphics.setColor(1, 1, 1)
      print_centered_text('GAME OVER')
      love.window.setTitle('snake by kupp | GAME OVER')
    end
    love.graphics.setBackgroundColor(69/255, 67/255, 67/255)
    if apple_placed then
      love.graphics.setColor(209/255,231/255,81/255)
      love.graphics.rectangle("fill", apple.x * cell_size.x,
                              apple.y * cell_size.y,
                              cell_size.x, cell_size.y)
    end
    love.graphics.setColor(252/255,145/255,58/255)
    local first, last = queue.getedges(snake)
    for i = first, last-1 do
      local v = queue.getn(snake, i)
      love.graphics.rectangle("fill", v.x * cell_size.x,
                              v.y * cell_size.y,
                              cell_size.x, cell_size.y)
    end
    love.graphics.setColor(250/255,2/255,60/255)
    v = queue.getlast(snake)
    love.graphics.rectangle("fill", v.x * cell_size.x,
                              v.y * cell_size.y,
                              cell_size.x, cell_size.y)
  if pause and not collision then
    love.graphics.setColor(1, 1, 1)
    print_centered_text('PAUSE')
    love.window.setTitle('snake by kupp | PAUSE')
  end
end

function place_snake()
  local head = {x = board_size.x / 2 + 2,
                      y = board_size.y / 2}
  for i = 0, 4 do
    queue.push(snake, {x = head.x - i,
                       y = head.y})
  end
end

function push_to_snake()
  local head = queue.getlast(snake)
  if side == left then
    queue.push(snake, {x = head.x - 1,
                       y = head.y})
  elseif side == right then
    queue.push(snake, {x = head.x + 1,
                       y = head.y})
  elseif side == up then
    queue.push(snake, {x = head.x,
                       y = head.y - 1})
  elseif side == down then
    queue.push(snake, {x = head.x,
                       y = head.y + 1})
  end
end

function check_collision()
  local first, last = queue.getedges(snake)
  local head = queue.getlast(snake)
  for i = first, last-1 do
    local v = queue.getn(snake, i)
    if v.x == head.x and v.y == head.y then
      collision = true
      break
    end
  end
  if head.x < 0 or head.x >= board_size.x or 
     head.y < 0 or head.y >= board_size.y then
    collision = true
  end
end

function check_apple()
  local head = queue.getlast(snake)
  if apple_placed and head.x == apple.x and head.y == apple.y then
    score = score + 1
    love.window.setTitle(string.format('snake by kupp | score: %s', score))
    apple_placed = false
    speed = speed - 0.003
    push_to_snake()
  end
  if not apple_placed then
    apple.x = math.random(0, board_size.x-1)
    apple.y = math.random(0, board_size.y-1)
    apple_placed = true
  end
end

function print_centered_text(text)
  local width_offset = font:getWidth(text)
  local height_offset = font:getHeight()
  love.graphics.print(text,
  (width - width_offset) / 2, (height - height_offset) / 2)
end