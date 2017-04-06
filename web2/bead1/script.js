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

gameData = new MapData(
    [
        {
            unit: new Unit(UnitType.Laser, Rotation.left, false, false),
            pos: {x: 1, y: 3}
        },
        {
            unit: new Unit(UnitType.ExplicitTarget, Rotation.up, true, true),
            pos: {x: 0, y: 2}
        }
    ],
    [],
    0
);
gameMap = new GameMap("#gamefield", undefined, undefined, gameData);

gameMap.element.addEventListener("dragstart", onDragStart, false);
gameMap.element.addEventListener("dragover", onDragOver, false);
gameMap.element.addEventListener("dragleave", onDragLeave, false);
gameMap.element.addEventListener("drop", createOnDrop(gameMap), false);
/*
let unit1 = new Unit(UnitType.Laser, Rotation.left, false, false);
let unit2 = new Unit(UnitType.ExplicitTarget, Rotation.up, true, true);

gameMap.addUnit(unit1, 1, 3);
gameMap.addUnit(unit2, 0, 2);*/