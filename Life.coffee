root = exports ? this

class Life
	constructor: (@length, @width, @iterations) -> @cells = []
	index: (x, y) -> x*@length+y
	get: (x, y) -> @cells[@.index(x, y)]
	set: (x, y, isAlive) ->	@cells[@.index(x, y)] = isAlive
	setNext: (x, y, isAlive) ->	@nextCells[@.index(x, y)] = isAlive
	count: (x, y) ->  if @.get(x, y) then 1 else 0

	neighbours: (x, y) ->
		return @.count(x-1, y-1) + @.count(x-1, y) + @.count(x-1, y+1) +
	           @.count(x,   y-1)                      + @.count(x,   y+1) +
		       @.count(x+1, y-1) + @.count(x+1, y) + @.count(x+1, y+1)
	
	next: ->
		@nextCells = []
		grid = this
		grid.visit (x, y) ->
			neighbours = grid.neighbours(x, y)
			isAlive = if neighbours is 2 then grid.get(x, y) else neighbours is 3
			grid.setNext(x, y, isAlive)
		@cells = @nextCells
		
	visit: (visitor) ->
		for x in [0..@length-1]
			for y in [0..@length-1]
				visitor(x, y)

draw = (life, ctx) ->
	life.visit (x, y) ->
		if life.get(x, y)
			ctx.beginPath()
			ctx.arc(x*10, y*10, 4, 0, 2 * Math.PI, false)
			ctx.fill()
			ctx.stroke()


root.clown = ->
	side = 50
	life = new Life(side,side,110)
	# draw a U with 7 cells
	c = side/2 
	life.set(c-1, c-1, true)
	life.set(c-1, c  , true)
	life.set(c-1, c+1, true)
	life.set(c  , c-1, true)
	life.set(c+1, c-1, true)
	life.set(c+1, c  , true)
	life.set(c+1, c+1, true)
	return life

after = (ms, cb) -> setTimeout cb, ms
every = (ms, cb) -> setInterval cb, ms
rotateCenter = (ctx, width, height, angle) ->
	# Move registration point to the center of the canvas
	ctx.translate(width/2, height/2)
		
	# Rotate angle
	ctx.rotate(angle)
	# Move registration point back to the top left corner of canvas
	ctx.translate(-width/2, -height/2)


root.live = (life)->
	canvas = $('#canvas')[0]
	if canvas.getContext 
		ctx = canvas.getContext('2d')
		ctx.font = 'italic 10px sans-serif';
		ctx.strokeStyle = '#911'
		ctx.fillStyle = '#222'
		ctx.lineWidth = 1

		width = canvas.getAttribute('width')
		height = canvas.getAttribute('height')
		i = 0
		timer = every 30, () ->
			if i is life.iterations then clearInterval(timer)
			
			ctx.save()
			ctx.clearRect(0,0,width,height)

			rotateCenter(ctx, width,height, 2 * i / life.iterations * Math.PI)

			draw(life,ctx)
			#ctx.fillText(i, 10, 10)
			life.next()
			ctx.restore()
			i++



$(() -> live(clown()))

