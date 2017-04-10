

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
            return Pos(this.x + x.x, this.y + x.y);
        } else {
            return Pos(this.x + x, this.y + y);
        }
    }
}

Rotation = Object.freeze({
    up: 0,
    right: 1,
    down: 2,
    left: 3,
    clockwise: function(r) {
        return (r + 1 + 4) % 4;
    },
    counterClockwise: function(r) {
        return (r - 1 + 4) % 4;
    },
    toDegree: function(r) {
        return r * 90;
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
}