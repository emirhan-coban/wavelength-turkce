import puppeteer from 'puppeteer';
import fs from 'fs';

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    page.on('console', msg => {
        if (msg.type() === 'error') {
            fs.appendFileSync('error.txt', msg.text() + '\n');
        }
    });
    page.on('pageerror', error => {
        fs.appendFileSync('error.txt', error.stack + '\n');
    });

    await page.goto('http://localhost:5173');
    await new Promise(r => setTimeout(r, 2000));

    await page.evaluate(() => {
        const btns = Array.from(document.querySelectorAll('button'));
        const b = btns.find(b => b.textContent && b.textContent.includes('Oyuna Başla'));
        if (b) b.click();
    });
    await new Promise(r => setTimeout(r, 1000));

    await page.evaluate(() => {
        const btns = Array.from(document.querySelectorAll('button'));
        const b = btns.find(b => b.textContent && b.textContent.includes('Oyuna Başla'));
        if (b) b.click();
    });
    await new Promise(r => setTimeout(r, 1000));

    await page.evaluate(() => {
        const btns = Array.from(document.querySelectorAll('button'));
        const b = btns.find(b => b.textContent && b.textContent.includes('Tümünü Seç'));
        if (b) b.click();
    });
    await new Promise(r => setTimeout(r, 500));
    await page.evaluate(() => {
        const btns = Array.from(document.querySelectorAll('button'));
        const b = btns.find(b => b.textContent && b.textContent.includes('Devam Et'));
        if (b) b.click();
    });
    await new Promise(r => setTimeout(r, 1000));

    await page.evaluate(() => {
        const btns = Array.from(document.querySelectorAll('button'));
        const b = btns.find(b => b.textContent && b.textContent.includes('Hazırım'));
        if (b) b.click();
    });
    await new Promise(r => setTimeout(r, 1000));

    await page.evaluate(() => {
        const btns = Array.from(document.querySelectorAll('button'));
        const b = btns.find(b => b.textContent && b.textContent.includes('Görmek'));
        if (b) b.click();
    });
    await new Promise(r => setTimeout(r, 1000));

    await page.evaluate(() => {
        const btns = Array.from(document.querySelectorAll('button'));
        const b = btns.find(b => b.textContent && b.textContent.includes('Hazırım'));
        if (b) b.click();
    });
    await new Promise(r => setTimeout(r, 1000));

    await page.evaluate(() => {
        const txt = document.querySelector('textarea');
        if (txt) {
            const nativeInputValueSetter = Object.getOwnPropertyDescriptor(window.HTMLTextAreaElement.prototype, "value").set;
            nativeInputValueSetter.call(txt, 'test ipucu');
            txt.dispatchEvent(new Event('input', { bubbles: true }));
        }
    });

    await new Promise(r => setTimeout(r, 500));
    await page.evaluate(() => {
        const btns = Array.from(document.querySelectorAll('button'));
        const b = btns.find(b => b.textContent && b.textContent.includes('İpucunu Gönder'));
        if (b && !b.disabled) b.click();
    });

    await new Promise(r => setTimeout(r, 3000));

    console.log('DONE');
    await browser.close();
})();
