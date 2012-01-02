root = exports ? this

class Grid
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

draw = (grid, ctx) ->
	grid.visit (x, y) ->
		if grid.get(x, y)
			ctx.beginPath()
			ctx.arc(x*10, y*10, 4, 0, 2 * Math.PI, false)
			ctx.fill()
			ctx.stroke()

root.clown = ->
	side = 50
	grid = new Grid(50,50,110)
	# draw a U with 7 cells
	c = side/2 
	grid.set(c-1, c-1, true)
	grid.set(c-1, c  , true)
	grid.set(c-1, c+1, true)
	grid.set(c  , c-1, true)
	grid.set(c+1, c-1, true)
	grid.set(c+1, c  , true)
	grid.set(c+1, c+1, true)
	return grid

after = (ms, cb) -> setTimeout cb, ms
every = (ms, cb) -> setInterval cb, ms

root.live = (grid)->
	canvas = document.getElementById('canvas')
	if canvas.getContext 
		ctx = canvas.getContext('2d')
		ctx.font = 'italic 10px sans-serif';
		ctx.strokeStyle = '#AAAAAA'
		ctx.fillStyle = '#888888'
		ctx.lineWidth = 1

		width = canvas.getAttribute('width')
		height = canvas.getAttribute('height')
		i = 0
		timer = every 100, () ->
			ctx.clearRect(0,0,width,height)
			draw(grid,ctx)
			ctx.fillText(i, 10, 10)
			if i is grid.iterations 
				clearInterval(timer)
			grid.next()
			i++

