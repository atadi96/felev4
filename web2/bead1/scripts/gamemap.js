
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

    this.gameField = $(gameTableSelector);
    this.spareField = $(spareTableSelector);
    this.targetNumDisplay = $(targetNumSelector);
    this.laser = undefined;
    this.unitMap = initArray(5, 6, function() { return null; } );
    this.laserMap = initArray(5, 5, function() { return new Laser(); } )

    let mapSize = 5;
    let tableHTML = "";
    for(i = 0; i < mapSize; i++) {
        let row = "<tr>";
        for(j = 0; j < mapSize; j++) {
            row += "<td></td>";
        }
        row += "</tr>";
        tableHTML += row;
    }
    this.gameField.innerHTML = tableHTML;
    let spareHTML = "";
    for(i = 0; i < mapSize; i++) {
        let row = "<tr><td></td></tr>";
        spareHTML += row;
    }
    this.spareField.innerHTML = spareHTML;
    this.targetNumDisplay.innerHTML = mapData.targetNum;
    for(i = 0; i < mapData.spares.length; i++) {
        mapData.spares[i].attachTo(this.spareField.rows[i].cells[0]);
        this.unitMap[i][5] = mapData.spares[i];
    }

    delegate(gameTableSelector, "click", "td", createFieldClick(this));

    mapData.units.forEach(function(unitpos) {
        this.addUnit(unitpos.unit, unitpos.pos.x, unitpos.pos.y);
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