

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
        let prefix = "demo/mirrors/"
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



function MapData(units, spares, targetNum) {
    return Object.freeze(
        {units: units, spares: spares, targetNum: targetNum}
    );
}

function GameMap(
    gameTableSelector,
    spareTableSelector,
    targetNumSelector,
    mapData
) {
    let self = this;
    this.getField = function(x, y) { 
        if(y === undefined) { //ez confirmed működik 👌
            y = x.y;
            x = x.x;
        }
        return this.gameField.rows[y].cells[x];
    }
    this.addUnit = function(unit, x, y) {
        unit.attachTo(this.getField(x,y));
        this.unitMap[x][y] = unit;
        if(unit.unitType == UnitType.Laser) {
            this.laser = unit;
        }
        return this;
    }
    this.evaluate = function() {
        let svgs = [];
        this.laserMap.forEach(function(row) {
                row.forEach(function(laser) {
                    laser.reset();
            }, this);
        }, this);
        let laserPath = [];

        let addConditional = 
            (function(laserPath) {
                return function(fromPos, incomingLaserRot) {
                    let newPos = fromPos.plus(rotToPos(incomingLaserRot));
                    if(newPos.inBounds(self.mapSize, self.mapSize)) {
                        laserPath.push({
                            pos: newPos,
                            rotation: Rotation.opposite(incomingLaserRot)
                        });
                    }
                }
            })(laserPath);

        let noLaserAt = (function(laserMap) {
            return function(pos, rot) {
                return !laserMap[pos.x][pos.y].has(rot);
            }
        })(this.laserMap);

        addConditional(this.laserPos, this.laser.rotation);
        
        while(laserPath.length > 0) {
            if(laserPath[0].pos.inBounds(this.mapSize, this.mapSize)) {
                let field = laserPath[0];
                if(this.getField(field.pos).querySelector(".mirror-class") === null) {
                    this.laserMap[field.pos.x][field.pos.y].add(field.rotation);
                    this.laserMap[field.pos.x][field.pos.y].add(Rotation.opposite(field.rotation));
                    addConditional(field.pos, Rotation.opposite(field.rotation));
                } else {
                    let inRot = field.rotation;
                    let pos = field.pos;
                    let unit = this.unitMap[pos.x][pos.y];
                    let self = this;
                    switch(unit.unitType) {
                        case UnitType.Target:  //******************************************************* Target, ExplicitTarget
                        case UnitType.ExplicitTarget: {
                            let rot = Rotation.minus(inRot, unit.rotation);
                            if(rot == Rotation.down || rot == Rotation.left) {
                                let mirrorRot = 0;
                                if(rot == Rotation.down) {
                                    mirrorRot = Rotation.left;
                                }
                                if(rot == Rotation.left) {
                                    mirrorRot = Rotation.down;
                                }
                                mirrorRot = Rotation.plus(mirrorRot, unit.rotation);
                                this.laserMap[pos.x][pos.y].add(inRot);
                                this.laserMap[pos.x][pos.y].add(mirrorRot);
                                addConditional(pos, mirrorRot);
                            }}
                            break;
                        case UnitType.Semi:{ //********************************************************* Semi
                            let rot = Rotation.minus(inRot, unit.rotation);
                            let mirrorRot = Rotation.plus(3 - rot, unit.rotation);
                            let thruRot = Rotation.plus(Rotation.opposite(rot), unit.rotation);
                            if(noLaserAt(pos, inRot) || noLaserAt(pos, mirrorRot) || noLaserAt(pos, thruRot)) {
                                this.laserMap[pos.x][pos.y].add(inRot);
                                this.laserMap[pos.x][pos.y].add(mirrorRot);
                                this.laserMap[pos.x][pos.y].add(thruRot);
                                addConditional(pos, mirrorRot);
                                addConditional(pos, thruRot);
                            }}
                            break;
                        case UnitType.Double: { //****************************************************** Double
                            let rot = Rotation.minus(inRot, unit.rotation);
                            let mirrorRot = 3 - rot;
                            mirrorRot = Rotation.plus(mirrorRot, unit.rotation);
                            this.laserMap[pos.x][pos.y].add(inRot);
                            this.laserMap[pos.x][pos.y].add(mirrorRot);
                            addConditional(pos, mirrorRot);
                            }
                            break;
                        case UnitType.Checkpoint: //***************************************************** Checkpoint, Block
                        case UnitType.Block:
                            this.laserMap[pos.x][pos.y].add(inRot);
                            this.laserMap[pos.x][pos.y].add(Rotation.opposite(inRot));
                            addConditional(pos, Rotation.opposite(inRot));
                            break;
                        case UnitType.None:
                        case UnitType.Laser:
                        default:
                            break;
                    }
                }
            }
            laserPath.shift();
        }
        this.laserMap[this.laserPos.x][this.laserPos.y].add(this.laser.rotation);

        //check the win condition
        let allExplicit = true;
        let hitTargets = 0;
        let allUsed = true;
        let noSpares = true;
        for(y = 0; y < this.mapSize; y++) {
            for(x = 0; x < this.mapSize; x++) {
                if(this.unitMap[x][y] !== null) {
                    let unit = this.unitMap[x][y];
                    if(unit.unitType == UnitType.Target || unit.unitType == UnitType.ExplicitTarget) { //it's a targetable unit
                        let prevField = (new Pos(x, y)).plus(rotToPos(unit.rotation));
                        if(prevField.inBounds(this.mapSize, this.mapSize) &&
                            this.laserMap[prevField.x][prevField.y].has(Rotation.opposite(unit.rotation))
                        ) { //the target mark was hit on this unit
                            hitTargets += 1;
                            allUsed = allUsed && true;
                            allExplicit = allExplicit && true;
                        } else { //the target mark was not hit on this unit
                            allUsed = allUsed && !this.laserMap[x][y].empty();
                            allExplicit = allExplicit && (unit.unitType == UnitType.Target);
                        }
                    } else { //it's not a targetable unit
                        allUsed = allUsed && (
                            unit.unitType == UnitType.Laser ||
                            unit.unitType == UnitType.Block ||
                            !this.laserMap[x][y].empty()
                        );
                    }
                }
            }
            noSpares = noSpares && (this.unitMap[5][y] === null || this.unitMap[5][y].unitType == UnitType.Block);
        }
        return (noSpares && allExplicit && allUsed && (hitTargets == this.targetNum));
    }
    // ******************************************************************* END OF MEMBER FUNCTION DECLARATIONS
    this.gameField = $(gameTableSelector);
    this.spareField = $(spareTableSelector);
    this.targetNumDisplay = $(targetNumSelector);
    this.laser = undefined;
    this.laserPos = undefined;
    this.targetNum = mapData.targetNum;
    this.unitMap = initArray(6, 5, function() { return null; } );
    this.laserMap = initArray(5, 5, function() { return new Laser(); } )
    this.mapSize = 5;

    let tableHTML = "";
    for(i = 0; i < this.mapSize; i++) {
        let row = "<tr>";
        for(j = 0; j < this.mapSize; j++) {
            row += "<td></td>";
        }
        row += "</tr>";
        tableHTML += row;
    }
    this.gameField.innerHTML = tableHTML;
    let spareHTML = "";
    for(i = 0; i < this.mapSize; i++) {
        let row = "<tr><td></td></tr>";
        spareHTML += row;
    }
    this.spareField.innerHTML = spareHTML;
    this.targetNumDisplay.innerHTML = mapData.targetNum;
    for(i = 0; i < mapData.spares.length; i++) {
        mapData.spares[i].attachTo(this.spareField.rows[i].cells[0]);
        this.unitMap[5][i] = mapData.spares[i];
    }

    delegate(gameTableSelector, "click", "td", createFieldClick(this));

    mapData.units.forEach(function(unitpos) {
        this.addUnit(unitpos.unit, unitpos.pos.x, unitpos.pos.y);
        if(unitpos.unit.unitType == UnitType.Laser) {
            this.laserPos = unitpos.pos;
        }
    }, this);

    
    function createFieldClick(gameMap) {
        return function(e) {
            if(e.delegatedTarget.querySelector(".mirror-class") !== null) {
                let pos = (function(td) { return {x: td.cellIndex, y: td.parentNode.sectionRowIndex}; })(e.delegatedTarget);
                gameMap.unitMap[pos.x][pos.y].clockwise();
            }
        }
    }
    function initArray(x, y, construct) {
        let myArray = new Array(x);
        for(i = 0; i < x; i++) {
            myArray[i] = new Array(y);
            for(j = 0; j < y; j++) {
                myArray[i][j] = construct();
            }
        }
        return myArray;
    }
}



//******************************************************************************************************** GAME


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

let dragData = null;

let gameMap = null;


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
        if(e.target.querySelector(".mirror-class") === null) {
            e.preventDefault();
            e.target.style.backgroundColor = "black";
        }
    }
}

function onDragLeave(e) { //target: aki felett húzzuk
    if(e.target.matches("td")) {
        e.preventDefault();
        e.target.style.backgroundColor = "white";
    }
}

function onDragStart(e) { //target: akit húzunk
    dragData = {
        mirror: e.target,
        pos: getCoord(e.target.parentNode)
    };
}

function onSpareDragStart(e) {
    let pos = getCoord(e.target.parentNode);
    pos.x = 5;
    dragData = {
        mirror: e.target,
        pos: pos
    }
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

function createGame() {
    return function() {
        let mapGen = getMap;
        gameMap =  new GameMap("#gamefield", "#sparefield", "#targetnum", Object.assign({}, mapGen()));

        gameMap.gameField.addEventListener("dragstart", onDragStart, false);
        gameMap.spareField.addEventListener("dragstart", onSpareDragStart, false);
        gameMap.gameField.addEventListener("dragover", onDragOver, false);
        gameMap.gameField.addEventListener("dragleave", onDragLeave, false);
        gameMap.gameField.addEventListener("drop", createOnDrop(gameMap), false);

        $("#game").style.display = "block";

        evalGame();
    }
}

function drawLaser(pathSelector, gameMap) {
    let laserMap = gameMap.laserMap;
    let path = "";
    for(i = 0; i < gameMap.mapSize; i++) {
        for(j = 0; j < gameMap.mapSize; j++) {
            for(rot = 0; rot < 4; rot++) {
                if(laserMap[i][j].has(rot)) {
                    path += `M ${i*90+45} ${j*90+45}`;
                    if(rot % 2 == 0) {
                        path += " v ";
                    } else {
                        path += " h ";
                    }
                    let dir = 0;
                    if(rot == Rotation.up || rot == Rotation.left) {
                        dir = -1;
                    } else {
                        dir = 1;
                    }
                    path += `${45 * dir} `;
                }
            }
        }
    }
    $(pathSelector).setAttribute("d", path);
}

function getMap() {
    return new MapData(
        <?php 
        @require_once('../model/etc.php');
        @require_once('../model/gameMap.php');
        @require_once('../model/form.php');
        $maps = load_from_file('../data/games.json');
        $map = GameMap::fromDatabase($maps[$_GET[Form::MapName]]);
        echo $map->data();
        ?>
    );
}


//let maps = [map1, map2, map3];

//HTML generators *********************************************************************************

function setRotation(element, rotation) {
    let value = "rotate(" + Rotation.toDegree(rotation) + "deg)";
    element.style.transform = value;
    element.style.webkitTransform = value;
    element.style.MozTransform = value;
    element.style.msTransform = value;
    element.style.OTransform = value;
}

function evalGame() {
    let won = gameMap.evaluate();
    drawLaser("#laserpath", gameMap);
    $("#gamewontext").innerHTML = won ? "You win!" : "Try some more...";
    if(won) {
        window.setTimeout(function() {
            alert("You win!");
        }, 100);
    }
}

//Running code **************************************************************************************

$("#clearbutton").addEventListener("click",
    function() {
        $("#laserpath").setAttribute("d", "");
    }
 , this);

$("#evalbutton").addEventListener("click", evalGame, this);

createGame()();