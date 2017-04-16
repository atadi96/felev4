
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
    this.gameField = $(gameTableSelector);
    this.laser = undefined;
    this.unitMap = [];
    this.getField = function(x, y) { 
        if(y === undefined) { //ez confirmed működik 👌
            y = x.y;
            x = x.x;
        }
        return this.gameField.rows[y].cells[x];
    }
    this.addUnit = function(unit, x, y) {
        unit.attachTo(this.getField(x,y));
        console.log(this.unitMap);
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

    setupGameField(this, gameTableSelector);
    mapData.units.forEach(function(unitpos) {
        this.addUnit(unitpos.unit, unitpos.pos.x, unitpos.pos.y);
    }, this);
}