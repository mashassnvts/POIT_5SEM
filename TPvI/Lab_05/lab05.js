const http = require('http');
const fs = require('fs');
const path = require('path');

const server = http.createServer((req, res) => {
    const url = new URL(req.url, `http://${req.headers.host}`);
    const cacheParm = url.searchParams.get('cache_parm');


    const setCacheHeaders = () => {
        switch (cacheParm) {
            case 'no-cache':
                res.setHeader('Cache-Control', 'no-store');
                break;
            case 'max-age':
                res.setHeader('Cache-Control', 'max-age=3600');
                break;
            case 'expired': 
                res.setHeader('Expires', new Date(Date.now() - 3600000).toUTCString()); 
                res.setHeader('Cache-Control', 'no-cache'); 
                break;
            case 'etag': 
                const etag = "${Math.random().toString(36).substring(2, 15)}";
                res.setHeader('ETag', etag);
                res.setHeader('Cache-Control', 'no-cache'); 
                break;
            default: 
                res.setHeader('Cache-Control', 'no-store');
                break;
        }
    };

    if (url.pathname === '/image') {
        const imagePath = path.join(__dirname, 'anya2005.png');

        if (fs.existsSync(imagePath)) {
            const stat = fs.statSync(imagePath);

            // Устанавливаем кеширующие заголовки
            setCacheHeaders();
            res.setHeader('Last-Modified', stat.mtime.toUTCString());
            res.setHeader('Content-Type', 'image/png');

            res.writeHead(200);
            const imageStream = fs.createReadStream(imagePath);
            imageStream.pipe(res);
        } else {
            res.writeHead(404, { 'Content-Type': 'text/plain' });
            res.end('Image not found');
        }
    } else if (url.pathname === '/script') {
        const scriptContent = 'console.log("Hello from cached JavaScript!");';

        setCacheHeaders();
        res.setHeader('Content-Type', 'application/javascript');

        res.writeHead(200);
        res.end(scriptContent);
    } else if (url.pathname === '/style') {
        const cssContent = `
            body { background-color: red; }
            img { width: 400px; height: 900px; }
        `;

        setCacheHeaders();
        res.setHeader('Content-Type', 'text/css');

        res.writeHead(200);
        res.end(cssContent);
    } else {
        res.writeHead(404, { 'Content-Type': 'text/plain' });
        res.end('Not Found');
    }
});

server.listen(3000, () => {
    console.log('Server is running on http://localhost:3000');
});