class Particle2 extends Particle
  constructor:(x, y, radius) ->
    @init x, y, radius

  init: (x, y, radius) ->
    @alive = true
    @radius = radius or 10
    @wander = 0.15
    @theta = random(TWO_PI)
    @drag = 0.92
    @color = "#222"
    @x = x or 0.0
    @y = y or 0.0
    @vx = 0.0
    @vy = 0.0

  move: ->
    @x += @vx
    @y += @vy
    @vx *= @drag
    @vy *= @drag
    @theta += random(-0.5, 0.5) * @wander
    @vx += sin(@theta) * 0.1
    @vy += cos(@theta) * 0.1
    @radius *= 0.96
    @alive = @radius > 0.5

  draw: (ctx) ->
    ctx.beginPath()
    ctx.arc @x, @y, @radius, 0, TWO_PI
    ctx.fillStyle = @color
    ctx.fill()


physics = new Physics
physics.integrator = new Verlet

avoid = new Attraction

# ----------------------------------------
# Example
# ----------------------------------------
MAX_PARTICLES = 1000
COLOURS = ["#69D2E7", "#A7DBD8", "#E0E4CC", "#F38630", "#FA6900", "#FF4E50", "#F9D423"]
particles = []
pool = []
demo = Sketch.create(container: document.getElementById("container"))
demo.setup = ->

demo.spawn = (x, y) ->
  pool.push particles.shift()  if particles.length >= MAX_PARTICLES
  particle = (if pool.length then pool.pop() else new Particle2())
  particle.init x, y, random(10, 80)
  particle.wander = random(0.5, 2.0)
  particle.color = random(COLOURS)
  particle.drag = random(.9, .99)
  theta = random(TWO_PI)
  force = random(2, 8)
  particle.vx = sin(theta) * force
  particle.vy = cos(theta) * force
  particles.push particle

demo.update = ->
  i = particles.length - 1
  while i >= 0
    particle = particles[i]
    if particle.alive
      particle.move()
    else
      pool.push particles.splice(i, 1)[0]
    i--

demo.draw = ->
  demo.globalCompositeOperation = "lighter"
  i = particles.length - 1

  while i >= 0
    particles[i].draw demo
    i--
  demo.beginPath()
  demo.arc demo.width / 2, demo.height / 2, 100, 0, TWO_PI
  demo.fillStyle = "white"
  demo.fill()

demo.mousemove = ->
  i = 0
  n = demo.touches.length

  while i < n
    touch = demo.touches[i]
    max = random(1, 4)

    j = 0
    while j < max
      demo.spawn touch.x, touch.y
      j++
    i++

setInterval (->
  
  # Set off some initial particles.
  i = 0
  while i < 20
    x = (demo.width * 0.5) + random(-20, 20)
    y = (demo.height * 0.5) + random(-20, 20)
    demo.spawn x, y
    i++
), 100