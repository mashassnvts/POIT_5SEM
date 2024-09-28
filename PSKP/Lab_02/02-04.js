const http = require("http");
const fs = require("fs");

const server = http.createServer(function (request, response) {
    if (request.url === '/xmlhttprequest') {
        fs.readFile('xmlhttprequest.html', function (err, data) {
            if (err) {
                response.writeHead(404, { 'Content-Type': 'text/plain' });
                response.end('file not found'); 
            } else 
            {
                response.writeHead(200, { 'Content-Type': 'text/html' });
                response.end(data); 
            }
        });
    } else 
    if (request.url === '/api/name') {
        response.writeHead(200, { 'Content-Type': 'text/html' });
        response.end("<h1>Sosnovets Maria Igorevna</h1>");
    } else {
        response.writeHead(404, { 'Content-Type': 'text/plain' });
        response.end('<h1>poka</h1>'); 
    }
});

server.listen(5000, function () {
    console.log("running");
});
