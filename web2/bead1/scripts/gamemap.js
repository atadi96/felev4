
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
        let laserPath = []//this.laser.calculate(undefined, this.laserPos, this.laserMap); // [{pos, rotation}]

        let addConditional = 
            (function(laserPath) {
                return function(fromPos, incomingLaserRot) {
                    let newPos = fromPos.plus(rotToDir(incomingLaserRot));
                    if(newPos.inBounds(self.mapSize, self.mapSize) &&
                    !self.laserMap[newPos.x][newPos.y].has(Rotation.opposite(incomingLaserRot))
                    ) {
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
            if(laserPath[0].pos.inBounds(this.mapSize, this.mapSize)/* && (!this.laserMap[laserPath[0].pos.x][laserPath[0].pos.y].has(laserPath[0].rotation))*/) {
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
                        case UnitType.None:
                            break;
                        case UnitType.Laser:
                            break;
                        case UnitType.Target:
                        case UnitType.ExplicitTarget: {
                            let rot = Rotation.minus(inRot, unit.rotation);
                            if((rot == Rotation.down || rot == Rotation.left) && noLaserAt(pos, inRot)) {
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
                        case UnitType.Semi:
                            break;
                        case UnitType.Double: {
                            let rot = Rotation.minus(inRot, unit.rotation);
                            if(noLaserAt(pos, inRot)) {
                                let mirrorRot = 3 - rot;
                                mirrorRot = Rotation.plus(mirrorRot, unit.rotation);
                                this.laserMap[pos.x][pos.y].add(inRot);
                                this.laserMap[pos.x][pos.y].add(mirrorRot);
                                addConditional(pos, mirrorRot);
                            }}
                            break;
                        case UnitType.Checkpoint:
                        case UnitType.Block:
                            this.laserMap[pos.x][pos.y].add(inRot);
                            this.laserMap[pos.x][pos.y].add(Rotation.opposite(inRot));
                            addConditional(pos, Rotation.opposite(inRot));
                            break;
                        default:
                            break;
                    }
                }
            }
            laserPath.shift();
        }
        /*this.laserMap[0][1].add(0);
        this.laserMap[0][1].add(1);*/
        this.laserMap[this.laserPos.x][this.laserPos.y].add(this.laser.rotation);
    }
    // ******************************************************************* END OF MEMBER FUNCTION DECLARATIONS
    this.gameField = $(gameTableSelector);
    this.spareField = $(spareTableSelector);
    this.targetNumDisplay = $(targetNumSelector);
    this.laser = undefined;
    this.laserPos = undefined;
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