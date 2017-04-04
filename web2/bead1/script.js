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

// Adatszerkezetek *******************************************************************************************

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

function GameMap(selector) {
    this.element = $(selector);
    this.laser = undefined;
    this.unitMap = [];
    this.getField = function(x, y) { 
        if(y === undefined) { //ez confirmed működik 👌
            y = x.y;
            x = x.x;
        }
        return this.element.rows[y].cells[x];
    }
    this.addUnit = function(unit, x, y) {
        unit.attachTo(this.getField(x,y));
        this.unitMap[x][y] = unit;
        if(unit.unitType == UnitType.Laser) {
            this.laser = unit;
        }
        return this;
    }

    function setupGameField(gameMap, selector) {
        let mapSize = 5;
        let gamefield = $(selector);
        let tableHTML = "";
        for(i = 0; i < mapSize; i++) {
            gameMap.unitMap[i] = new Array(mapSize);
            let row = "<tr>";
            for(j = 0; j < mapSize; j++) {
                row += "<td></td>";
                gameMap.unitMap[i][j] = null;
            }
            row += "</tr>";
            tableHTML += row;
        }
        gamefield.innerHTML = tableHTML;
        delegate(selector, "click", "td", createFieldClick(gameMap));
    }

    function createFieldClick(gameMap) {
        return function(e) {
            if(e.delegatedTarget.querySelector(".mirror-class") !== null) {
                let pos = (function(td) { return {x: td.cellIndex, y: td.parentNode.sectionRowIndex}; })(e.delegatedTarget);
                gameMap.unitMap[pos.x][pos.y].clockwise();
            }
        }
    }

    setupGameField(this, selector);
}
/*
function createDragHandler(canDropPredicate, dragLeavePredicate) {
    return Object.freeze({
        dragData: null,
        getCoord: function(td) {
            let x =  td.cellIndex;
            let tr = td.parentNode;
            let y =  tr.sectionRowIndex;
            return {
                x: x,
                y: y
            };
        },
        onDragStart: (function () {
            let self = this;
            return function(e) {
                const dragObject = e.target;
                const td = dragObject.parentNode;
                const fromCoord = self.getCoord(td);
                self.dragData = {
                    dragObject,
                    fromCoord
                }
                e.dataTransfer.dropEffect = "move";
            }
        })(),
        onDragEnd: function(e) {
            if(canDropPredicate(e, dragData)) {
                e.dataTransfer.dropEffect = "move";
                e.target.classList.add('droppable');
                e.preventDefault();
            }
        },
        onDragLeave: function(e) {
            if(dragLeavePredicate(e)) {
                e.preventDefault();
                e.target.classList.remove('droppable');
            }
        }
    });
}*/

function getCoord(td) {
    let col =  td.cellIndex;
    let tr = td.parentNode;
    let row =  tr.sectionRowIndex;
    return {
        x: col,
        y: row
    };
}

function onDragOver(e) { //target: aki felett húzzuk
    if(e.target.matches("td")) {
        e.preventDefault();
        e.target.style.backgroundColor = "black";
    }
}

function onDragLeave(e) { //target: aki felett húzzuk
    if(e.target.matches("td")) {
        e.preventDefault();
        e.target.style.backgroundColor = "white";
    }
}

let dragData = null;

function onDragStart(e) { //target: akit húzunk
    dragData = {
        mirror: e.target,
        pos: getCoord(e.target.parentNode)
    };
}

function createOnDrop(gameMap) {
    return function(e) {
        event.preventDefault();
        e.target.appendChild(dragData.mirror);
        e.target.style.backgroundColor = "white";
        let newCoord = getCoord(e.target);
        gameMap.unitMap[newCoord.x][newCoord.y] = gameMap.unitMap[dragData.pos.x][dragData.pos.y];
        gameMap.unitMap[dragData.pos.x][dragData.pos.y] = null;
    }
}

//HTML generators *********************************************************************************

function setRotation(element, rotation) {
    let value = "rotate(" + Rotation.toDegree(rotation) + "deg)";
    element.style.transform = value;
    element.style.webkitTransform = value;
    element.style.MozTransform = value;
    element.style.msTransform = value;
    element.style.OTransform = value;
}

//Running code **************************************************************************************

gameMap = new GameMap("#gamefield");


gameMap.element.addEventListener("dragstart", onDragStart, false);
gameMap.element.addEventListener("dragover", onDragOver, false);
gameMap.element.addEventListener("dragleave", onDragLeave, false);
gameMap.element.addEventListener("drop", createOnDrop(gameMap), false);

let unit1 = new Unit(UnitType.Laser, Rotation.left, false, false);
let unit2 = new Unit(UnitType.ExplicitTarget, Rotation.up, true, true);

gameMap.addUnit(unit1, 1, 3);
gameMap.addUnit(unit2, 0, 2);