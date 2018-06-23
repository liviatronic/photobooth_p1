var chokidar = require('chokidar');
var exec = require('child_process').exec;

let print = "lp -d Brother_PJ-623 -o landscape -o scaling=75 -o media=A4 ";

function sendprint(whatoprint) {
    //speak the string
    console.log(print + whatoprint);
    exec(print + whatoprint);
}

chokidar.watch('img', {
    ignored: /(^|[\/\\])\../
}).on('all', (event, path) => {
    console.log(event, path);
    if (event === 'add') {
        sendprint(path);
    }

});