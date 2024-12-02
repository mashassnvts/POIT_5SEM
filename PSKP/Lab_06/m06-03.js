    const sendMail = require('sendmail')(); 
    const nodemailer = require('nodemailer'); 

    const TO_EMAIL = 'sosnovetsm@yandex.com'; 

    const transporter = nodemailer.createTransport({
        host: 'smtp.mail.ru',
        port: 587, 
        secure: false, 
        auth: {
            user: 'mashaexample123@mail.ru', 
            pass: 'PzGx1tf9bX33WPqkiree' 
        }
    });

    function send(message) {
        sendMail({
            from: 'mashaexample123@mail.ru',  
            to: TO_EMAIL,              
            subject: 'Сообщение из модуля m0603',
            text: message,              
        }, (err) => {
            if (err) {
                console.error('Ошибка отправки через sendmail:', err);

                const mailOptions = {
                    from: 'mashaexample123@mail.ru', 
                    to: TO_EMAIL,             
                    subject: 'Сообщение из модуля m0603',
                    text: message,             
                };

                transporter.sendMail(mailOptions, (smtpErr, info) => {
                    if (smtpErr) {
                        console.error('Ошибка отправки через nodemailer:', smtpErr);
                    } else {
                        console.log('Сообщение успешно отправлено через nodemailer:', info.response);
                    }
                });
            } else {
                console.log('Сообщение успешно отправлено через sendmail!');
            }
        });
    }

    module.exports = { send };






    //from=mashaexample123@mail.ru&to=sosnovetsm@yandex.com&message=hi!
