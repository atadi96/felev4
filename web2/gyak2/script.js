// SEGÉDFÜGGVÉNYEKL ------------------------------------------------------

function $(selector) {
    return document.querySelector(selector);
}

function $$(selector) {
    return document.querySelectorAll(selector);
}

// ADATOK ÉS FELDOLGOZÓK -------------------------------------------------

let todos = [];

// ESEMÉNYKEZELŐK --------------------------------------------------------

function addButtonClickHandler() {
    // Beolvasás

    todo = {
        text: $('#_todo').value,
        owner: $('#_owner').value,
        date: $('#_due').value
    };
    // Feldolgozás
    todos.push(todo);
    // Kiírás
    $('#_tbody').innerHTML += genTodo(todo);
}

$('#_add').addEventListener('click', addButtonClickHandler, false);

// HTML GENERÁTOROK ------------------------------------------------------

function genTodo(todo) {
    return `
        <tr>
            <td>${todo.text}</td>
            <td>${todo.owner}</td>
            <td>${todo.date}</td>
        </tr>
    `;
}
