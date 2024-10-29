const express = require('express');
const session = require('express-session');

const app = express();
app.use(express.json());

app.use(session({
    secret: 'your_secret_key', // Замените на ваш секретный ключ
    resave: false,
    saveUninitialized: true,
    cookie: { maxAge: 60 * 60 * 1000 } // Время жизни сессии
}));

app.post('/data', (req, res) => {
    const { x, y } = req.body;

    if (typeof x !== 'number' || typeof y !== 'number' || x <= 0 || y <= 0) {
        return res.status(400).json({ error: 'x and y must be positive integers.' });
    }

    if (!req.session.accumulatedData) {
        req.session.accumulatedData = { sx: 0, sy: 0 };
    }

    req.session.requestCount = (req.session.requestCount || 0) + 1;

    req.session.accumulatedData.sx += x;
    req.session.accumulatedData.sy += y;

    // Если запрос кратен 5, сбросить накопление
    if (req.session.requestCount % 5 === 0) {
        req.session.accumulatedData = { sx: 0, sy: 0 };
    }

    res.json(req.session.accumulatedData);
});

app.get('/', (req, res) => {
    res.send('<h1>Hello world!</h1>');
});

app.listen(3000, () => {
    console.log('Server is running on http://localhost:3000');
});