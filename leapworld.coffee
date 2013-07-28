
# World definition
World =
  hero:
    x: 0
    y: 0
    dx: 1
    dy: 1
  projectiles: []

# Canvas things
canvas = document.getElementById('canvas')
canvas.width = canvas.clientWidth
canvas.height = canvas.clientHeight
ctx = canvas.getContext('2d')

# Constants
BUFFER_ZONE = 200

#
#
# Logic stuffs
#
#

move_hero = (leap) ->
  if hero_is_moving_right(leap) and World.hero.x < canvas.width
    World.hero.x += World.hero.dx
  else if hero_is_moving_left(leap) and World.hero.x > 0
    World.hero.x -= World.hero.dx

# Used to know if our hero is supposed to move to the right
hero_is_moving_right = (leap) ->
  get_finger_x(leap.fingers[0]) > canvas.width/2 + BUFFER_ZONE

# Used to know if our hero is supposed to move to the right
hero_is_moving_left = (leap) ->
  get_finger_x(leap.fingers[0]) < canvas.width/2 - BUFFER_ZONE


handle_circle_gesture = (leap) ->
  World.projectiles.push {
    x: get_finger_x(leap.fingers[0])
    y: 100
    dx: 10
    dy: 0
  }
  console.log(World.projectiles)


#
#
# DRAWING STUFFS
#
#


# Use scaling to make this not a pain in the ass
get_finger_x = (finger) ->
  MAX_LEFT = -200
  MAX_RIGHT = 100
  x = finger.tipPosition[0]

  if x < MAX_LEFT
    0
  else if x > MAX_RIGHT
    canvas.width
  else
    Math.round((finger.tipPosition[0] + (-MAX_LEFT)) / 300 * canvas.width)


reset_canvas = () ->
  canvas.width = canvas.width + 1
  canvas.width = canvas.width - 1


# Draw our hero
draw_hero = (x, y) ->
  hero = new Image()
  hero.src = 'https://www.pranav.io/leapworld/pusheen.gif'
  ctx.drawImage(hero, x, y, 100, 100)

# Main loop function
render = (leap) ->
  # Handle movement on the x axis
  if leap.fingers.length > 0
    console.log(leap.gestures)
    move_hero leap

  # Handle gestures
  if leap.gestures.length > 0
    console.log('you circling bro')
    handle_circle_gesture(leap)

  # Actually draw the thing
  reset_canvas()
  draw_hero(World.hero.x, World.hero.y)

# Main loop
Leap.loop(render)
