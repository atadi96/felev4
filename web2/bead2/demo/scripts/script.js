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

function createGame(mapId) {
    return function() {
        let mapGen = null;
        switch(mapId) {
            case 0:
                mapGen = getMap1;
                break;
            case 1:
                mapGen = getMap2;
                break;
            case 2:
                mapGen = getMap3;
                break;
            default:
                mapGen = getMap1;
                break;
        }
        gameMap =  new GameMap("#gamefield", "#sparefield", "#targetnum", Object.assign({}, mapGen()));

        gameMap.gameField.addEventListener("dragstart", onDragStart, false);
        gameMap.spareField.addEventListener("dragstart", onSpareDragStart, false);
        gameMap.gameField.addEventListener("dragover", onDragOver, false);
        gameMap.gameField.addEventListener("dragleave", onDragLeave, false);
        gameMap.gameField.addEventListener("drop", createOnDrop(gameMap), false);

        $("#game").style.display = "block";
        $("#menu").style.display = "none";

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

function getMap1() {
    return new MapData(
    [
        {
            unit: new Unit(UnitType.Laser, Rotation.down, false, false),
            pos: new Pos(1, 1)
        },
        {
            unit: new Unit(UnitType.ExplicitTarget, Rotation.right, false, true),
            pos: new Pos(3, 3)
        }
    ],
    [
        new Unit(UnitType.Double, Rotation.up, true, true),
    ],
    1
    );
}
function getMap2() {
    return new MapData(
    [
        {
            unit: new Unit(UnitType.Laser, Rotation.left, false, true),
            pos: new Pos(0, 0)
        },
        {
            unit: new Unit(UnitType.ExplicitTarget, Rotation.right, false, true),
            pos: new Pos(4, 0)
        },
        {
            unit: new Unit(UnitType.Double, Rotation.left, false, false),
            pos: new Pos(3, 1)
        },
        {
            unit: new Unit(UnitType.Block, Rotation.down, false, true),
            pos: new Pos(2, 2)
        },
    ],
    [
        new Unit(UnitType.ExplicitTarget, Rotation.left, true, true),
        new Unit(UnitType.Semi, Rotation.up, true, true),
    ],
    2
    );
}

function getMap3() {
    return new MapData(
    [
        {
            unit: new Unit(UnitType.Laser, Rotation.right, false, true),
            pos: new Pos(1, 2)
        },
        {
            unit: new Unit(UnitType.Target, Rotation.left, false, true),
            pos: new Pos(2, 0)
        },
        {
            unit: new Unit(UnitType.Target, Rotation.left, false, true),
            pos: new Pos(4, 0)
        },
        {
            unit: new Unit(UnitType.Target, Rotation.up, false, false),
            pos: new Pos(3, 2)
        },
        {
            unit: new Unit(UnitType.Checkpoint, Rotation.down, false, false),
            pos: new Pos(4, 3)
        },
        {
            unit: new Unit(UnitType.Double, Rotation.right, false, false),
            pos: new Pos(0, 4)
        },
    ],
    [
        new Unit(UnitType.Target, Rotation.left, true, true),
        new Unit(UnitType.Target, Rotation.left, true, true),
        new Unit(UnitType.Semi, Rotation.up, true, true),
    ],
    2
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
$("#lvl1btn").addEventListener("click", createGame(0), this);
$("#lvl2btn").addEventListener("click", createGame(1), this);
$("#lvl3btn").addEventListener("click", createGame(2), this);

$("#backbutton").addEventListener("click", 
    function() {
        $("#game").style.display = "none";
        $("#menu").style.display = "initial";
        gameMap.gameField.innerHTML = "";
        gameMap.spareField.innerHTML = "";
        gameMap.targetNumDisplay.innerHTML = "";
        let newTable = gameMap.gameField.cloneNode(true);
        gameMap.gameField.parentNode.replaceChild(newTable, gameMap.gameField);
        for(i = 0; i < 6; i++) {
            for(j = 0; j < 5; j++) {
                gameMap.unitMap[i][j] = null;
            }
        }
        gameMap = null;
    }
, this);
