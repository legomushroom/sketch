# Create a physics instance which uses the Verlet integration method
physics = new Physics()
physics.integrator = new Verlet()

# Design some behaviours for particles
avoidMouse = new Attraction()
avoid = new Attraction()
avoid2 = new Attraction()
avoid3 = new Attraction()
avoid4 = new Attraction()
avoid5 = new Attraction()
avoid6 = new Attraction()
avoid7 = new Attraction()

pullToCenter = new Attraction()

# Allow particle collisions to make things interesting
collision = new Collision()

# Use Sketch.js to make life much easier
sketch = Sketch.create(container: document.body)

class Circle extends Particle
  constructor:(radius) ->
    super
    @init(radius)

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
    ctx.arc @pos.x, @pos.y, @radius/.25, 0, Math.PI * 2
    # ctx.fillStyle = @color
    ctx.fillStyle = '#fff'
    ctx.fill()


COLORS = ["#69D2E7", "#A7DBD8", "#E0E4CC", "#F38630", "#FA6900", "#FF4E50", "#F9D423"]

sketch.setup = ->
  i = 0

  halfWidth = @width/2
  halfHeight = @height/2
  coeff = 1000
  while i < 150
    # Create a particle
    particle = new Circle(random(.25,.75))
    position = new Vector((50*i) % (@width), halfHeight+random(-100,100))
    particle.setRadius particle.mass * 10
    particle.moveTo position
    particle.color = COLORS[(i%COLORS.length)%2]
    
    # Make it collidable
    collision.pool.push particle
    
    # Apply behaviours
    particle.behaviours.push avoidMouse, pullToCenter, collision, avoid, avoid2, avoid3, avoid4, avoid5, avoid6, avoid7
    # Add to the simulation
    physics.particles.push particle
    i++

  pullToCenter.target.x = @width / 2
  pullToCenter.target.y = @height/ 2
  pullToCenter.strength = 50
  avoidMouse.setRadius 50
  avoidMouse.strength = -400
  
  avoid.setRadius 40
  avoid.strength = -1000
  avoid.target.x = @width/2
  avoid.target.y = @height/2

  size = 25

  avoid2.setRadius size
  avoid2.strength = -1000
  avoid2.target.x = @width/2 + (size/2)
  avoid2.target.y = @height/2

  avoid3.setRadius size
  avoid3.strength = -1000
  avoid3.target.x = @width/2 + 2*(size/2)
  avoid3.target.y = @height/2

  avoid4.setRadius size
  avoid4.strength = -1000
  avoid4.target.x = @width/2 + 3*(size/2)
  avoid4.target.y = @height/2

  avoid5.setRadius size
  avoid5.strength = -1000
  avoid5.target.x = @width/2 + 4*(size/2)
  avoid5.target.y = @height/2

  avoid6.setRadius size
  avoid6.strength = -1000
  avoid6.target.x = @width/2 + 5*(size/2)
  avoid6.target.y = @height/2

  avoid7.setRadius size
  avoid7.strength = -1000
  avoid7.target.x = @width/2 + 6*(size/2)
  avoid7.target.y = @height/2
  
  # sketch.fillStyle = "#ff00ff"

sketch.draw = ->
  
  # Step the simulation
  physics.step()
  
  # Render particles
  i = 0
  n = physics.particles.length

  while i < n
    particle = physics.particles[i]
    particle.draw sketch
    # sketch.globalCompositeOperation = "lighten"
    # sketch.globalAlpha = 0.5
    i++

sketch.mousemove = ->
  avoidMouse.target.x = sketch.mouse.x
  avoidMouse.target.y = sketch.mouse.y






