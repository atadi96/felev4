// Segédfüggvények

function $(selector) {
    return document.querySelector(selector);
}

function $$(selector) {
    return document.querySelectorAll(selector);  
}

function delegate(pSel, type, cSel, fn) {
    const p = $(pSel);
    p.addEventListener(type, function (e) {
        let t;
        for (t = e.target;
             t !== p && !t.matches(cSel);
             t = t.parentNode);
        if (t === p) { return; }
        e.delegatedTarget = t;
        fn.call(t, e);
    }, false);
}

// Adatszerkezetek

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
        /*let self = this;
        element.addEventListener("click", function() {
            console.log(self);
            self.rotation = Rotation.clockwise(self.rotation);
            self.updateHTML();
        });*/
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
        let html = '<div ' + (this.moveable ? 'draggable="true"' : "") + '" class="mirror-class">';
        html += '<img src="' + UnitType.picture(this.unitType) + '">';
        if(!this.rotateable) {
            html += '<span class="locked">🔒</span>';
        }
        html += '</div>';
        return html;
    }
    this.clockwise = function() {
        let self = this;
        self.rotation = Rotation.clockwise(self.rotation);
        self.updateHTML();
    }
    this.counterClockwise = function() {
        let self = this;
        self.rotation = Rotation.counterClockwise(self.rotation);
        self.updateHTML();
    }
}

function GameMap(selector) {
    this.element = $(selector);
    this.getField = function(x, y) { 
        if(y === undefined) { //ez confirmed működik 👌
            y = x.y;
            x = x.x;
        }
        return this.element.rows[y].cells[x];
    }
    this.addUnit = function(unit, x, y) {
        unit.attachTo(this.getField(x,y));
        return this;
    }
    setupGameField(this.element);

    function setupGameField(gamefield) {
        let tableHTML = "";
        for(i = 0; i < 5; i++) {
            let row = "<tr>";
            for(j = 0; j < 5; j++) {
                row += "<td></td>";
            }
            row += "</tr>";
            tableHTML += row;
        }
        gamefield.innerHTML = tableHTML;
    }
}

//HTML generators

function setRotation(element, rotation) {
    let value = "rotate(" + Rotation.toDegree(rotation) + "deg)";
    element.style.transform = value;
    element.style.webkitTransform = value;
    element.style.MozTransform = value;
    element.style.msTransform = value;
    element.style.OTransform = value;
}

//Running code

gameMap = new GameMap("#gamefield");

let myFirstUnit = new Unit(UnitType.Laser, Rotation.down, false, false);

gameMap.addUnit(myFirstUnit, 1, 3);