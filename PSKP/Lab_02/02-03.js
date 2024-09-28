const http = require("http");


const server = http.createServer(function(request,response){
    if(request.url === '/api/name'){
        response.writeHead(200,{'Content-Type': 'text/plain'});
        response.write("Sosnovets Maria Igorevna");
        response.end();
    }
});

server.listen(5000, function(){
    console.log("running");
})