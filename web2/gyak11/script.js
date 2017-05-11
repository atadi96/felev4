//SEGÉDFÜGGVÉNYEK

function $(selector) {
    return document.querySelector(selector);
}

function $$(s) {
    return document.querySelectorAll(s);
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

function ajax(opts) { 
  var mod    = opts.mod        || 'GET',
      url      = opts.url      || '',
      getadat  = opts.getadat  || '',
      postadat = opts.postadat || '',
      siker    = opts.siker    || function(){},
      hiba     = opts.hiba     || function(){};

  mod = mod.toUpperCase();
  url = url+'?'+getadat;
  var xhr = new XMLHttpRequest(); // ujXHR();
  xhr.open(mod, url, true);
  if (mod === 'POST') {
    xhr.setRequestHeader('Content-Type', 
      'application/x-www-form-urlencoded');
  }
  xhr.addEventListener('readystatechange', function () {
    if (xhr.readyState == 4) {
      if (xhr.status == 200) {
        siker(xhr, xhr.responseText);
      } else {
        hiba(xhr);
      }
    }
  }, false);
  xhr.send(mod == 'POST' ? postadat : null);
  return xhr;
}

//ADATOK ÉS FELDOLGOZÓK

let game = [[]];
const color = Math.random > 0.5 ? 'blue' : 'red';

function getGame() {
    //
    ajax({
        mod: 'GET',
        url: 'getgame.php',
        siker: function(xhr, jsonData) {
            game = JSON.parse(jsonData);
            $('table').innerHTML = genTable(game);
        }
    });
}
setInterval(getGame, 500);

function genTable() {
    let table = "";
    game.forEach(function(row) {
        table += "<tr>";
        row.forEach(function(cell) {
            table += `<td data-x="${cell.x}" data-y="${cell.y}" style="background: ${cell.color}"></td>`
        }, this);
        table += "</tr>";
    }, this);
    return table;
}

function clickCell(e) {
    let x = e.delegatedTarget.getAttribute('data-x');
    let y = e.delegatedTarget.getAttribute('data-y');
    ajax({
        mod: 'POST',
        url: 'modcell.php',
        postadat: `x=${x}&y=${y}&color=${color}`,
        hiba: function() {
            console.error('a szerver nem elérhető');
        }
    });
}
delegate('table', 'click', 'td', clickCell);