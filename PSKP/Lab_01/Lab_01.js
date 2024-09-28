const http = require("http");

const server = http.createServer(function(request,response){
    response.writeHead(200, {'Content-Type': 'text/html'});
    response.end('<h2>Hel222lo, world!</h2>');
});
server.listen(3000, function() {
console.log("Сервер запущен на порте 3000")});
