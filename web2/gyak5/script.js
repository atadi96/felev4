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

let state;

function init(state) {
    return {
        p1: {
            y: Math.round(screen.availHeight / 2),
            score: state === undefined ? 0 : state.p1.score
        },
        p2: {
            y: Math.round(screen.availHeight / 2),
            score: state === undefined ? 0 : state.p2.score
        },
        ball: {
            y: Math.round(screen.availHeight / 2),
            x: Math.round(screen.availWidth / 2),
            v: {
                x: (Math.random() < 0.5 ? 1 : -1 ) * screen.availWidth / 200,
                y: Math.round((Math.random() * screen.availHeight - screen.availHeight * 0.5) / 100)
            }
        }
    };
}

function step(state) {
    state.ball.x += parseInt(state.ball.v.x);
    state.ball.y += parseInt(state.ball.v.y);
    if(state.ball.y <= 0) {
        state.ball.v.y *= -1;
    }
    if(state.ball.v.y >= screen.availHeight-30) {
        state.ball.v.y *= -1;
    }
    if(state.ball.x < 30 &&
        ((state.ball.y - state.p1.y) >= 0) &&
        (state.ball.y - state.p1.y) <= 150) {
        state.ball.vy *= -1;
    }
    if(state.ball.y > screen.availWidth - 30 &&
        ((state.ball.y - state.p2.y) >= 0) &&
        (state.ball.y - state.p2.y) <= 150) {
        state.ball.vy *= -1;
    }
    if(state.ball.x < 0) {
        state.p2.score += 1;
        state = init(state);
    } 
    if(state.ball.x > screen.availWidth) {
        state.p1.score += 1;
        state = init(state);
    }
    return state;
}

function draw(state) {
    let p1 = $("#p1");
    let p2 = $("#p2");
    let ball = $("#ball");

    p1.style.top = state.p1.y + "px";
    p2.style.top = state.p2.y + "px";
    ball.style.top = state.ball.y + "px";
    ball.style.left = state.ball.x + "px";
    $('#p2score').innerHTML = state.p2.score;
    $('#p1score').innerHTML = state.p1.score
}
let timer;
function pressEnter(e) {
    if(e.keyCode == 13) {
        state = init();
        draw(state);
        clearInterval(timer);
        timer = setInterval(function() {
            draw(state);
            state = step(state);
        }, 20);
    }
}

document.addEventListener("keydown", pressEnter);

function pressMove(e) {
    let speed = 7;
    if(e.key === "w") {
        state.p1.y -= speed;
    } else if(e.key === "s") {
        state.p1.y += speed;
    } else if(e.key === "i") {
        state.p2.y -= speed;
    } else if(e.key === "k") {
        state.p2.y += speed;
    }
}
document.addEventListener("keydown", pressMove);
