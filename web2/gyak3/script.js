//SEGÉDFÜGGVÉNYEK

function $(selector) {
    return document.querySelector(selector);
}

//ADATOK ÉS FELDOLGOZÓK
let o1, o2, op;
let isLastOp = false;

function calc(a, b, o) {
    switch(o) {
        case "+":
            return a+b;
            break;
        case "-":
            return a-b;
            break;
        case "/":
            return a/b;
            break;
        case "×":
            return a*b;
            break;
    }
}

//ESEMÉNYKEZELŐK

function delegate(pSel, type, cSel, fn) {
    const parent = $(pSel);

    function handler(event) {
        let target = event.target;
        while(!target.matches(cSel) && target != parent) {
            target = target.parentNode;
        }
        if(target == parent) {
            return;
        }
        event.delegatedTarget = target;
        fn.call(parent, event);
    }
    parent.addEventListener(type, handler);
}

function clickButton(event) {
    let data = event.delegatedTarget.getAttribute('data-value');
    if(!isNaN(parseInt(data))) { //szám
        if(isLastOp) {
            $('output').innerHTML = data;
            isLastOp = false;
        } else {
            $('output').innerHTML += data;
        }
    } else if (data === '=') { //egyenlőségjel
        isLastOp = true;
        o2 = parseInt($('output').innerHTML);
        $('output').innerHTML = calc(o1, o2, op);
        o1 = undefined;
        o2 = undefined;
        op = undefined;
    } else { //műveleti jel
        isLastOp = true;
        if(o1 !== undefined && op !== undefined) {
            o2 = parseInt($('output').innerHTML);
            $('output').innerHTML = calc(o1, o2, op);
            op = data;
            o1 = parseInt($('output').innerHTML);
            o2 = undefined;
        } else {
            op = data;
            o1 = parseInt($('output').innerHTML);
            $('output').innerHTML = "";
        }
    }
    console.log(o1, o2, op);
}

delegate('table', 'click', 'button', clickButton);