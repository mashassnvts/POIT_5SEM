const http = require('http');
const fs = require('fs');

const server = http.createServer(function(request, response){
    if (request.url === '/fetch') {
        fs.readFile('fetch.html', function(err, data) {
            if (err) {
                response.writeHead(404);
                response.write('file not found')
            } else {
                response.writeHead(200, {'Content-Type': 'text/html'});
                response.write(data);
            }
            response.end();
        });
    }   
    if(request.url == '/api/name'){
        response.writeHead(200, {'Content-Type': 'text/html'});
        response.end('<h1>Sosnovets Maria Igorevna</h1>\n');
    }
});

server.listen(5000, function(){
    console.log("running");
})