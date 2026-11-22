// 스토어 자료를 그린다: 휴대폰 스크린샷(1080×1920, 위에 한 줄 설명) · 그래픽 이미지(1024×500) · 아이콘(512).
// 원본 화면은 store/raw(에뮬레이터 1080×2400). 실행: node store/make.js (playwright-core + 크롬)
const { chromium } = require(process.env.PW || 'playwright-core');
const fs = require('fs');
const path = require('path');
const DIR = __dirname;
const img = (f) => 'data:image/png;base64,' + fs.readFileSync(path.join(DIR, f)).toString('base64');

const CHIP = `<svg viewBox="0 0 28 28" width="100%" height="100%"><rect x="6" y="6" width="16" height="16" rx="3" fill="none" stroke="#7EE04B" stroke-width="1.8"/><rect x="10.5" y="10.5" width="7" height="7" rx="1" fill="#7EE04B"/><path d="M10 1.5v4.5M14 1.5v4.5M18 1.5v4.5M10 22v4.5M14 22v4.5M18 22v4.5M1.5 10h4.5M1.5 14h4.5M1.5 18h4.5M22 10h4.5M22 14h4.5M22 18h4.5" stroke="#7EE04B" stroke-width="1.6" stroke-linecap="round"/></svg>`;
const FONTS = `<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;700&family=Noto+Sans+KR:wght@500;700;900&display=block" rel="stylesheet">`;
const BASE = `*{margin:0;box-sizing:border-box}body{background:#0A0C0B;color:#EDF2EE;font-family:'Space Grotesk','Noto Sans KR',sans-serif}`;

const shots = {
  ko: [
    ['1-board', 'PC 부품 시세를<br><b>주식처럼</b>', 'VGA·RAM·CPU·SSD 101개 종목 · 매시간 갱신'],
    ['2-chart', '누르면 바로<br><b>가격 차트</b>', '1일부터 전체까지 · 선·봉 · 제조사·모델별'],
    ['3-alert', '원하는 가격이 되면<br><b>알림</b>', '목표가를 걸어 두면 매시간 확인해 푸시로'],
    ['4-filter', '보고 싶은 것만<br><b>골라 보기</b>', '용량·규격·브랜드 · 세대·시리즈 필터'],
    ['5-cpu', 'CPU·SSD까지<br><b>한 앱에서</b>', 'eBay·다나와 상품으로 바로 이동'],
  ],
  en: [
    ['1-board', 'PC part prices,<br><b>like a stock ticker</b>', '101 GPUs, RAM, CPUs & SSDs · updated hourly'],
    ['2-chart', 'Tap for the<br><b>price chart</b>', '1 day to all time · line or candles · by brand & model'],
    ['3-alert', 'Get alerted at<br><b>your price</b>', 'Set a target, we check every hour'],
    ['4-filter', 'Filter to<br><b>what you want</b>', 'Capacity, interface, brand, generation, series'],
    ['5-cpu', 'CPUs and SSDs<br><b>in one app</b>', 'Jump straight to the eBay listing'],
  ],
};

function shotHtml(raw, title, sub) {
  return `<html><head>${FONTS}<style>${BASE}
  body{width:1080px;height:1920px;overflow:hidden;position:relative;
    background:radial-gradient(900px 600px at 50% 18%, #14241099, transparent 70%), #0A0C0B}
  .cap{position:absolute;top:110px;left:0;right:0;text-align:center}
  h1{font-size:84px;line-height:1.18;font-weight:700;letter-spacing:-1.5px}
  h1 b{color:#7EE04B;font-weight:900}
  p{margin-top:28px;font-size:36px;color:#8E978F;font-weight:500}
  .phone{position:absolute;left:50%;top:520px;transform:translateX(-50%);width:680px;height:1511px;border-radius:64px;
    border:10px solid #232825;overflow:hidden;box-shadow:0 0 0 2px #2F3631, 0 40px 120px #000, 0 0 160px #7EE04B22}
  .phone img{width:100%;display:block}
  </style></head><body><div class="cap"><h1>${title}</h1><p>${sub}</p></div>
  <div class="phone"><img src="${raw}"></div></body></html>`;
}

function featureHtml(lang) {
  const name = lang === 'ko' ? '파츠스톡' : 'partstock';
  const tag = lang === 'ko' ? 'PC 부품 시세를 주식처럼' : 'PC part prices, like a stock ticker';
  const sub = lang === 'ko' ? 'VGA · RAM · CPU · SSD  ·  매시간 갱신  ·  목표가 알림' : 'GPU · RAM · CPU · SSD  ·  Hourly  ·  Price alerts';
  // 실제 값(11/22 20시, 1주 등락 = /api/chart range=1w). 계산 방식을 바꾼 램은 이번 주 등락이 시장 움직임이 아니라 뺐다
  const rows = lang === 'ko'
    ? [['RTX 5070 Ti', '187.4만원', '▼ 0.07%', '#5C9DFF'], ['RTX 5060 Ti 16GB', '114.5만원', '▼ 2.40%', '#5C9DFF'], ['RTX 5070', '127.2만원', '▲ 0.05%', '#FF6464']]
    : [['RTX 5070 Ti', '$1,399', '▼ 0.07%', '#FF6464'], ['RTX 5060 Ti 16GB', '$855', '▼ 2.40%', '#FF6464'], ['RTX 5070', '$950', '▲ 0.05%', '#34D399']];
  const week = lang === 'ko' ? '1주' : '1W';
  return `<html><head>${FONTS}<style>${BASE}
  body{width:1024px;height:500px;overflow:hidden;position:relative;
    background:radial-gradient(500px 380px at 20% 40%, #16281299, transparent 70%), #0A0C0B}
  .l{position:absolute;left:64px;top:96px;width:470px}
  .logo{display:flex;align-items:center;gap:18px}
  .chip{width:76px;height:76px}
  .name{font-size:${lang === 'ko' ? 72 : 70}px;font-weight:${lang === 'ko' ? 900 : 700};letter-spacing:-1.5px}
  .name span{color:#7EE04B}
  .tag{margin-top:30px;font-size:${lang === 'ko' ? 34 : 31}px;font-weight:700;line-height:1.3}
  .sub{margin-top:16px;font-size:19px;color:#8E978F}
  .card{position:absolute;right:56px;top:58px;width:400px;height:384px;border-radius:24px;background:#121513;border:1px solid #1E2320;padding:22px 24px;box-shadow:0 0 80px #7EE04B18}
  .row{display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid #1A1F1C;font-size:19px}
  .row:last-child{border-bottom:none}
  .row b{font-size:20px} .row i{font-style:normal;font-size:15px;display:block;text-align:right}
  </style></head><body>
  <div class="l"><div class="logo"><div class="chip">${CHIP}</div>
  <div class="name">${lang === 'ko' ? name : 'part<span>stock</span>'}</div></div>
  <div class="tag">${tag}</div><div class="sub">${sub}</div></div>
  <div class="card">
    <svg width="352" height="118" viewBox="0 0 352 150" preserveAspectRatio="none"><defs><linearGradient id="g" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#7EE04B" stop-opacity=".4"/><stop offset="1" stop-color="#7EE04B" stop-opacity="0"/></linearGradient></defs>
    <path d="M0 118 L40 108 L72 122 L110 84 L146 94 L186 60 L222 72 L262 36 L300 48 L352 16 L352 150 L0 150Z" fill="url(#g)"/>
    <path d="M0 118 L40 108 L72 122 L110 84 L146 94 L186 60 L222 72 L262 36 L300 48 L352 16" fill="none" stroke="#7EE04B" stroke-width="3.5" stroke-linejoin="round"/>
    <circle cx="352" cy="16" r="6" fill="#7EE04B"/></svg>
    ${rows.map(([n, p, c, col]) => `<div class="row"><span>${n}</span><span><b>${p}</b><i style="color:${col}">${c} ${week}</i></span></div>`).join('')}
  </div></body></html>`;
}

(async () => {
  const b = await chromium.launch({ channel: 'chrome' });
  const render = async (html, w, h, out) => {
    const p = await b.newPage({ viewport: { width: w, height: h } });
    await p.setContent(html, { waitUntil: 'networkidle' });
    await p.evaluate(() => document.fonts.ready);
    await p.screenshot({ path: path.join(DIR, out) });
    await p.close();
  };
  for (const lang of ['ko', 'en']) {
    for (const [i, [f, t, s]] of shots[lang].entries()) {
      await render(shotHtml(img(`raw/${lang}-${f}.png`), t, s), 1080, 1920, `${lang}/screenshot-${i + 1}.png`);
    }
    await render(featureHtml(lang), 1024, 500, `${lang}/feature-graphic.png`);
  }
  await b.close();
})();
