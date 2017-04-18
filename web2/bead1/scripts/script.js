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

let dragData = null;

function onDragStart(e) { //target: akit húzunk
    dragData = {
        mirror: e.target,
        pos: getCoord(e.target.parentNode)
    };
}

function onSpareDragStart(e) {
    console.log(e.target.parentNode);
    let pos = getCoord(e.target.parentNode);
    console.log(pos);
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

gameData = new MapData(
    [
        {
            unit: new Unit(UnitType.Laser, Rotation.down, false, false),
            pos: new Pos(1, 1)
        },
        {
            unit: new Unit(UnitType.ExplicitTarget, Rotation.right, false, true),
            pos: new Pos(1, 3)
        }
    ],
    [
        new Unit(UnitType.Double, Rotation.up, true, true),
        new Unit(UnitType.Block, Rotation.up, true, true),
        new Unit(UnitType.Checkpoint, Rotation.up, true, true)
    ],
    1
);
gameMap = new GameMap("#gamefield", "#sparefield", "#targetnum", gameData);

gameMap.gameField.addEventListener("dragstart", onDragStart, false);
gameMap.spareField.addEventListener("dragstart", onSpareDragStart, false);
gameMap.gameField.addEventListener("dragover", onDragOver, false);
gameMap.gameField.addEventListener("dragleave", onDragLeave, false);
gameMap.gameField.addEventListener("drop", createOnDrop(gameMap), false);

$("#clearbutton").addEventListener("click",
    function() {
        $("#laserpath").setAttribute("d", "");
    }
 , this);

$("#evalbutton").addEventListener("click",
    function() {
        gameMap.evaluate();
        drawLaser("#laserpath", gameMap);
    }
 ,this);

gameMap.evaluate();
drawLaser("#laserpath", gameMap);

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