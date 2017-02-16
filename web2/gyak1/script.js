/*
    "use strict";
    //console.log("Helló, " + prompt("Ki vagy?") + "!");
    let nev = prompt("ki vagy?");
    console.log(`Hello, ${nev}!`); //csak a backtickkel megy
*/
'use strict';
for(let i = 1; i <= 6; i++) {
    if(i % 2 == 0) {
        document.write(`<h${i}>Hello</h${i}>`);
    }
}

function search(t) {
    let i;
    for(i = 0; i < t.length && t[i] !== true; ++i);
    return i < t.length ? i : undefined;
    //return t.any(x => x === true);
}

let x = [42, 'alma', undefined, true, 4.3];

console.log(search(x));

function search2(t, T) {
    let i;
    for(i = 0; i < t.length && !T(t[i]); ++i);
    return i < t.length ? i : undefined;
    //return t.any(x => x === true);
}

console.log(search2(x, function (a) {
    return a === true;
}));

console.log(search2(x, x => x === true));

//number
//string
//boolean
//array
//object
//function
//undefined

let konyv = {
    szerzo: "J.R.R. Tolkien",
    cim: "A gyűrűk ura",
    'kiadás éve': "1954",
    kiado: "Allen & Unvin",
    fordito: [
        {
            vezeteknev: 'Réz',
            keresztnev: 'Ádám'
        },
        'Göncz Árpád',
        'Tandori Jenő'
    ]
}

console.log(konyv.szerzo);
console.log(konyv['cim']);
console.log(konyv['kiadás éve']);

/**** WARNING! MINDFUCK AHEAD ****/

1/0;
typeof 1/0; //NaN
(typeof 1)/0;
"number"/0;
typeof NaN;
typeof (1/0); //number
Math.asin(-10);

typeof true + undefined;

'10' + 20;
20 + '10';

let a, b;
a = prompt();
b = prompt();
/*a = parseInt(prompt());
b = parseInt(prompt());*/
alert(a+b);