const http = require('http');

const server = http.createServer(function(request, response)  {
    const method = request.method;
    const uri = request.url; 
    const version = request.httpVersion;
    const headers = request.headers;
    

  
    let body = '';
    request.on('data', chunk => { 
        body += chunk.toString();
    });

    request.on('end', () => {
        response.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });

        const responseHTML = `
        <html><head></head><body>
            <li>метод: ${method}</li>
            <li>uri: ${uri}</li>
            <li>версия: ${version}</li>
            <li>заголовок: ${JSON.stringify(headers, null, 2)}</li>
            <li>тело: ${body || 'Empty'}</li>
        </body></html>
        `;

        response.end(responseHTML);
    });
});

server.listen(3000  , function () {
    console.log("сервер запущен на порте 3000");
});