# 📈 Pro Trader v4.0: Ultimate AI Trading Bots

Welcome to the **All-Market-Bots** and **Gold-MT5-BOT** repository by [Salman RK](https://github.com/salmanrki/)! 

This repository contains a suite of highly advanced Expert Advisors (EAs) for MetaTrader 5 (MT5): **`Claude.mq5`**, **`openai.mq5`**, and the specialized **`Gold-MT5-BOT`**. These bots merge traditional institutional trading concepts (Smart Money Concepts, Ichimoku, Divergences) with real-time Large Language Models (LLMs) to analyze market context, fundamentals, and execute trades automatically.

---

## 🌟 The Bots

1. **`Claude.mq5` (Multi-Market):** Powered by Anthropic's Claude AI. Auto-detects and adapts to Forex, Crypto, Indices, and Oil.
2. **`openai.mq5` (Multi-Market):** Powered by OpenAI's ChatGPT. Offers the same robust multi-market flexibility using OpenAI's models.
3. **`Gold-MT5-BOT` (XAUUSD Optimized):** A hyper-specialized version of the Claude bot explicitly tuned for Gold (XAUUSD). It features a custom macroeconomic sentiment analyzer that specifically weighs USD strength, Fed policy, inflation data, and safe-haven geopolitical risks to determine gold's directional bias.

## ⚙️ Core Features

* **🧠 Smart Money Concepts (SMC):** Built-in detection for institutional Order Blocks, Fair Value Gaps (FVG), and Supply/Demand zones.
* **📊 Advanced Technicals:** Multi-Timeframe (MTF) analysis (M1 to H4), Ichimoku Cloud breakouts, RSI/MACD Divergences, Auto-Fibonacci retracements, and VWAP.
* **📰 Live News & Fundamental Filter:** Reads the MT5 Economic Calendar and fetches live market headlines via Finnhub API. Automatically pauses trading during high-impact news events.
* **🛡️ Institutional Risk Management:** Dynamic risk-based lot sizing, maximum daily drawdown limits, break-even stop triggers, smart trailing stops, and partial Take Profit (TP1) scale-outs.
* **🕒 Session Awareness:** Trades based on active market sessions (London, New York, Asian Range Breakouts) and factors in London Fix volatility.

## 🚀 Installation & Setup

### 1. Prerequisites
Before running these EAs, you must allow MT5 to communicate with the external AI and News APIs.

1. Open MetaTrader 5.
2. Go to **Tools** > **Options** (or press `Ctrl+O`).
3. Navigate to the **Expert Advisors** tab.
4. Check the box **"Allow WebRequest for listed URL"**.
5. Add the following URLs to the list:
   * `https://finnhub.io` (For live news data)
   * `https://api.anthropic.com` (For Claude EAs)
   * `https://api.openai.com` (For OpenAI EA)

### 2. Loading the EA
1. Download the `.mq5` files from this repository.
2. Open MT5, go to **File** > **Open Data Folder**.
3. Navigate to `MQL5` > `Experts` and paste the files there.
4. Refresh your Navigator panel in MT5 or restart the platform.
5. Double-click the EA to compile and attach it to your desired chart. *(Note: Attach the Gold bot exclusively to XAUUSD).*

### 3. API Keys Configuration
When attaching the EA to a chart, open the **Inputs** tab and enter your keys:
* **Finnhub API Key:** Obtain a free key at [finnhub.io](https://finnhub.io) for live news sentiment tracking.
* **AI API Key:** Enter your Anthropic or OpenAI API key depending on which bot you are running.
* *(Security Note: Never commit your actual API keys into public source code!)*

## 🧠 How The AI Engine Works

The bots operate using a robust **Confluence Scoring Engine**. They analyze 21 different technical and fundamental factors to generate a base score. 

Simultaneously, the EA feeds the live market data, current open positions, candlestick patterns, and news headlines directly to the AI model. The AI acts as an institutional proprietary trader—weighing technicals against macro fundamentals—and returns a `BUY`, `SELL`, or `WAIT` signal alongside a confidence score. If the AI's confidence aligns with the technical confluence score, the bot executes the trade.

## 🤝 Support & Contribute

If these bots have improved your trading or helped you learn algorithmic development, please consider supporting my work!

[![GitHub Sponsors](https://img.shields.io/badge/Sponsor_Me-EA4AAA?style=for-the-badge&logo=github&logoColor=white)](https://github.com/sponsors/salmanrki/)

### Connect with me
* **GitHub:** [https://github.com/salmanrki/](https://github.com/salmanrki/)

---
**Disclaimer:** Trading in financial markets involves a high degree of risk. These bots are provided for educational and experimental purposes. Always backtest and forward-test on a demo account before risking real money. The author is not responsible for any financial losses incurred.
