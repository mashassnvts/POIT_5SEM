import { createClient } from 'webdav';
import fs from 'fs';
import readline from 'readline';

// Создаем интерфейс для чтения ввода с клавиатуры
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Настройки для WebDAV на Яндекс.Диске
const client = createClient(
  'https://webdav.yandex.ru',  // URL WebDAV сервера
  {
    username: 'sosnovetsm@yandex.com',  // Логин Яндекс
    password: 'vchuecoqohdsttmm',  // Пароль от Яндекс
  }
);

// Функция для ожидания нажатия клавиши
function waitForKeyPress() {
  return new Promise((resolve) => {
    rl.question('Нажмите любую клавишу для продолжения...', () => {
      resolve();
    });
  });
}

// Создание папки
async function createFolder(folderPath) {
  try {
    await client.createDirectory(folderPath);
    console.log(`Папка '${folderPath}' успешно создана.`);
  } catch (error) {
    console.error(`Ошибка при создании папки: ${error}`);
  }
}

// Загрузка файла
async function uploadFile(localFilePath, remoteFilePath) {
  try {
    await client.putFileContents(remoteFilePath, fs.createReadStream(localFilePath));
    console.log(`Файл '${localFilePath}' загружен на сервер как '${remoteFilePath}'.`);
  } catch (error) {
    console.error(`Ошибка при загрузке файла: ${error}`);
  }
}

// Скачивание файла
async function downloadFile(remoteFilePath, localFilePath) {
  try {
    const fileContent = await client.getFileContents(remoteFilePath, { format: 'binary' });
    fs.writeFileSync(localFilePath, fileContent);
    console.log(`Файл '${remoteFilePath}' загружен в '${localFilePath}'.`);
  } catch (error) {
    console.error(`Ошибка при скачивании файла: ${error}`);
  }
}

// Копирование файла
async function copyFile(sourceFilePath, destinationFilePath) {
  try {
    const fileContent = await client.getFileContents(sourceFilePath, { format: 'binary' });
    await client.putFileContents(destinationFilePath, fileContent);
    console.log(`Файл '${sourceFilePath}' скопирован в '${destinationFilePath}'.`);
  } catch (error) {
    console.error(`Ошибка при копировании файла: ${error}`);
  }
}




// Удаление папки
async function deleteFolder(folderPath) {
  try {
    const files = await client.getDirectoryContents(folderPath);
    for (const file of files) {
      await client.deleteFile(file.filename);
    }
    await client.deleteFile(folderPath);  // Удаляем саму папку
    console.log(`Папка '${folderPath}' удалена.`);
  } catch (error) {
    console.error(`Ошибка при удалении папки: ${error}`);
  }
}

// Основная функция
(async () => {
  const remoteFolder = '/test_folder';
  const remoteFile = '/test_folder/test_file.txt';
  const copiedFilePath = '/test_folder/copied_test_file.txt';
  const localFilePath = './local_test_file.txt';

  // Создание папки
  await createFolder(remoteFolder);
  await waitForKeyPress();  

  // Загрузка файла
  await uploadFile(localFilePath, remoteFile);
  await waitForKeyPress();  

  // Скачивание файла
  await downloadFile(remoteFile, './downloaded_test_file.txt');
  await waitForKeyPress();  

  // Копирование файла
  await copyFile(remoteFile, copiedFilePath);
  await waitForKeyPress();  

  // Удаление файла
  await deleteFile(remoteFile);
  await waitForKeyPress();  

  // Удаление папки
  await deleteFolder(remoteFolder);
  await waitForKeyPress();  

  rl.close();  // Закрываем интерфейс чтения
})();
