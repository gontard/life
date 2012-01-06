(function() {
  var Life, after, draw, every, root, rotateCenter;
  root = typeof exports !== "undefined" && exports !== null ? exports : this;
  Life = (function() {
    function Life(length, width, iterations) {
      this.length = length;
      this.width = width;
      this.iterations = iterations;
      this.cells = [];
    }
    Life.prototype.index = function(x, y) {
      return x * this.length + y;
    };
    Life.prototype.get = function(x, y) {
      return this.cells[this.index(x, y)];
    };
    Life.prototype.set = function(x, y, isAlive) {
      return this.cells[this.index(x, y)] = isAlive;
    };
    Life.prototype.setNext = function(x, y, isAlive) {
      return this.nextCells[this.index(x, y)] = isAlive;
    };
    Life.prototype.count = function(x, y) {
      if (this.get(x, y)) {
        return 1;
      } else {
        return 0;
      }
    };
    Life.prototype.neighbours = function(x, y) {
      return this.count(x - 1, y - 1) + this.count(x - 1, y) + this.count(x - 1, y + 1) + this.count(x, y - 1) + this.count(x, y + 1) + this.count(x + 1, y - 1) + this.count(x + 1, y) + this.count(x + 1, y + 1);
    };
    Life.prototype.next = function() {
      var grid;
      this.nextCells = [];
      grid = this;
      grid.visit(function(x, y) {
        var isAlive, neighbours;
        neighbours = grid.neighbours(x, y);
        isAlive = neighbours === 2 ? grid.get(x, y) : neighbours === 3;
        return grid.setNext(x, y, isAlive);
      });
      return this.cells = this.nextCells;
    };
    Life.prototype.visit = function(visitor) {
      var x, y, _ref, _results;
      _results = [];
      for (x = 0, _ref = this.length - 1; 0 <= _ref ? x <= _ref : x >= _ref; 0 <= _ref ? x++ : x--) {
        _results.push((function() {
          var _ref2, _results2;
          _results2 = [];
          for (y = 0, _ref2 = this.length - 1; 0 <= _ref2 ? y <= _ref2 : y >= _ref2; 0 <= _ref2 ? y++ : y--) {
            _results2.push(visitor(x, y));
          }
          return _results2;
        }).call(this));
      }
      return _results;
    };
    return Life;
  })();
  draw = function(life, ctx) {
    return life.visit(function(x, y) {
      if (life.get(x, y)) {
        ctx.beginPath();
        ctx.arc(x * 10, y * 10, 4, 0, 2 * Math.PI, false);
        ctx.fill();
        return ctx.stroke();
      }
    });
  };
  root.clown = function() {
    var c, life, side;
    side = 50;
    life = new Life(side, side, 110);
    c = side / 2;
    life.set(c - 1, c - 1, true);
    life.set(c - 1, c, true);
    life.set(c - 1, c + 1, true);
    life.set(c, c - 1, true);
    life.set(c + 1, c - 1, true);
    life.set(c + 1, c, true);
    life.set(c + 1, c + 1, true);
    return life;
  };
  after = function(ms, cb) {
    return setTimeout(cb, ms);
  };
  every = function(ms, cb) {
    return setInterval(cb, ms);
  };
  rotateCenter = function(ctx, width, height, angle) {
    ctx.translate(width / 2, height / 2);
    ctx.rotate(angle);
    return ctx.translate(-width / 2, -height / 2);
  };
  root.live = function(life) {
    var canvas, ctx, height, i, timer, width;
    canvas = $('#canvas')[0];
    if (canvas.getContext) {
      ctx = canvas.getContext('2d');
      ctx.font = 'italic 10px sans-serif';
      ctx.strokeStyle = '#911';
      ctx.fillStyle = '#222';
      ctx.lineWidth = 1;
      width = canvas.getAttribute('width');
      height = canvas.getAttribute('height');
      i = 0;
      return timer = every(30, function() {
        if (i === life.iterations) {
          clearInterval(timer);
        }
        ctx.save();
        ctx.clearRect(0, 0, width, height);
        rotateCenter(ctx, width, height, 2 * i / life.iterations * Math.PI);
        draw(life, ctx);
        life.next();
        ctx.restore();
        return i++;
      });
    }
  };
  $(function() {
    return live(clown());
  });
}).call(this);
