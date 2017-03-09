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

//ADATOK ÉS FELDOLGOZÓK

let imageList =
    [ 'https://pbs.twimg.com/profile_images/667444566333792256/AQs3pw3l.jpg'
    , 'https://d.wattpad.com/story_parts/198872024/images/1424219bd33ef331.gif'
    , 'http://cdn.playbuzz.com/cdn/469d0d05-ea81-4175-91a8-05dcdba73015/d98802fc-5741-425f-8494-0da74139e71c.png'
    ];
let currentImage = 0;

$("#_imagelist").innerHtml = genList(imageList);
drawImage();

function drawImage() {
    const url = imageList[relUrl(0)];
    const urlPrev = imageList[relUrl(-1)];
    const urlNext = imageList[relUrl(1)];
    $("#_prev_img").src = urlPrev;
    $("#_img").src = url;
    $("#_next_img").src = urlNext;
}

function relUrl(dir) {
    return (currentImage + dir + imageList.length) % imageList.length;
}

//ESEMÉNYKEZELŐK

function addClick(event) {
    let url = $('#_url').value;
    imageList.push(url);
    if(currentImage === undefined) {
        currentImage = 0;
        drawImage();
    }
    $("#_imagelist").innerHTML = genList(imageList);
}

function prevClick() {
    currentImage = relUrl(-1);
    drawImage();
}

function dirClickGenerator(dir) {
    return function() {
        currentImage = relUrl(dir);
        drawImage();
    }
}

function clickUrl(e) {
    const index = parseInt(e.delegatedTarget.getAttribute('data-index'));
    currentImage = index;
    drawImage();
}

$("#_add").addEventListener('click', addClick, false);
$("#_prev").addEventListener('click', dirClickGenerator(-1), false);
$("#_next").addEventListener('click', dirClickGenerator(+1), false);
delegate("#_imagelist", 'click', 'li', clickUrl);

//HTML-GENERÁTOROK

function genList(list) {
    return list.map(genListItem).join('');
}

function genListItem(url, index) {
    return `<li data-index="${index}">${url}</li>`;
}