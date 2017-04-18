
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