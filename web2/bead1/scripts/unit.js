

UnitType = Object.freeze({
    None: 0,
    Laser: 1,
    Target: 2,
    ExplicitTarget: 3,
    Semi: 4,
    Double: 5,
    Checkpoint: 6,
    Block: 7,
    picture: function(type) {
        let prefix = "mirrors/"
        switch(type) {
            case UnitType.Laser:
                return prefix + "laser.png";
            case UnitType.Target:
                return prefix + "target.png";
            case UnitType.ExplicitTarget:
                return prefix + "explicit_target.png";
            case UnitType.Semi:
                return prefix + "semi.png";
            case UnitType.Double:
                return prefix + "double.png";
            case UnitType.Checkpoint:
                return prefix + "checkpoint.png";
            case UnitType.Block:
                return prefix + "block.png";
        }
    }
});

function Pos(x, y) {
    this.x = x;
    this.y = y;
    this.plus = function(x, y) {
        if(y === undefined) {
            return new Pos(this.x + x.x, this.y + x.y);
        } else {
            return new Pos(this.x + x, this.y + y);
        }
    }
    this.inBounds = function(x, y) {
        if(y === undefined) {
            y = x.y;
            x = x.x;
        }
        return 0 <= this.x && this.x < x && 0 <= this.y && this.y < y;
    }
}

function Laser() {
    this.myLasers = 0;
    this.add = function(rot) {
        this.myLasers |= 1 << rot;
    }
    this.has = function(rot) {
        return (this.myLasers & (1 << rot)) != 0;
    }
    this.reset = function() {
        this.myLasers = 0;
    }
    this.empty = function() {
        return this.myLasers == 0;
    }
}

function rotToPos(r) {
    switch(r) {
        case Rotation.left :
            return new Pos(-1, 0);
        case Rotation.down :
            return new Pos(0, 1);
        case Rotation.right :
            return new Pos(1, 0);
        case Rotation.up :
            return new Pos(0, -1);
    }
}

Rotation = Object.freeze({
    up: 0,
    right: 1,
    down: 2,
    left: 3,
    plus: function(r1, r2) {
        return (r1 + r2) % 4;
    },
    minus: function(r1, r2) {
        return (r1 - r2 + 4) % 4;
    },
    clockwise: function(r) {
        return this.plus(r, 1);
    },
    counterClockwise: function(r) {
        return this.minus(r, 1);
    },
    toDegree: function(r) {
        return r * 90;
    },
    opposite: function(r) {
        return this.plus(r, 2);
    }
});

function Unit(unitType, rotation, moveable, rotateable) {
    this.unitType = unitType;
    this.rotation = rotation;
    this.moveable = moveable;
    this.rotateable = rotateable;
    this.parent = undefined;
    this.element = undefined;
    this.attachTo = function(element) {
        this.parent = element;
        element.innerHTML = this.toHTML();
        this.element = element.querySelector("div");
        return this.updateHTML();
    }
    this.updateHTML = function() {
        if(this.element === undefined) {
            console.error("Unit.updateHTML: unit must be attached to an element before calling update");
        } else {
            let img = this.element.querySelector('img');
            setRotation(img, this.rotation);
        }
        return this;
    }
    this.toHTML = function() {
        let html = '<div ' + (this.moveable ? 'draggable="true"' : "") + ' class="mirror-class">';
        html += '<img draggable="false" src="' + UnitType.picture(this.unitType) + '">';
        if(!this.rotateable) {
            html += '<span class="locked">🔒</span>';
        }
        html += '</div>';
        return html;
    }
    this.clockwise = function() {
        if(this.rotateable) {
            this.rotation = Rotation.clockwise(this.rotation)
        };
        this.updateHTML();
    }
    this.counterClockwise = function() {
        if(this.rotateable) {
            this.rotation = Rotation.counterClockwise(this.rotation)
        };
        this.updateHTML();
    }
    this.calculate = function(laserInDir, myPos, lasers) {
        return [{pos, rotation}]; //TODO
    }
}
