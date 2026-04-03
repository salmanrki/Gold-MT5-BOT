//+------------------------------------------------------------------+
//|                                    GOLD PRO DASHBOARD v4.0       |
//|     Ultimate Professional Multi-Timeframe AI Trading System      |
//|  Claude AI | SMC | Ichimoku | Divergence | Fibonacci | News      |
//+------------------------------------------------------------------+
#property copyright "Professional Trading Dashboard v4.0"
#property version   "4.00"
#property strict
#property description "Ultimate Gold trading: MTF, SMC, Ichimoku, Divergence, Fibonacci, Order Blocks, FVG, VWAP, News, AI"

#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//| INPUT PARAMETERS                                                 |
//+------------------------------------------------------------------+
input group "═══ Panel Position & Size ═══"
input int      InpXLeft          = 10;
input int      InpYTop           = 40;
input int      InpWidthLeft      = 240;
input int      InpPanelHeight    = 920;

input group "═══ Color Scheme ═══"
input color    ClrBackground     = C'10,10,12';
input color    ClrHeader         = C'255,190,0';
input color    ClrLabel          = C'180,180,180';
input color    ClrValue          = C'255,255,255';
input color    ClrBuy            = C'46,204,113';
input color    ClrSell           = C'231,76,60';
input color    ClrNeutral        = C'120,120,120';
input color    ClrWarning        = C'255,152,0';

input group "═══ Indicator Periods ═══"
input int      InpRSIPeriod      = 14;
input int      InpMAFast         = 9;
input int      InpMAMid          = 21;
input int      InpMASlow         = 50;
input int      InpMA200          = 200;
input int      InpATRPeriod      = 14;
input int      InpMACDFast       = 12;
input int      InpMACDSlow       = 26;
input int      InpMACDSignal     = 9;
input int      InpBBPeriod       = 20;
input double   InpBBDeviation    = 2.0;
input int      InpStochK         = 14;
input int      InpStochD         = 3;
input int      InpStochSlowing   = 3;
input int      InpADXPeriod      = 14;

input group "═══ Claude AI (Anthropic) ═══"
input bool     InpUseAI          = true;
input string   InpClaudeAPIKey   = "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";
input string   InpClaudeModel    = "claude-sonnet-4-6";
input int      InpAIUpdateSec    = 8;        // AI Update Interval (seconds)
input double   InpAIConfidenceMin = 0.50;     // Min AI confidence to act (lower=more trades)
input bool     InpAIOverride      = true;

input group "═══ Risk Management ═══"
input bool     InpEnableTrading  = true;     // Enable Auto Trading (MUST be true)
input double   InpRiskPercent    = 1.0;      // Risk % per Trade (0=use fixed lot)
input double   InpLotSize        = 0.01;     // Fixed Lot (if risk%=0)
input int      InpMaxPositions   = 5;        // Max Open Positions
input double   InpStopLossATR    = 2.0;      // Stop Loss (ATR multiples) - ALWAYS SET
input double   InpTP1_ATR        = 1.5;      // Take Profit 1 (ATR multiples) - partial close
input double   InpTP2_ATR        = 3.0;      // Take Profit 2 (ATR multiples) - full close
input double   InpPartialClosePct = 50.0;    // % volume to close at TP1
input double   InpMaxDailyDrawdown = 3.0;    // Max daily drawdown % → stop trading
input double   InpBreakevenATR    = 1.0;     // Move SL to breakeven at this ATR profit
input double   InpTrailATR        = 1.5;     // Trailing stop distance in ATR

input group "═══ Confluence Filters ═══"
input int      InpMinConfluence  = 3;        // Min confluence score to trade (1-10) - lower=more trades
input bool     InpRequireMTFAlign = false;   // Require multi-timeframe alignment (false=more trades)
input bool     InpFilterSessions  = false;   // Only trade during active sessions (false=trade 24/7)
input bool     InpAvoidHighVolSpikes = true; // Avoid sudden volatility spikes

input group "═══ News & Fundamental Analysis ═══"
input bool     InpUseNews         = true;     // Enable Real-Time News Analysis
input bool     InpPauseBeforeNews = true;     // Pause trading before high-impact news
input int      InpNewsPauseMinutes = 15;      // Minutes to pause before/after high-impact news
input string   InpFinnhubAPIKey   = "d779t6pr01qp6afkqkbgd779t6pr01qp6afkqkc0";       // Finnhub API Key (free at finnhub.io)
input int      InpNewsUpdateSec   = 60;       // News refresh interval (seconds)
input bool     InpNewsAffectsAI   = true;     // Feed news data into AI decisions

input group "═══ Advanced Indicators ═══"
input bool     InpUseIchimoku     = true;     // Enable Ichimoku Cloud analysis
input int      InpIchiTenkan      = 9;        // Ichimoku Tenkan period
input int      InpIchiKijun       = 26;       // Ichimoku Kijun period
input int      InpIchiSenkou      = 52;       // Ichimoku Senkou Span B period
input bool     InpUseDivergence   = true;     // Detect RSI/MACD divergences
input bool     InpUseFibonacci    = true;     // Auto Fibonacci levels
input bool     InpUseVWAP         = true;     // VWAP analysis
input bool     InpUseOBV          = true;     // On Balance Volume

input group "═══ Smart Money Concepts (SMC) ═══"
input bool     InpUseOrderBlocks  = true;     // Detect institutional Order Blocks
input bool     InpUseFVG          = true;     // Detect Fair Value Gaps
input bool     InpUseSupplyDemand = true;     // Supply/Demand zone detection

input group "═══ Session & Structure ═══"
input bool     InpUseAsianRange   = true;     // Asian Range Breakout strategy
input int      InpAsianStart      = 0;        // Asian session start hour (server time)
input int      InpAsianEnd        = 8;        // Asian session end hour (server time)
input bool     InpUsePrevDayHL    = true;     // Previous Day High/Low levels
input bool     InpUseLondonFix    = true;     // London Fix time awareness

input group "═══ Advanced Risk ═══"
input double   InpMaxSpreadPts    = 80;       // Max spread to open trades (points, 0=no limit)
input int      InpMaxDailyTrades  = 20;       // Max trades per day (0=unlimited)
input int      InpMaxConsecLoss   = 5;        // Max consecutive losses before cooldown
input int      InpCooldownMinutes = 30;       // Cooldown minutes after max consecutive losses

input group "═══ TEST MODE ═══"
input bool     InpTestMode       = false;

//+------------------------------------------------------------------+
//| ENUMS & STRUCTS                                                 |
//+------------------------------------------------------------------+
enum ENUM_MARKET_BIAS { BIAS_BULLISH, BIAS_BEARISH, BIAS_NEUTRAL };
enum ENUM_STRUCTURE   { STRUCT_UPTREND, STRUCT_DOWNTREND, STRUCT_RANGING };
enum ENUM_CANDLE_PATTERN { PAT_NONE, PAT_BULLISH_ENGULF, PAT_BEARISH_ENGULF,
                           PAT_HAMMER, PAT_SHOOTING_STAR, PAT_DOJI,
                           PAT_MORNING_STAR, PAT_EVENING_STAR,
                           PAT_PINBAR_BULL, PAT_PINBAR_BEAR,
                           PAT_THREE_WHITE, PAT_THREE_BLACK };

struct MTFData
{
   ENUM_TIMEFRAMES tf;
   double rsi;
   double maFast;
   double maMid;
   double maSlow;
   double ma200;
   double atr;
   double macdMain;
   double macdSignal;
   double macdHist;
   double bbUpper;
   double bbMiddle;
   double bbLower;
   double stochK;
   double stochD;
   double adx;
   double adxPlus;
   double adxMinus;
   ENUM_MARKET_BIAS bias;
   ENUM_STRUCTURE   structure;
   double highestHigh;
   double lowestLow;
   double sentiment;
};

struct ConfluenceResult
{
   int    score;          // 0-10
   string signal;        // BUY / SELL / WAIT
   string reasons[];     // array of reason strings
   int    buyPoints;
   int    sellPoints;
};

struct CandlePatternResult
{
   ENUM_CANDLE_PATTERN pattern;
   string name;
   bool   isBullish;
   double strength;      // 0.0-1.0
};

struct SwingPoint
{
   double price;
   datetime time;
   bool   isHigh;
};

struct KeyLevel
{
   double price;
   string label;
   int    touches;
   bool   isSupport;
};

struct NewsEvent
{
   string   title;
   string   currency;
   string   impact;      // HIGH / MEDIUM / LOW
   datetime eventTime;
   string   actual;
   string   forecast;
   string   previous;
   int      minutesUntil; // negative = already passed
};

struct NewsHeadline
{
   string   headline;
   string   source;
   string   sentiment;   // BULLISH / BEARISH / NEUTRAL
   datetime time;
};

// V4 Structs
struct IchimokuData
{
   double   tenkan;
   double   kijun;
   double   senkouA;
   double   senkouB;
   double   chikou;
   string   signal;       // "ABOVE_CLOUD", "BELOW_CLOUD", "IN_CLOUD"
   bool     tkCross;      // Tenkan/Kijun cross happened
   bool     isBullish;
};

struct OrderBlock
{
   double   priceHigh;
   double   priceLow;
   bool     isBullish;
   bool     isMitigated;
   double   strength;
};

struct FairValueGap
{
   double   high;
   double   low;
   bool     isBullish;
   bool     isFilled;
};

struct FibLevel
{
   double   level;
   double   price;
   string   label;
};

struct DivergenceResult
{
   bool     found;
   bool     isBullish;
   bool     isHidden;
   string   indicator;
   string   description;
};

//+------------------------------------------------------------------+
//| GLOBAL VARIABLES                                                 |
//+------------------------------------------------------------------+
string         g_Prefix = "GPRO_";

// Multi-Timeframe indicator handles
int            g_hRSI[], g_hMAFast[], g_hMAMid[], g_hMASlow[], g_hMA200[];
int            g_hATR[], g_hMACD[], g_hBB[], g_hStoch[], g_hADX[];
ENUM_TIMEFRAMES g_MTFList[];
int            g_MTFCount = 0;

// Cached MTF data
MTFData        g_MTF[];

// Symbol Info
int            g_Digits = 0;
double         g_Point  = 0.0;

// Trading
CTrade         g_Trade;
datetime       g_LastTradeBar  = 0;
datetime       g_LastAIUpdate  = 0;
ulong          g_LastTicket    = 0;

// AI
string         g_AISignal      = "WAITING";
double         g_AIConfidence  = 0.0;
string         g_AIReasoning   = "";
string         g_AISummary     = "";
bool           g_AIIsActive    = false;
string         g_AIStatus      = "INIT";

// Stats
int            g_TotalTrades   = 0;
int            g_Wins          = 0;
int            g_Losses        = 0;
double         g_TotalProfit   = 0.0;
double         g_DailyStartBalance = 0.0;
datetime       g_DailyResetDay = 0;

// Confluence
ConfluenceResult g_Confluence;

// Candle patterns (cached)
CandlePatternResult g_LastPattern;

// Swing points
SwingPoint     g_SwingHighs[];
SwingPoint     g_SwingLows[];

// Key levels
KeyLevel       g_KeyLevels[];

// Trailing
ulong          g_TrackedTickets[];
double         g_MaxProfitPrice[];
bool           g_TP1Hit[];

// Tick tracking
int            g_TicksPerSec = 0;
datetime       g_LastSec     = 0;

// News & Fundamentals
NewsEvent      g_UpcomingNews[];
NewsHeadline   g_Headlines[];
int            g_NewsCount = 0;
int            g_HeadlineCount = 0;
datetime       g_LastNewsUpdate = 0;
bool           g_HighImpactSoon = false;
string         g_NewsStatus = "INIT";
string         g_NextNewsEvent = "--";
string         g_NewsSentiment = "NEUTRAL";
int            g_NewsBullish = 0;
int            g_NewsBearish = 0;

// V4: Ichimoku & OBV handles
int            g_hIchimoku[];
int            g_hOBV[];

// V4: Advanced cached data
IchimokuData   g_Ichimoku[];
OrderBlock     g_OrderBlocks[];
FairValueGap   g_FVGs[];
FibLevel       g_FibLevels[];
DivergenceResult g_Divergences[];

// V4: Previous Day High/Low
double         g_PrevDayHigh = 0;
double         g_PrevDayLow  = 0;
double         g_PrevDayClose = 0;

// V4: Asian Range
double         g_AsianHigh = 0;
double         g_AsianLow  = 99999;
bool           g_AsianRangeSet = false;
datetime       g_AsianRangeDate = 0;

// V4: VWAP
double         g_VWAP = 0;
double         g_VWAPUpper = 0;
double         g_VWAPLower = 0;

// V4: Advanced risk
int            g_DailyTradeCount = 0;
datetime       g_DailyTradeResetDay = 0;
int            g_ConsecutiveLosses = 0;
datetime       g_CooldownUntil = 0;

// V4: London Fix
bool           g_NearLondonFix = false;

// Test mode
bool           g_TestDone = false;
int            g_TestStep = 0;
ulong          g_TestTicket = 0;
datetime       g_TestLastAction = 0;

//+------------------------------------------------------------------+
//| INIT                                                             |
//+------------------------------------------------------------------+
int OnInit()
{
   g_Digits = (int)SymbolInfoInteger(_Symbol, SYMBOL_DIGITS);
   g_Point  = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   SymbolSelect(_Symbol, true);

   // Define MTF list: M1, M5, M15, H1, H4
   g_MTFCount = 5;
   ArrayResize(g_MTFList, g_MTFCount);
   g_MTFList[0] = PERIOD_M1;
   g_MTFList[1] = PERIOD_M5;
   g_MTFList[2] = PERIOD_M15;
   g_MTFList[3] = PERIOD_H1;
   g_MTFList[4] = PERIOD_H4;
   ArrayResize(g_MTF, g_MTFCount);
   ArrayResize(g_hRSI, g_MTFCount);
   ArrayResize(g_hMAFast, g_MTFCount);
   ArrayResize(g_hMAMid, g_MTFCount);
   ArrayResize(g_hMASlow, g_MTFCount);
   ArrayResize(g_hMA200, g_MTFCount);
   ArrayResize(g_hATR, g_MTFCount);
   ArrayResize(g_hMACD, g_MTFCount);
   ArrayResize(g_hBB, g_MTFCount);
   ArrayResize(g_hStoch, g_MTFCount);
   ArrayResize(g_hADX, g_MTFCount);
   ArrayResize(g_hIchimoku, g_MTFCount);
   ArrayResize(g_hOBV, g_MTFCount);
   ArrayResize(g_Ichimoku, g_MTFCount);

   for(int i = 0; i < g_MTFCount; i++)
   {
      g_MTF[i].tf = g_MTFList[i];

      g_hRSI[i]    = iRSI(_Symbol, g_MTFList[i], InpRSIPeriod, PRICE_CLOSE);
      g_hMAFast[i]  = iMA(_Symbol, g_MTFList[i], InpMAFast, 0, MODE_EMA, PRICE_CLOSE);
      g_hMAMid[i]   = iMA(_Symbol, g_MTFList[i], InpMAMid, 0, MODE_EMA, PRICE_CLOSE);
      g_hMASlow[i]  = iMA(_Symbol, g_MTFList[i], InpMASlow, 0, MODE_EMA, PRICE_CLOSE);
      g_hMA200[i]   = iMA(_Symbol, g_MTFList[i], InpMA200, 0, MODE_SMA, PRICE_CLOSE);
      g_hATR[i]     = iATR(_Symbol, g_MTFList[i], InpATRPeriod);
      g_hMACD[i]    = iMACD(_Symbol, g_MTFList[i], InpMACDFast, InpMACDSlow, InpMACDSignal, PRICE_CLOSE);
      g_hBB[i]      = iBands(_Symbol, g_MTFList[i], InpBBPeriod, 0, InpBBDeviation, PRICE_CLOSE);
      g_hStoch[i]   = iStochastic(_Symbol, g_MTFList[i], InpStochK, InpStochD, InpStochSlowing, MODE_SMA, STO_LOWHIGH);
      g_hADX[i]     = iADX(_Symbol, g_MTFList[i], InpADXPeriod);
      g_hIchimoku[i] = iIchimoku(_Symbol, g_MTFList[i], InpIchiTenkan, InpIchiKijun, InpIchiSenkou);
      g_hOBV[i]      = iOBV(_Symbol, g_MTFList[i], VOLUME_TICK);

      if(g_hRSI[i]==INVALID_HANDLE || g_hMAFast[i]==INVALID_HANDLE ||
         g_hMAMid[i]==INVALID_HANDLE || g_hMASlow[i]==INVALID_HANDLE ||
         g_hMA200[i]==INVALID_HANDLE || g_hATR[i]==INVALID_HANDLE ||
         g_hMACD[i]==INVALID_HANDLE || g_hBB[i]==INVALID_HANDLE ||
         g_hStoch[i]==INVALID_HANDLE || g_hADX[i]==INVALID_HANDLE ||
         g_hIchimoku[i]==INVALID_HANDLE || g_hOBV[i]==INVALID_HANDLE)
      {
         Print("ERROR: Failed to create indicators for TF ", EnumToString(g_MTFList[i]));
         return INIT_FAILED;
      }
   }

   g_Trade.SetExpertMagicNumber(314159);
   g_Trade.SetDeviationInPoints(10);

   // Daily drawdown tracker
   g_DailyStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   MqlDateTime dt; TimeToStruct(TimeCurrent(), dt);
   g_DailyResetDay = TimeCurrent() - dt.hour*3600 - dt.min*60 - dt.sec;

   DrawDashboard();
   EventSetTimer(1);

   Print("=== GOLD PRO v4.0 Started on ", _Symbol, " ===");
   Print("AUTO TRADING: ENABLED | STOP LOSS: ALWAYS ON (ATR x", InpStopLossATR, ")");
   Print("TP1=", InpTP1_ATR, "xATR (partial ", InpPartialClosePct, "%) | TP2=", InpTP2_ATR, "xATR (full close)");
   Print("Breakeven at ", InpBreakevenATR, "xATR | Trailing at ", InpTrailATR, "xATR");
   Print("MTF: M1/M5/M15/H1/H4 | Indicators: RSI,MA,ATR,MACD,BB,Stoch,ADX,Ichimoku,OBV");
   Print("V4: SMC(OrderBlocks+FVG) | Divergence | Fibonacci | VWAP | AsianRange | PrevDayHL");
   Print("Confluence min=", InpMinConfluence, " | Risk=", InpRiskPercent, "% | MaxPos=", InpMaxPositions);
   Print("Daily drawdown limit: ", InpMaxDailyDrawdown, "%");
   Print("NEWS: ", (InpUseNews ? "ENABLED" : "DISABLED"), 
         " | Pause before high-impact: ", (InpPauseBeforeNews ? "YES" : "NO"),
         " | Finnhub: ", (StringLen(InpFinnhubAPIKey) > 5 ? "CONNECTED" : "Calendar only"));
   if(InpUseNews && StringLen(InpFinnhubAPIKey) > 5)
      Print("IMPORTANT: Add https://finnhub.io to Tools > Options > Expert Advisors > Allow WebRequest");
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| DEINIT                                                           |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   ObjectsDeleteAll(0, g_Prefix);
   for(int i = 0; i < g_MTFCount; i++)
   {
      if(g_hRSI[i]!=INVALID_HANDLE)   IndicatorRelease(g_hRSI[i]);
      if(g_hMAFast[i]!=INVALID_HANDLE) IndicatorRelease(g_hMAFast[i]);
      if(g_hMAMid[i]!=INVALID_HANDLE)  IndicatorRelease(g_hMAMid[i]);
      if(g_hMASlow[i]!=INVALID_HANDLE) IndicatorRelease(g_hMASlow[i]);
      if(g_hMA200[i]!=INVALID_HANDLE)  IndicatorRelease(g_hMA200[i]);
      if(g_hATR[i]!=INVALID_HANDLE)    IndicatorRelease(g_hATR[i]);
      if(g_hMACD[i]!=INVALID_HANDLE)   IndicatorRelease(g_hMACD[i]);
      if(g_hBB[i]!=INVALID_HANDLE)     IndicatorRelease(g_hBB[i]);
      if(g_hStoch[i]!=INVALID_HANDLE)  IndicatorRelease(g_hStoch[i]);
      if(g_hADX[i]!=INVALID_HANDLE)    IndicatorRelease(g_hADX[i]);
   }
   Print("=== GOLD PRO v4.0 Stopped ===");
}

//+------------------------------------------------------------------+
//| TICK                                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double spread = (ask - bid) / g_Point;

   UpdateUI("Price", DoubleToString((bid+ask)/2.0, g_Digits), ClrValue);
   UpdateUI("Spread", DoubleToString(spread, 0) + " pts", (spread > 50) ? ClrWarning : ClrValue);

   if(InpTestMode && !g_TestDone) { RunTestMode(); }

   UpdateAllData();
   ChartRedraw(0);
}

void OnTimer()
{
   if(InpTestMode && !g_TestDone) RunTestMode();
   UpdateAllData();
   ChartRedraw(0);
}

//+------------------------------------------------------------------+
//| REFRESH ALL MTF DATA                                             |
//+------------------------------------------------------------------+
void RefreshMTFData()
{
   for(int i = 0; i < g_MTFCount; i++)
   {
      double buf[3];
      // RSI
      if(CopyBuffer(g_hRSI[i],0,0,1,buf)>=1) g_MTF[i].rsi = buf[0]; else g_MTF[i].rsi=50;
      // MAs
      if(CopyBuffer(g_hMAFast[i],0,0,1,buf)>=1) g_MTF[i].maFast=buf[0]; else g_MTF[i].maFast=0;
      if(CopyBuffer(g_hMAMid[i],0,0,1,buf)>=1)  g_MTF[i].maMid=buf[0];  else g_MTF[i].maMid=0;
      if(CopyBuffer(g_hMASlow[i],0,0,1,buf)>=1)  g_MTF[i].maSlow=buf[0]; else g_MTF[i].maSlow=0;
      if(CopyBuffer(g_hMA200[i],0,0,1,buf)>=1)   g_MTF[i].ma200=buf[0];  else g_MTF[i].ma200=0;
      // ATR
      if(CopyBuffer(g_hATR[i],0,0,1,buf)>=1) g_MTF[i].atr=buf[0]; else g_MTF[i].atr=0;
      // MACD
      if(CopyBuffer(g_hMACD[i],0,0,1,buf)>=1) g_MTF[i].macdMain=buf[0]; else g_MTF[i].macdMain=0;
      if(CopyBuffer(g_hMACD[i],1,0,1,buf)>=1) g_MTF[i].macdSignal=buf[0]; else g_MTF[i].macdSignal=0;
      g_MTF[i].macdHist = g_MTF[i].macdMain - g_MTF[i].macdSignal;
      // Bollinger Bands
      if(CopyBuffer(g_hBB[i],0,0,1,buf)>=1) g_MTF[i].bbMiddle=buf[0]; else g_MTF[i].bbMiddle=0;
      if(CopyBuffer(g_hBB[i],1,0,1,buf)>=1) g_MTF[i].bbUpper=buf[0];  else g_MTF[i].bbUpper=0;
      if(CopyBuffer(g_hBB[i],2,0,1,buf)>=1) g_MTF[i].bbLower=buf[0];  else g_MTF[i].bbLower=0;
      // Stochastic
      if(CopyBuffer(g_hStoch[i],0,0,1,buf)>=1) g_MTF[i].stochK=buf[0]; else g_MTF[i].stochK=50;
      if(CopyBuffer(g_hStoch[i],1,0,1,buf)>=1) g_MTF[i].stochD=buf[0]; else g_MTF[i].stochD=50;
      // ADX
      if(CopyBuffer(g_hADX[i],0,0,1,buf)>=1) g_MTF[i].adx=buf[0];      else g_MTF[i].adx=0;
      if(CopyBuffer(g_hADX[i],1,0,1,buf)>=1) g_MTF[i].adxPlus=buf[0];  else g_MTF[i].adxPlus=0;
      if(CopyBuffer(g_hADX[i],2,0,1,buf)>=1) g_MTF[i].adxMinus=buf[0]; else g_MTF[i].adxMinus=0;

      // Bias
      double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      int bullCount=0, bearCount=0;
      if(price > g_MTF[i].maFast) bullCount++; else bearCount++;
      if(price > g_MTF[i].maSlow) bullCount++; else bearCount++;
      if(price > g_MTF[i].ma200)  bullCount++; else bearCount++;
      if(g_MTF[i].macdHist > 0)   bullCount++; else bearCount++;
      if(g_MTF[i].rsi > 50)       bullCount++; else bearCount++;
      g_MTF[i].bias = (bullCount >= 4) ? BIAS_BULLISH : (bearCount >= 4) ? BIAS_BEARISH : BIAS_NEUTRAL;

      // Swing high/low for structure
      double highs[], lows[];
      ArraySetAsSeries(highs, true); ArraySetAsSeries(lows, true);
      int hBars = CopyHigh(_Symbol, g_MTFList[i], 0, 50, highs);
      int lBars = CopyLow(_Symbol, g_MTFList[i], 0, 50, lows);
      if(hBars >= 50 && lBars >= 50)
      {
         g_MTF[i].highestHigh = highs[ArrayMaximum(highs,0,50)];
         g_MTF[i].lowestLow   = lows[ArrayMinimum(lows,0,50)];

         // Structure detection: compare recent swing highs/lows
         double recentHH = highs[ArrayMaximum(highs,0,10)];
         double prevHH   = highs[ArrayMaximum(highs,10,20)];
         double recentLL = lows[ArrayMinimum(lows,0,10)];
         double prevLL   = lows[ArrayMinimum(lows,10,20)];

         if(recentHH > prevHH && recentLL > prevLL) g_MTF[i].structure = STRUCT_UPTREND;
         else if(recentHH < prevHH && recentLL < prevLL) g_MTF[i].structure = STRUCT_DOWNTREND;
         else g_MTF[i].structure = STRUCT_RANGING;
      }

      // Sentiment
      g_MTF[i].sentiment = CalcSentiment(g_MTFList[i]);
   }
}

double CalcSentiment(ENUM_TIMEFRAMES tf)
{
   double h[], l[], c[];
   ArraySetAsSeries(h,true); ArraySetAsSeries(l,true); ArraySetAsSeries(c,true);
   if(CopyHigh(_Symbol,tf,1,1,h)<1 || CopyLow(_Symbol,tf,1,1,l)<1 || CopyClose(_Symbol,tf,1,1,c)<1) return 50;
   if(h[0]==l[0]) return 50;
   return MathMax(0, MathMin(100, ((c[0]-l[0])/(h[0]-l[0]))*100));
}

//+------------------------------------------------------------------+
//| CANDLESTICK PATTERN RECOGNITION                                  |
//+------------------------------------------------------------------+
CandlePatternResult DetectCandlePatterns(ENUM_TIMEFRAMES tf)
{
   CandlePatternResult res;
   res.pattern = PAT_NONE; res.name = "None"; res.isBullish = false; res.strength = 0;

   double o[], h[], l[], c[];
   ArraySetAsSeries(o,true); ArraySetAsSeries(h,true); ArraySetAsSeries(l,true); ArraySetAsSeries(c,true);
   if(CopyOpen(_Symbol,tf,0,5,o)<5 || CopyHigh(_Symbol,tf,0,5,h)<5 ||
      CopyLow(_Symbol,tf,0,5,l)<5  || CopyClose(_Symbol,tf,0,5,c)<5) return res;

   double body0 = MathAbs(c[0]-o[0]);
   double range0 = h[0]-l[0];
   double body1 = MathAbs(c[1]-o[1]);
   double range1 = h[1]-l[1];
   double body2 = MathAbs(c[2]-o[2]);
   if(range0 <= 0) return res;
   double bodyRatio = body0 / range0;
   double upperWick = h[0] - MathMax(o[0],c[0]);
   double lowerWick = MathMin(o[0],c[0]) - l[0];

   // Doji
   if(bodyRatio < 0.1 && range0 > g_Point*5)
   {
      res.pattern = PAT_DOJI; res.name = "Doji";
      res.isBullish = (c[1] < o[1]); // reversal of prior
      res.strength = 0.5;
      return res;
   }

   // Hammer (bullish) - small body at top, long lower wick
   if(lowerWick > body0 * 2.0 && upperWick < body0 * 0.5 && c[0] > o[0])
   {
      res.pattern = PAT_HAMMER; res.name = "Hammer";
      res.isBullish = true; res.strength = 0.7;
      return res;
   }

   // Shooting Star (bearish) - small body at bottom, long upper wick
   if(upperWick > body0 * 2.0 && lowerWick < body0 * 0.5 && c[0] < o[0])
   {
      res.pattern = PAT_SHOOTING_STAR; res.name = "Shooting Star";
      res.isBullish = false; res.strength = 0.7;
      return res;
   }

   // Bullish Engulfing
   if(c[1] < o[1] && c[0] > o[0] && o[0] <= c[1] && c[0] >= o[1] && body0 > body1)
   {
      res.pattern = PAT_BULLISH_ENGULF; res.name = "Bullish Engulfing";
      res.isBullish = true; res.strength = 0.8;
      return res;
   }

   // Bearish Engulfing
   if(c[1] > o[1] && c[0] < o[0] && o[0] >= c[1] && c[0] <= o[1] && body0 > body1)
   {
      res.pattern = PAT_BEARISH_ENGULF; res.name = "Bearish Engulfing";
      res.isBullish = false; res.strength = 0.8;
      return res;
   }

   // Bullish Pin Bar
   if(lowerWick > range0 * 0.6 && bodyRatio < 0.3)
   {
      res.pattern = PAT_PINBAR_BULL; res.name = "Bullish Pin Bar";
      res.isBullish = true; res.strength = 0.75;
      return res;
   }

   // Bearish Pin Bar
   if(upperWick > range0 * 0.6 && bodyRatio < 0.3)
   {
      res.pattern = PAT_PINBAR_BEAR; res.name = "Bearish Pin Bar";
      res.isBullish = false; res.strength = 0.75;
      return res;
   }

   // Three White Soldiers
   if(c[0]>o[0] && c[1]>o[1] && c[2]>o[2] && c[0]>c[1] && c[1]>c[2])
   {
      res.pattern = PAT_THREE_WHITE; res.name = "Three White Soldiers";
      res.isBullish = true; res.strength = 0.85;
      return res;
   }

   // Three Black Crows
   if(c[0]<o[0] && c[1]<o[1] && c[2]<o[2] && c[0]<c[1] && c[1]<c[2])
   {
      res.pattern = PAT_THREE_BLACK; res.name = "Three Black Crows";
      res.isBullish = false; res.strength = 0.85;
      return res;
   }

   // Morning Star (3-candle bullish reversal)
   if(c[2]<o[2] && body2>range1*0.3 && body1<range1*0.3 && c[0]>o[0] && c[0]>(o[2]+c[2])/2.0)
   {
      res.pattern = PAT_MORNING_STAR; res.name = "Morning Star";
      res.isBullish = true; res.strength = 0.85;
      return res;
   }

   // Evening Star (3-candle bearish reversal)
   if(c[2]>o[2] && body2>range1*0.3 && body1<range1*0.3 && c[0]<o[0] && c[0]<(o[2]+c[2])/2.0)
   {
      res.pattern = PAT_EVENING_STAR; res.name = "Evening Star";
      res.isBullish = false; res.strength = 0.85;
      return res;
   }

   return res;
}

//+------------------------------------------------------------------+
//| DETECT KEY SUPPORT / RESISTANCE LEVELS                           |
//+------------------------------------------------------------------+
void DetectKeyLevels()
{
   ArrayResize(g_KeyLevels, 0);

   // Daily pivot points
   double pivot, r1, r2, r3, s1, s2, s3;
   CalcPivots(pivot, r1, r2, r3, s1, s2, s3);
   if(pivot > 0)
   {
      AddKeyLevel(pivot, "Pivot", 0, true);
      AddKeyLevel(r1, "R1", 0, false);
      AddKeyLevel(r2, "R2", 0, false);
      AddKeyLevel(s1, "S1", 0, true);
      AddKeyLevel(s2, "S2", 0, true);
   }

   // Swing highs/lows from H1
   double h1Highs[], h1Lows[];
   ArraySetAsSeries(h1Highs, true); ArraySetAsSeries(h1Lows, true);
   int n = CopyHigh(_Symbol, PERIOD_H1, 0, 100, h1Highs);
   int m = CopyLow(_Symbol, PERIOD_H1, 0, 100, h1Lows);
   if(n >= 100 && m >= 100)
   {
      // Find swing highs (local maxima)
      for(int i = 2; i < 98; i++)
      {
         if(h1Highs[i] > h1Highs[i-1] && h1Highs[i] > h1Highs[i-2] &&
            h1Highs[i] > h1Highs[i+1] && h1Highs[i] > h1Highs[i+2])
         {
            // Count touches
            int touches = 0;
            for(int j = 0; j < 100; j++)
            {
               if(MathAbs(h1Highs[j] - h1Highs[i]) < g_Point * 50) touches++;
            }
            if(touches >= 2)
               AddKeyLevel(h1Highs[i], "SwingH", touches, false);
         }
         // Find swing lows
         if(h1Lows[i] < h1Lows[i-1] && h1Lows[i] < h1Lows[i-2] &&
            h1Lows[i] < h1Lows[i+1] && h1Lows[i] < h1Lows[i+2])
         {
            int touches = 0;
            for(int j = 0; j < 100; j++)
            {
               if(MathAbs(h1Lows[j] - h1Lows[i]) < g_Point * 50) touches++;
            }
            if(touches >= 2)
               AddKeyLevel(h1Lows[i], "SwingL", touches, true);
         }
      }
   }

   // Round numbers (psychological levels)
   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double roundBase = MathFloor(price / 10.0) * 10.0;
   for(int i = -2; i <= 2; i++)
   {
      double lvl = roundBase + i * 10.0;
      if(lvl > 0) AddKeyLevel(lvl, "Round", 0, (lvl < price));
   }
}

void AddKeyLevel(double price, string label, int touches, bool isSupport)
{
   int sz = ArraySize(g_KeyLevels);
   // Check for duplicates (within 20 points)
   for(int i = 0; i < sz; i++)
   {
      if(MathAbs(g_KeyLevels[i].price - price) < g_Point * 20) return;
   }
   ArrayResize(g_KeyLevels, sz + 1);
   g_KeyLevels[sz].price = price;
   g_KeyLevels[sz].label = label;
   g_KeyLevels[sz].touches = touches;
   g_KeyLevels[sz].isSupport = isSupport;
}

void CalcPivots(double &pivot, double &r1, double &r2, double &r3, double &s1, double &s2, double &s3)
{
   double h[], l[], c[];
   ArraySetAsSeries(h,true); ArraySetAsSeries(l,true); ArraySetAsSeries(c,true);
   if(CopyHigh(_Symbol,PERIOD_D1,1,1,h)<1 || CopyLow(_Symbol,PERIOD_D1,1,1,l)<1 || CopyClose(_Symbol,PERIOD_D1,1,1,c)<1)
   { pivot=r1=r2=r3=s1=s2=s3=0; return; }
   pivot = (h[0]+l[0]+c[0])/3.0;
   double range = h[0]-l[0];
   r1 = 2*pivot - l[0]; s1 = 2*pivot - h[0];
   r2 = pivot + range;   s2 = pivot - range;
   r3 = h[0]+2*(pivot-l[0]); s3 = l[0]-2*(h[0]-pivot);
}

//+------------------------------------------------------------------+
//| CONFLUENCE SCORING ENGINE                                       |
//+------------------------------------------------------------------+
ConfluenceResult CalculateConfluence()
{
   ConfluenceResult cf;
   cf.score = 0; cf.signal = "WAIT"; cf.buyPoints = 0; cf.sellPoints = 0;
   ArrayResize(cf.reasons, 0);

   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   // Use M1 as primary, others for confirmation
   int pIdx = 0; // M1 primary index
   MTFData pri = g_MTF[pIdx];

   // 1. RSI — oversold/overbought on M1 (+1)
   if(pri.rsi < 30) { cf.buyPoints++; AddReason(cf, "RSI oversold " + DoubleToString(pri.rsi,1)); }
   else if(pri.rsi > 70) { cf.sellPoints++; AddReason(cf, "RSI overbought " + DoubleToString(pri.rsi,1)); }

   // 2. MACD histogram direction (+1)
   if(pri.macdHist > 0 && pri.macdMain > pri.macdSignal) { cf.buyPoints++; AddReason(cf, "MACD bullish"); }
   else if(pri.macdHist < 0 && pri.macdMain < pri.macdSignal) { cf.sellPoints++; AddReason(cf, "MACD bearish"); }

   // 3. Price relative to Bollinger Bands (+1)
   if(bid <= pri.bbLower && pri.bbLower > 0) { cf.buyPoints++; AddReason(cf, "Price at BB lower"); }
   else if(bid >= pri.bbUpper && pri.bbUpper > 0) { cf.sellPoints++; AddReason(cf, "Price at BB upper"); }

   // 4. Stochastic oversold/overbought (+1)
   if(pri.stochK < 20 && pri.stochD < 20) { cf.buyPoints++; AddReason(cf, "Stoch oversold"); }
   else if(pri.stochK > 80 && pri.stochD > 80) { cf.sellPoints++; AddReason(cf, "Stoch overbought"); }

   // 5. MA alignment — price > fast > mid > slow (+1)
   if(bid > pri.maFast && pri.maFast > pri.maMid && pri.maMid > pri.maSlow)
   { cf.buyPoints++; AddReason(cf, "MA bullish alignment"); }
   else if(bid < pri.maFast && pri.maFast < pri.maMid && pri.maMid < pri.maSlow)
   { cf.sellPoints++; AddReason(cf, "MA bearish alignment"); }

   // 6. Price above/below 200 MA (+1)
   if(pri.ma200 > 0)
   {
      if(bid > pri.ma200) { cf.buyPoints++; AddReason(cf, "Above 200 MA"); }
      else { cf.sellPoints++; AddReason(cf, "Below 200 MA"); }
   }

   // 7. ADX trend strength (+1 if trending)
   if(pri.adx > 25)
   {
      if(pri.adxPlus > pri.adxMinus) { cf.buyPoints++; AddReason(cf, "ADX trending bullish " + DoubleToString(pri.adx,0)); }
      else { cf.sellPoints++; AddReason(cf, "ADX trending bearish " + DoubleToString(pri.adx,0)); }
   }

   // 8. Candlestick pattern on M1 (+1)
   CandlePatternResult pat = DetectCandlePatterns(PERIOD_M1);
   g_LastPattern = pat;
   if(pat.pattern != PAT_NONE)
   {
      if(pat.isBullish) { cf.buyPoints++; AddReason(cf, "Pattern: " + pat.name); }
      else { cf.sellPoints++; AddReason(cf, "Pattern: " + pat.name); }
   }

   // 9. Multi-timeframe alignment (+1 for each aligned higher TF, max +2)
   int mtfBull = 0, mtfBear = 0;
   for(int i = 1; i < g_MTFCount; i++) // skip M1 (primary)
   {
      if(g_MTF[i].bias == BIAS_BULLISH) mtfBull++;
      else if(g_MTF[i].bias == BIAS_BEARISH) mtfBear++;
   }
   if(mtfBull >= 3) { cf.buyPoints += 2; AddReason(cf, "MTF aligned bullish (" + IntegerToString(mtfBull) + "/4)"); }
   else if(mtfBull >= 2) { cf.buyPoints++; AddReason(cf, "MTF leaning bullish"); }
   if(mtfBear >= 3) { cf.sellPoints += 2; AddReason(cf, "MTF aligned bearish (" + IntegerToString(mtfBear) + "/4)"); }
   else if(mtfBear >= 2) { cf.sellPoints++; AddReason(cf, "MTF leaning bearish"); }

   // 10. Near key support/resistance (+1)
   for(int i = 0; i < ArraySize(g_KeyLevels); i++)
   {
      double dist = MathAbs(bid - g_KeyLevels[i].price) / g_Point;
      if(dist < 100) // within 100 points
      {
         if(g_KeyLevels[i].isSupport && bid >= g_KeyLevels[i].price)
         { cf.buyPoints++; AddReason(cf, "Near support " + g_KeyLevels[i].label); break; }
         else if(!g_KeyLevels[i].isSupport && bid <= g_KeyLevels[i].price)
         { cf.sellPoints++; AddReason(cf, "Near resistance " + g_KeyLevels[i].label); break; }
      }
   }

   // 11. News sentiment (+1 or +2 for strong sentiment)
   if(InpUseNews && (g_NewsBullish > 0 || g_NewsBearish > 0))
   {
      if(g_NewsSentiment == "BULLISH")
      {
         int pts = (g_NewsBullish >= 3) ? 2 : 1;
         cf.buyPoints += pts;
         AddReason(cf, "News bullish (" + IntegerToString(g_NewsBullish) + " signals)");
      }
      else if(g_NewsSentiment == "BEARISH")
      {
         int pts = (g_NewsBearish >= 3) ? 2 : 1;
         cf.sellPoints += pts;
         AddReason(cf, "News bearish (" + IntegerToString(g_NewsBearish) + " signals)");
      }
   }

   // 12. Ichimoku Cloud position (+1) [V4]
   if(InpUseIchimoku && g_Ichimoku[pIdx].tenkan > 0)
   {
      if(g_Ichimoku[pIdx].signal == "ABOVE_CLOUD") { cf.buyPoints++; AddReason(cf, "Ichimoku above cloud"); }
      else if(g_Ichimoku[pIdx].signal == "BELOW_CLOUD") { cf.sellPoints++; AddReason(cf, "Ichimoku below cloud"); }
   }

   // 13. Ichimoku TK Cross (+1) [V4]
   if(InpUseIchimoku && g_Ichimoku[pIdx].tkCross)
   {
      if(g_Ichimoku[pIdx].isBullish) { cf.buyPoints++; AddReason(cf, "Ichimoku TK bullish cross"); }
      else { cf.sellPoints++; AddReason(cf, "Ichimoku TK bearish cross"); }
   }

   // 14. Divergence detection (+1-2) [V4]
   if(InpUseDivergence)
   {
      int divBull = 0, divBear = 0;
      for(int dv = 0; dv < ArraySize(g_Divergences); dv++)
      {
         if(g_Divergences[dv].isBullish) divBull++;
         else divBear++;
      }
      if(divBull > 0) { cf.buyPoints += MathMin(2, divBull); AddReason(cf, "Divergence bullish (" + IntegerToString(divBull) + ")"); }
      if(divBear > 0) { cf.sellPoints += MathMin(2, divBear); AddReason(cf, "Divergence bearish (" + IntegerToString(divBear) + ")"); }
   }

   // 15. Fibonacci level proximity (+1) [V4]
   if(InpUseFibonacci && ArraySize(g_FibLevels) > 0)
   {
      for(int f = 0; f < ArraySize(g_FibLevels); f++)
      {
         double fibDist = MathAbs(bid - g_FibLevels[f].price) / g_Point;
         if(fibDist < 100 && (g_FibLevels[f].level == 0.382 || g_FibLevels[f].level == 0.5 || g_FibLevels[f].level == 0.618))
         {
            if(bid > g_FibLevels[f].price) { cf.buyPoints++; AddReason(cf, "Near Fib " + g_FibLevels[f].label + " support"); }
            else { cf.sellPoints++; AddReason(cf, "Near Fib " + g_FibLevels[f].label + " resistance"); }
            break;
         }
      }
   }

   // 16. Order Block proximity (+1) [V4]
   if(InpUseOrderBlocks)
   {
      for(int ob = 0; ob < ArraySize(g_OrderBlocks); ob++)
      {
         double obMid = (g_OrderBlocks[ob].priceHigh + g_OrderBlocks[ob].priceLow) / 2.0;
         double obDist = MathAbs(bid - obMid) / g_Point;
         if(obDist < 200)
         {
            if(g_OrderBlocks[ob].isBullish && bid >= g_OrderBlocks[ob].priceLow)
            { cf.buyPoints++; AddReason(cf, "Near bullish Order Block"); break; }
            else if(!g_OrderBlocks[ob].isBullish && bid <= g_OrderBlocks[ob].priceHigh)
            { cf.sellPoints++; AddReason(cf, "Near bearish Order Block"); break; }
         }
      }
   }

   // 17. FVG proximity (+1) [V4]
   if(InpUseFVG)
   {
      for(int fv = 0; fv < ArraySize(g_FVGs); fv++)
      {
         if(bid >= g_FVGs[fv].low && bid <= g_FVGs[fv].high)
         {
            if(g_FVGs[fv].isBullish) { cf.buyPoints++; AddReason(cf, "In bullish FVG zone"); }
            else { cf.sellPoints++; AddReason(cf, "In bearish FVG zone"); }
            break;
         }
      }
   }

   // 18. VWAP position (+1) [V4]
   if(InpUseVWAP && g_VWAP > 0)
   {
      if(bid > g_VWAP) { cf.buyPoints++; AddReason(cf, "Above VWAP"); }
      else if(bid < g_VWAP) { cf.sellPoints++; AddReason(cf, "Below VWAP"); }
   }

   // 19. OBV trend (+1) [V4]
   if(InpUseOBV)
   {
      double obvTrend = GetOBVTrend(pIdx);
      if(obvTrend > 0) { cf.buyPoints++; AddReason(cf, "OBV accumulation"); }
      else if(obvTrend < 0) { cf.sellPoints++; AddReason(cf, "OBV distribution"); }
   }

   // 20. Previous Day High/Low (+1) [V4]
   if(InpUsePrevDayHL && g_PrevDayHigh > 0)
   {
      double distToHigh = (g_PrevDayHigh - bid) / g_Point;
      double distToLow = (bid - g_PrevDayLow) / g_Point;
      if(distToLow < 100 && bid > g_PrevDayLow) { cf.buyPoints++; AddReason(cf, "Near prev day low (support)"); }
      else if(distToHigh < 100 && bid < g_PrevDayHigh) { cf.sellPoints++; AddReason(cf, "Near prev day high (resist)"); }
   }

   // 21. Asian Range Breakout (+1) [V4]
   if(InpUseAsianRange && g_AsianRangeSet && g_AsianHigh > 0)
   {
      if(bid > g_AsianHigh) { cf.buyPoints++; AddReason(cf, "Asian range breakout UP"); }
      else if(bid < g_AsianLow) { cf.sellPoints++; AddReason(cf, "Asian range breakout DOWN"); }
   }

   // Determine signal and score (V4: more decisive — 21-factor engine)
   int gap = MathAbs(cf.buyPoints - cf.sellPoints);
   if(cf.buyPoints > cf.sellPoints && cf.buyPoints >= 2 && gap >= 1)
   {
      cf.signal = "BUY"; cf.score = MathMin(15, cf.buyPoints);
   }
   else if(cf.sellPoints > cf.buyPoints && cf.sellPoints >= 2 && gap >= 1)
   {
      cf.signal = "SELL"; cf.score = MathMin(15, cf.sellPoints);
   }
   else
   {
      cf.signal = "WAIT"; cf.score = MathMax(cf.buyPoints, cf.sellPoints);
   }

   return cf;
}

void AddReason(ConfluenceResult &cf, string reason)
{
   int sz = ArraySize(cf.reasons);
   ArrayResize(cf.reasons, sz + 1);
   cf.reasons[sz] = reason;
}

//+------------------------------------------------------------------+
//| SESSION FILTER                                                    |
//+------------------------------------------------------------------+
string GetSession()
{
   MqlDateTime dt; TimeToStruct(TimeCurrent(), dt);
   int h = dt.hour;
   if(h >= 8 && h < 12)  return "LONDON";
   if(h >= 12 && h < 16) return "OVERLAP";
   if(h >= 16 && h < 21) return "NEW YORK";
   return "ASIAN";
}

bool IsActiveSession()
{
   if(!InpFilterSessions) return true;
   string s = GetSession();
   return (s == "LONDON" || s == "OVERLAP" || s == "NEW YORK");
}

//+------------------------------------------------------------------+
//| DAILY DRAWDOWN CHECK                                             |
//+------------------------------------------------------------------+
bool IsDailyDrawdownExceeded()
{
   if(InpMaxDailyDrawdown <= 0) return false;
   MqlDateTime dt; TimeToStruct(TimeCurrent(), dt);
   datetime today = TimeCurrent() - dt.hour*3600 - dt.min*60 - dt.sec;
   if(today != g_DailyResetDay)
   {
      g_DailyResetDay = today;
      g_DailyStartBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   }
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double dd = ((g_DailyStartBalance - equity) / g_DailyStartBalance) * 100.0;
   return (dd >= InpMaxDailyDrawdown);
}

//+------------------------------------------------------------------+
//| DYNAMIC LOT SIZING (risk-based)                                  |
//+------------------------------------------------------------------+
double CalcLotSize(double slPoints)
{
   if(InpRiskPercent <= 0 || slPoints <= 0) return InpLotSize;
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double riskAmount = balance * (InpRiskPercent / 100.0);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double tickSize  = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   if(tickValue <= 0 || tickSize <= 0) return InpLotSize;
   double pointValue = tickValue / (tickSize / g_Point);
   double lots = riskAmount / (slPoints * pointValue);
   double minLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double maxLot  = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MAX);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   lots = MathFloor(lots / lotStep) * lotStep;
   lots = MathMax(minLot, MathMin(maxLot, lots));
   return NormalizeDouble(lots, 2);
}

//+------------------------------------------------------------------+
//| VOLATILITY SPIKE DETECTION                                        |
//+------------------------------------------------------------------+
bool IsVolatilitySpike()
{
   if(!InpAvoidHighVolSpikes) return false;
   double atrBuf[];
   ArrayResize(atrBuf, 20);
   ArraySetAsSeries(atrBuf, true);
   if(CopyBuffer(g_hATR[0], 0, 0, 20, atrBuf) < 20) return false;
   double avgATR = 0;
   for(int i = 1; i < 20; i++) avgATR += atrBuf[i];
   avgATR /= 19.0;
   return (atrBuf[0] > avgATR * 2.0); // current ATR > 2x average
}

//+------------------------------------------------------------------+
//| V4: ICHIMOKU CLOUD ANALYSIS                                      |
//+------------------------------------------------------------------+
void RefreshIchimokuData()
{
   if(!InpUseIchimoku) return;
   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   for(int i = 0; i < g_MTFCount; i++)
   {
      double buf[];
      ArrayResize(buf, 3);

      if(CopyBuffer(g_hIchimoku[i], 0, 0, 1, buf) >= 1) g_Ichimoku[i].tenkan = buf[0];
      else g_Ichimoku[i].tenkan = 0;
      if(CopyBuffer(g_hIchimoku[i], 1, 0, 1, buf) >= 1) g_Ichimoku[i].kijun = buf[0];
      else g_Ichimoku[i].kijun = 0;
      if(CopyBuffer(g_hIchimoku[i], 2, 0, 1, buf) >= 1) g_Ichimoku[i].senkouA = buf[0];
      else g_Ichimoku[i].senkouA = 0;
      if(CopyBuffer(g_hIchimoku[i], 3, 0, 1, buf) >= 1) g_Ichimoku[i].senkouB = buf[0];
      else g_Ichimoku[i].senkouB = 0;
      if(CopyBuffer(g_hIchimoku[i], 4, 0, 1, buf) >= 1) g_Ichimoku[i].chikou = buf[0];
      else g_Ichimoku[i].chikou = 0;

      double cloudTop = MathMax(g_Ichimoku[i].senkouA, g_Ichimoku[i].senkouB);
      double cloudBot = MathMin(g_Ichimoku[i].senkouA, g_Ichimoku[i].senkouB);

      if(price > cloudTop) g_Ichimoku[i].signal = "ABOVE_CLOUD";
      else if(price < cloudBot) g_Ichimoku[i].signal = "BELOW_CLOUD";
      else g_Ichimoku[i].signal = "IN_CLOUD";

      double prevT[], prevK[];
      ArrayResize(prevT, 2); ArrayResize(prevK, 2);
      if(CopyBuffer(g_hIchimoku[i], 0, 0, 2, prevT) >= 2 &&
         CopyBuffer(g_hIchimoku[i], 1, 0, 2, prevK) >= 2)
      {
         ArraySetAsSeries(prevT, true); ArraySetAsSeries(prevK, true);
         if(prevT[0] > prevK[0] && prevT[1] <= prevK[1])
         { g_Ichimoku[i].tkCross = true; g_Ichimoku[i].isBullish = true; }
         else if(prevT[0] < prevK[0] && prevT[1] >= prevK[1])
         { g_Ichimoku[i].tkCross = true; g_Ichimoku[i].isBullish = false; }
         else
         { g_Ichimoku[i].tkCross = false; g_Ichimoku[i].isBullish = (price > cloudTop); }
      }
   }
}

//+------------------------------------------------------------------+
//| V4: RSI/MACD DIVERGENCE DETECTION                                |
//+------------------------------------------------------------------+
void DetectDivergences()
{
   if(!InpUseDivergence) { ArrayResize(g_Divergences, 0); return; }
   ArrayResize(g_Divergences, 0);

   for(int tfIdx = 1; tfIdx <= 2; tfIdx++)
   {
      double closes[], rsiData[], macdData[];
      ArraySetAsSeries(closes, true); ArraySetAsSeries(rsiData, true); ArraySetAsSeries(macdData, true);
      if(CopyClose(_Symbol, g_MTFList[tfIdx], 0, 30, closes) < 30) continue;
      if(CopyBuffer(g_hRSI[tfIdx], 0, 0, 30, rsiData) < 30) continue;
      if(CopyBuffer(g_hMACD[tfIdx], 0, 0, 30, macdData) < 30) continue;

      int swL1 = -1, swL2 = -1;
      for(int i = 2; i < 15; i++)
      {
         if(closes[i] < closes[i-1] && closes[i] < closes[i-2] &&
            closes[i] < closes[i+1] && closes[i] < closes[i+2])
         { if(swL1 < 0) swL1 = i; else if(swL2 < 0) { swL2 = i; break; } }
      }
      int swH1 = -1, swH2 = -1;
      for(int i = 2; i < 15; i++)
      {
         if(closes[i] > closes[i-1] && closes[i] > closes[i-2] &&
            closes[i] > closes[i+1] && closes[i] > closes[i+2])
         { if(swH1 < 0) swH1 = i; else if(swH2 < 0) { swH2 = i; break; } }
      }

      string tfName = (tfIdx==1) ? "M5" : "M15";

      // Regular Bullish Divergence: Price lower low, RSI higher low
      if(swL1 >= 0 && swL2 >= 0 && closes[swL1] < closes[swL2] && rsiData[swL1] > rsiData[swL2])
      {
         int sz = ArraySize(g_Divergences); ArrayResize(g_Divergences, sz+1);
         g_Divergences[sz].found=true; g_Divergences[sz].isBullish=true; g_Divergences[sz].isHidden=false;
         g_Divergences[sz].indicator="RSI"; g_Divergences[sz].description=tfName+" RSI bull div";
      }
      // Regular Bearish Divergence: Price higher high, RSI lower high
      if(swH1 >= 0 && swH2 >= 0 && closes[swH1] > closes[swH2] && rsiData[swH1] < rsiData[swH2])
      {
         int sz = ArraySize(g_Divergences); ArrayResize(g_Divergences, sz+1);
         g_Divergences[sz].found=true; g_Divergences[sz].isBullish=false; g_Divergences[sz].isHidden=false;
         g_Divergences[sz].indicator="RSI"; g_Divergences[sz].description=tfName+" RSI bear div";
      }
      // Hidden Bullish: Price higher low, RSI lower low
      if(swL1 >= 0 && swL2 >= 0 && closes[swL1] > closes[swL2] && rsiData[swL1] < rsiData[swL2])
      {
         int sz = ArraySize(g_Divergences); ArrayResize(g_Divergences, sz+1);
         g_Divergences[sz].found=true; g_Divergences[sz].isBullish=true; g_Divergences[sz].isHidden=true;
         g_Divergences[sz].indicator="RSI"; g_Divergences[sz].description=tfName+" RSI hidden bull";
      }
      // Hidden Bearish: Price lower high, RSI higher high
      if(swH1 >= 0 && swH2 >= 0 && closes[swH1] < closes[swH2] && rsiData[swH1] > rsiData[swH2])
      {
         int sz = ArraySize(g_Divergences); ArrayResize(g_Divergences, sz+1);
         g_Divergences[sz].found=true; g_Divergences[sz].isBullish=false; g_Divergences[sz].isHidden=true;
         g_Divergences[sz].indicator="RSI"; g_Divergences[sz].description=tfName+" RSI hidden bear";
      }
      // MACD Bullish Divergence
      if(swL1 >= 0 && swL2 >= 0 && closes[swL1] < closes[swL2] && macdData[swL1] > macdData[swL2])
      {
         int sz = ArraySize(g_Divergences); ArrayResize(g_Divergences, sz+1);
         g_Divergences[sz].found=true; g_Divergences[sz].isBullish=true; g_Divergences[sz].isHidden=false;
         g_Divergences[sz].indicator="MACD"; g_Divergences[sz].description=tfName+" MACD bull div";
      }
      // MACD Bearish Divergence
      if(swH1 >= 0 && swH2 >= 0 && closes[swH1] > closes[swH2] && macdData[swH1] < macdData[swH2])
      {
         int sz = ArraySize(g_Divergences); ArrayResize(g_Divergences, sz+1);
         g_Divergences[sz].found=true; g_Divergences[sz].isBullish=false; g_Divergences[sz].isHidden=false;
         g_Divergences[sz].indicator="MACD"; g_Divergences[sz].description=tfName+" MACD bear div";
      }
   }
}

//+------------------------------------------------------------------+
//| V4: AUTO FIBONACCI RETRACEMENT (H4)                              |
//+------------------------------------------------------------------+
void CalculateFibonacci()
{
   if(!InpUseFibonacci) { ArrayResize(g_FibLevels, 0); return; }
   ArrayResize(g_FibLevels, 0);

   double highs[], lows[];
   ArraySetAsSeries(highs, true); ArraySetAsSeries(lows, true);
   if(CopyHigh(_Symbol, PERIOD_H4, 0, 50, highs) < 50) return;
   if(CopyLow(_Symbol, PERIOD_H4, 0, 50, lows) < 50) return;

   double swingHigh = highs[ArrayMaximum(highs, 0, 50)];
   double swingLow  = lows[ArrayMinimum(lows, 0, 50)];
   double range = swingHigh - swingLow;
   if(range <= 0) return;

   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   bool uptrend = (price > (swingHigh + swingLow) / 2.0);

   double fibR[];  string fibL[];
   ArrayResize(fibR, 7); ArrayResize(fibL, 7);
   fibR[0]=0.0;    fibL[0]="0.0%";
   fibR[1]=0.236;  fibL[1]="23.6%";
   fibR[2]=0.382;  fibL[2]="38.2%";
   fibR[3]=0.5;    fibL[3]="50.0%";
   fibR[4]=0.618;  fibL[4]="61.8%";
   fibR[5]=0.786;  fibL[5]="78.6%";
   fibR[6]=1.0;    fibL[6]="100%";

   ArrayResize(g_FibLevels, 7);
   for(int i = 0; i < 7; i++)
   {
      g_FibLevels[i].level = fibR[i];
      if(uptrend) g_FibLevels[i].price = swingHigh - range * fibR[i];
      else        g_FibLevels[i].price = swingLow + range * fibR[i];
      g_FibLevels[i].label = fibL[i];
   }
}

//+------------------------------------------------------------------+
//| V4: ORDER BLOCK DETECTION (Smart Money Concepts)                 |
//+------------------------------------------------------------------+
void DetectOrderBlocks()
{
   if(!InpUseOrderBlocks) { ArrayResize(g_OrderBlocks, 0); return; }
   ArrayResize(g_OrderBlocks, 0);

   double o[], h[], l[], c[];
   ArraySetAsSeries(o, true); ArraySetAsSeries(h, true);
   ArraySetAsSeries(l, true); ArraySetAsSeries(c, true);
   if(CopyOpen(_Symbol, PERIOD_M15, 0, 50, o) < 50) return;
   if(CopyHigh(_Symbol, PERIOD_M15, 0, 50, h) < 50) return;
   if(CopyLow(_Symbol, PERIOD_M15, 0, 50, l) < 50) return;
   if(CopyClose(_Symbol, PERIOD_M15, 0, 50, c) < 50) return;

   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   for(int i = 3; i < 45; i++)
   {
      double body_i = MathAbs(c[i] - o[i]);
      double body_prev = MathAbs(c[i-1] - o[i-1]);

      // Bullish OB: Last bearish candle before strong bullish move
      if(c[i] < o[i] && c[i-1] > o[i-1] && c[i-2] > o[i-2] && body_prev > body_i * 1.5)
      {
         bool mitigated = false;
         for(int j = 0; j < i; j++)
            if(l[j] < l[i]) { mitigated = true; break; }
         if(!mitigated && price > l[i] && (price - l[i]) / g_Point < 5000)
         {
            int sz = ArraySize(g_OrderBlocks);
            if(sz < 5)
            {
               ArrayResize(g_OrderBlocks, sz+1);
               g_OrderBlocks[sz].priceHigh = h[i]; g_OrderBlocks[sz].priceLow = l[i];
               g_OrderBlocks[sz].isBullish = true; g_OrderBlocks[sz].isMitigated = false;
               g_OrderBlocks[sz].strength = MathMin(1.0, body_prev / (body_i + g_Point));
            }
         }
      }
      // Bearish OB: Last bullish candle before strong bearish move
      if(c[i] > o[i] && c[i-1] < o[i-1] && c[i-2] < o[i-2] && body_prev > body_i * 1.5)
      {
         bool mitigated = false;
         for(int j = 0; j < i; j++)
            if(h[j] > h[i]) { mitigated = true; break; }
         if(!mitigated && price < h[i] && (h[i] - price) / g_Point < 5000)
         {
            int sz = ArraySize(g_OrderBlocks);
            if(sz < 5)
            {
               ArrayResize(g_OrderBlocks, sz+1);
               g_OrderBlocks[sz].priceHigh = h[i]; g_OrderBlocks[sz].priceLow = l[i];
               g_OrderBlocks[sz].isBullish = false; g_OrderBlocks[sz].isMitigated = false;
               g_OrderBlocks[sz].strength = MathMin(1.0, body_prev / (body_i + g_Point));
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| V4: FAIR VALUE GAP (FVG) DETECTION                               |
//+------------------------------------------------------------------+
void DetectFairValueGaps()
{
   if(!InpUseFVG) { ArrayResize(g_FVGs, 0); return; }
   ArrayResize(g_FVGs, 0);

   double h[], l[];
   ArraySetAsSeries(h, true); ArraySetAsSeries(l, true);
   if(CopyHigh(_Symbol, PERIOD_M5, 0, 30, h) < 30) return;
   if(CopyLow(_Symbol, PERIOD_M5, 0, 30, l) < 30) return;

   double price = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   for(int i = 1; i < 28; i++)
   {
      // Bullish FVG: candle[i+1].high < candle[i-1].low
      if(l[i-1] > h[i+1])
      {
         double gapHigh = l[i-1], gapLow = h[i+1];
         bool filled = false;
         for(int j = 0; j < i; j++)
            if(l[j] <= gapLow) { filled = true; break; }
         if(!filled && MathAbs(price - (gapHigh+gapLow)/2.0) / g_Point < 3000)
         {
            int sz = ArraySize(g_FVGs);
            if(sz < 5)
            {
               ArrayResize(g_FVGs, sz+1);
               g_FVGs[sz].high = gapHigh; g_FVGs[sz].low = gapLow;
               g_FVGs[sz].isBullish = true; g_FVGs[sz].isFilled = false;
            }
         }
      }
      // Bearish FVG: candle[i-1].high < candle[i+1].low
      if(h[i-1] < l[i+1])
      {
         double gapHigh = l[i+1], gapLow = h[i-1];
         bool filled = false;
         for(int j = 0; j < i; j++)
            if(h[j] >= gapHigh) { filled = true; break; }
         if(!filled && MathAbs(price - (gapHigh+gapLow)/2.0) / g_Point < 3000)
         {
            int sz = ArraySize(g_FVGs);
            if(sz < 5)
            {
               ArrayResize(g_FVGs, sz+1);
               g_FVGs[sz].high = gapHigh; g_FVGs[sz].low = gapLow;
               g_FVGs[sz].isBullish = false; g_FVGs[sz].isFilled = false;
            }
         }
      }
   }
}

//+------------------------------------------------------------------+
//| V4: VWAP CALCULATION (Volume Weighted Average Price)             |
//+------------------------------------------------------------------+
void CalculateVWAP()
{
   if(!InpUseVWAP) { g_VWAP = 0; return; }

   double h[], l[], c[];
   long v[];
   ArraySetAsSeries(h, true); ArraySetAsSeries(l, true);
   ArraySetAsSeries(c, true); ArraySetAsSeries(v, true);

   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   int barsToday = dt.hour * 60 + dt.min + 1;
   if(barsToday < 5) barsToday = 5;
   if(barsToday > 1440) barsToday = 1440;

   if(CopyHigh(_Symbol, PERIOD_M1, 0, barsToday, h) < barsToday) return;
   if(CopyLow(_Symbol, PERIOD_M1, 0, barsToday, l) < barsToday) return;
   if(CopyClose(_Symbol, PERIOD_M1, 0, barsToday, c) < barsToday) return;
   if(CopyTickVolume(_Symbol, PERIOD_M1, 0, barsToday, v) < barsToday) return;

   double cumTPV = 0, cumVol = 0, cumTPV2 = 0;
   for(int i = barsToday - 1; i >= 0; i--)
   {
      double tp = (h[i] + l[i] + c[i]) / 3.0;
      double vol = (double)v[i];
      if(vol <= 0) vol = 1;
      cumTPV += tp * vol;
      cumVol += vol;
      cumTPV2 += tp * tp * vol;
   }

   if(cumVol > 0)
   {
      g_VWAP = cumTPV / cumVol;
      double variance = (cumTPV2 / cumVol) - (g_VWAP * g_VWAP);
      double stdDev = (variance > 0) ? MathSqrt(variance) : 0;
      g_VWAPUpper = g_VWAP + stdDev;
      g_VWAPLower = g_VWAP - stdDev;
   }
}

//+------------------------------------------------------------------+
//| V4: PREVIOUS DAY HIGH/LOW/CLOSE                                  |
//+------------------------------------------------------------------+
void RefreshPrevDayLevels()
{
   if(!InpUsePrevDayHL) return;
   double h[], l[], c[];
   ArraySetAsSeries(h, true); ArraySetAsSeries(l, true); ArraySetAsSeries(c, true);
   if(CopyHigh(_Symbol, PERIOD_D1, 1, 1, h) >= 1)  g_PrevDayHigh = h[0];
   if(CopyLow(_Symbol, PERIOD_D1, 1, 1, l) >= 1)   g_PrevDayLow = l[0];
   if(CopyClose(_Symbol, PERIOD_D1, 1, 1, c) >= 1)  g_PrevDayClose = c[0];
}

//+------------------------------------------------------------------+
//| V4: ASIAN RANGE TRACKING                                         |
//+------------------------------------------------------------------+
void TrackAsianRange()
{
   if(!InpUseAsianRange) return;

   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   datetime today = TimeCurrent() - dt.hour*3600 - dt.min*60 - dt.sec;

   if(today != g_AsianRangeDate)
   {
      g_AsianRangeDate = today;
      g_AsianHigh = 0;
      g_AsianLow = 99999;
      g_AsianRangeSet = false;
   }

   int hour = dt.hour;
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);

   if(hour >= InpAsianStart && hour < InpAsianEnd)
   {
      if(bid > g_AsianHigh) g_AsianHigh = bid;
      if(bid < g_AsianLow) g_AsianLow = bid;
   }
   else if(!g_AsianRangeSet && g_AsianHigh > 0 && g_AsianLow < 99999)
   {
      g_AsianRangeSet = true;
   }
}

//+------------------------------------------------------------------+
//| V4: LONDON FIX TIME CHECK                                       |
//+------------------------------------------------------------------+
void CheckLondonFix()
{
   if(!InpUseLondonFix) { g_NearLondonFix = false; return; }
   MqlDateTime dt;
   TimeToStruct(TimeCurrent(), dt);
   g_NearLondonFix = ((dt.hour == 10 && dt.min >= 15) || (dt.hour == 10 && dt.min <= 45) ||
                       (dt.hour == 14 && dt.min >= 45) || (dt.hour == 15 && dt.min <= 15));
}

//+------------------------------------------------------------------+
//| V4: OBV TREND ANALYSIS                                          |
//+------------------------------------------------------------------+
double GetOBVTrend(int tfIdx)
{
   if(!InpUseOBV) return 0;
   double obv[];
   ArrayResize(obv, 10);
   ArraySetAsSeries(obv, true);
   if(CopyBuffer(g_hOBV[tfIdx], 0, 0, 10, obv) < 10) return 0;
   return (obv[0] - obv[9]);
}

//+------------------------------------------------------------------+
//| ECONOMIC CALENDAR - Read MT5 Built-in Calendar                    |
//| Captures: NFP, CPI, FOMC, GDP, Interest Rates, PMI, etc.        |
//+------------------------------------------------------------------+
void RefreshEconomicCalendar()
{
   if(!InpUseNews) return;
   
   datetime now = TimeCurrent();
   if((int)(now - g_LastNewsUpdate) < InpNewsUpdateSec && g_LastNewsUpdate != 0) return;
   g_LastNewsUpdate = now;
   
   ArrayResize(g_UpcomingNews, 0);
   g_NewsCount = 0;
   g_HighImpactSoon = false;
   
   // Read events from the next 24 hours and last 2 hours
   datetime from = now - 7200;   // 2 hours ago (to show recent releases)
   datetime to   = now + 86400;  // next 24 hours
   
   MqlCalendarValue values[];
   int count = CalendarValueHistory(values, from, to);
   
   if(count > 0)
   {
      // Filter for relevant currencies (USD, EUR, GBP, and the symbol's currencies)
      string relevantCurrencies[];
      ArrayResize(relevantCurrencies, 0);
      
      // Always track USD (gold is priced in USD)
      int rIdx = 0;
      ArrayResize(relevantCurrencies, 5);
      relevantCurrencies[rIdx++] = "USD";
      relevantCurrencies[rIdx++] = "EUR";
      relevantCurrencies[rIdx++] = "GBP";
      relevantCurrencies[rIdx++] = "JPY";
      relevantCurrencies[rIdx++] = "CHF";
      
      for(int i = 0; i < count && g_NewsCount < 20; i++)
      {
         MqlCalendarEvent event;
         if(!CalendarEventById(values[i].event_id, event)) continue;
         
         MqlCalendarCountry country;
         if(!CalendarCountryById(event.country_id, country)) continue;
         
         // Check if this currency is relevant
         bool isRelevant = false;
         for(int c = 0; c < rIdx; c++)
         {
            if(country.currency == relevantCurrencies[c]) { isRelevant = true; break; }
         }
         if(!isRelevant) continue;
         
         // Determine impact level
         string impact = "LOW";
         if(event.importance == CALENDAR_IMPORTANCE_HIGH) impact = "HIGH";
         else if(event.importance == CALENDAR_IMPORTANCE_MODERATE) impact = "MEDIUM";
         else continue; // Skip low-impact events
         
         // Add to list
         int idx = g_NewsCount;
         ArrayResize(g_UpcomingNews, idx + 1);
         g_UpcomingNews[idx].title = event.name;
         g_UpcomingNews[idx].currency = country.currency;
         g_UpcomingNews[idx].impact = impact;
         g_UpcomingNews[idx].eventTime = values[i].time;
         
         // Format actual/forecast/previous values
         if(values[i].HasActualValue())
            g_UpcomingNews[idx].actual = DoubleToString(values[i].GetActualValue(), 2);
         else
            g_UpcomingNews[idx].actual = "--";
            
         if(values[i].HasForecastValue())
            g_UpcomingNews[idx].forecast = DoubleToString(values[i].GetForecastValue(), 2);
         else
            g_UpcomingNews[idx].forecast = "--";
            
         if(values[i].HasPreviousValue())
            g_UpcomingNews[idx].previous = DoubleToString(values[i].GetPreviousValue(), 2);
         else
            g_UpcomingNews[idx].previous = "--";
         
         // Minutes until event
         int minUntil = (int)((values[i].time - now) / 60);
         g_UpcomingNews[idx].minutesUntil = minUntil;
         
         // Check if high-impact event is within pause window
         if(impact == "HIGH" && MathAbs(minUntil) <= InpNewsPauseMinutes)
         {
            g_HighImpactSoon = true;
         }
         
         g_NewsCount++;
      }
   }
   
   // Update next event display
   if(g_NewsCount > 0)
   {
      // Find closest upcoming event
      int closestIdx = -1;
      int closestMin = 999999;
      for(int i = 0; i < g_NewsCount; i++)
      {
         if(g_UpcomingNews[i].minutesUntil >= -5 && g_UpcomingNews[i].minutesUntil < closestMin)
         {
            closestMin = g_UpcomingNews[i].minutesUntil;
            closestIdx = i;
         }
      }
      if(closestIdx >= 0)
      {
         string timeStr = "";
         if(closestMin > 60)
            timeStr = IntegerToString(closestMin / 60) + "h" + IntegerToString(closestMin % 60) + "m";
         else if(closestMin >= 0)
            timeStr = IntegerToString(closestMin) + "m";
         else
            timeStr = IntegerToString(-closestMin) + "m ago";
            
         g_NextNewsEvent = g_UpcomingNews[closestIdx].impact + " " +
                          g_UpcomingNews[closestIdx].currency + " " +
                          StringSubstr(g_UpcomingNews[closestIdx].title, 0, 20) + 
                          " [" + timeStr + "]";
      }
      else
      {
         g_NextNewsEvent = "No upcoming events";
      }
      g_NewsStatus = "ACTIVE";
   }
   else
   {
      g_NextNewsEvent = "No events found";
      g_NewsStatus = "ACTIVE";
   }
   
   // Fetch headlines from Finnhub if API key provided
   if(StringLen(InpFinnhubAPIKey) > 5)
   {
      FetchFinnhubNews();
   }
   
   // Analyze overall news sentiment
   AnalyzeNewsSentiment();
   
   Print("NEWS: ", g_NewsCount, " calendar events | ", g_HeadlineCount, " headlines | Sentiment: ", g_NewsSentiment,
         " | HighImpact: ", (g_HighImpactSoon ? "YES - PAUSING" : "No"));
}

//+------------------------------------------------------------------+
//| FINNHUB NEWS API - Real-time market headlines                     |
//| Free API key at https://finnhub.io                                |
//| Add https://finnhub.io to MT5 allowed URLs                       |
//+------------------------------------------------------------------+
void FetchFinnhubNews()
{
   ArrayResize(g_Headlines, 0);
   g_HeadlineCount = 0;
   
   // Build URL for general/forex news
   // Finnhub general news endpoint covers gold, forex, macro
   string url = "https://finnhub.io/api/v1/news?category=general&token=" + InpFinnhubAPIKey;
   
   string headers = "Content-Type: application/json\r\n";
   char postData[], result[];
   string resultHeaders;
   
   int res = WebRequest("GET", url, headers, 5000, postData, result, resultHeaders);
   
   if(res == -1)
   {
      int err = GetLastError();
      if(err == 4060)
         Print("NEWS ERROR: Add https://finnhub.io to Tools > Options > Expert Advisors > Allow WebRequest");
      return;
   }
   
   if(res != 200)
   {
      Print("NEWS ERROR: Finnhub returned HTTP ", res);
      return;
   }
   
   string json = CharArrayToString(result);
   
   // Parse JSON array of news objects
   // Format: [{"headline":"...","source":"...","datetime":123456,...}, ...]
   int searchPos = 0;
   while(g_HeadlineCount < 15 && searchPos < StringLen(json))
   {
      // Find next headline field
      int hlStart = StringFind(json, "\"headline\":\"", searchPos);
      if(hlStart < 0) break;
      hlStart += StringLen("\"headline\":\"");
      
      int hlEnd = StringFind(json, "\"", hlStart);
      if(hlEnd < 0) break;
      
      string headline = StringSubstr(json, hlStart, hlEnd - hlStart);
      // Unescape basic JSON
      StringReplace(headline, "\\\"", "\"");
      StringReplace(headline, "\\n", " ");
      
      // Find source
      string source = "";
      int srcStart = StringFind(json, "\"source\":\"", hlEnd);
      if(srcStart >= 0 && srcStart < hlEnd + 500)
      {
         srcStart += StringLen("\"source\":\"");
         int srcEnd = StringFind(json, "\"", srcStart);
         if(srcEnd >= 0) source = StringSubstr(json, srcStart, srcEnd - srcStart);
      }
      
      // Filter: only keep relevant news (gold, USD, Fed, rates, inflation, etc.)
      string hlLower = headline;
      StringToLower(hlLower);
      
      bool isRelevant = false;
      if(StringFind(hlLower, "gold") >= 0 || StringFind(hlLower, "xau") >= 0 ||
         StringFind(hlLower, "precious") >= 0 || StringFind(hlLower, "metal") >= 0 ||
         StringFind(hlLower, "dollar") >= 0 || StringFind(hlLower, "usd") >= 0 ||
         StringFind(hlLower, "fed") >= 0 || StringFind(hlLower, "fomc") >= 0 ||
         StringFind(hlLower, "rate") >= 0 || StringFind(hlLower, "interest") >= 0 ||
         StringFind(hlLower, "inflation") >= 0 || StringFind(hlLower, "cpi") >= 0 ||
         StringFind(hlLower, "nfp") >= 0 || StringFind(hlLower, "payroll") >= 0 ||
         StringFind(hlLower, "gdp") >= 0 || StringFind(hlLower, "treasury") >= 0 ||
         StringFind(hlLower, "yield") >= 0 || StringFind(hlLower, "bond") >= 0 ||
         StringFind(hlLower, "geopolit") >= 0 || StringFind(hlLower, "war") >= 0 ||
         StringFind(hlLower, "crisis") >= 0 || StringFind(hlLower, "safe haven") >= 0 ||
         StringFind(hlLower, "recession") >= 0 || StringFind(hlLower, "tariff") >= 0 ||
         StringFind(hlLower, "trade war") >= 0 || StringFind(hlLower, "sanction") >= 0 ||
         StringFind(hlLower, "central bank") >= 0 || StringFind(hlLower, "powell") >= 0 ||
         StringFind(hlLower, "employment") >= 0 || StringFind(hlLower, "jobs") >= 0 ||
         StringFind(hlLower, "forex") >= 0 || StringFind(hlLower, "currency") >= 0 ||
         StringFind(hlLower, "market") >= 0 || StringFind(hlLower, "stock") >= 0 ||
         StringFind(hlLower, "oil") >= 0 || StringFind(hlLower, "commodit") >= 0)
      {
         isRelevant = true;
      }
      
      if(isRelevant)
      {
         int idx = g_HeadlineCount;
         ArrayResize(g_Headlines, idx + 1);
         g_Headlines[idx].headline = headline;
         g_Headlines[idx].source = source;
         g_Headlines[idx].time = TimeCurrent(); // approximate
         
         // Simple keyword-based sentiment analysis
         g_Headlines[idx].sentiment = AnalyzeHeadlineSentiment(hlLower);
         g_HeadlineCount++;
      }
      
      searchPos = hlEnd + 1;
   }
}

//+------------------------------------------------------------------+
//| HEADLINE SENTIMENT ANALYZER                                       |
//| Keyword-based: detects bullish/bearish tone for gold              |
//+------------------------------------------------------------------+
string AnalyzeHeadlineSentiment(string hlLower)
{
   int bullScore = 0;
   int bearScore = 0;
   
   // GOLD BULLISH keywords (things that push gold up)
   if(StringFind(hlLower, "gold ris") >= 0 || StringFind(hlLower, "gold surg") >= 0 ||
      StringFind(hlLower, "gold rally") >= 0 || StringFind(hlLower, "gold gain") >= 0 ||
      StringFind(hlLower, "gold hit") >= 0 || StringFind(hlLower, "gold record") >= 0 ||
      StringFind(hlLower, "gold high") >= 0)
      bullScore += 3;
   
   if(StringFind(hlLower, "safe haven") >= 0 || StringFind(hlLower, "haven demand") >= 0)
      bullScore += 2;
   
   if(StringFind(hlLower, "rate cut") >= 0 || StringFind(hlLower, "dovish") >= 0 ||
      StringFind(hlLower, "easing") >= 0 || StringFind(hlLower, "stimulus") >= 0)
      bullScore += 2;
   
   if(StringFind(hlLower, "dollar weak") >= 0 || StringFind(hlLower, "usd fall") >= 0 ||
      StringFind(hlLower, "dollar drop") >= 0 || StringFind(hlLower, "dollar decline") >= 0)
      bullScore += 2;
   
   if(StringFind(hlLower, "inflation ris") >= 0 || StringFind(hlLower, "inflation high") >= 0 ||
      StringFind(hlLower, "inflation surge") >= 0 || StringFind(hlLower, "cpi high") >= 0)
      bullScore += 2;
   
   if(StringFind(hlLower, "geopolit") >= 0 || StringFind(hlLower, "tension") >= 0 ||
      StringFind(hlLower, "war") >= 0 || StringFind(hlLower, "conflict") >= 0 ||
      StringFind(hlLower, "crisis") >= 0 || StringFind(hlLower, "uncertain") >= 0)
      bullScore += 1;
   
   if(StringFind(hlLower, "recession") >= 0 || StringFind(hlLower, "slowdown") >= 0 ||
      StringFind(hlLower, "contraction") >= 0)
      bullScore += 1;
   
   // GOLD BEARISH keywords (things that push gold down)
   if(StringFind(hlLower, "gold fall") >= 0 || StringFind(hlLower, "gold drop") >= 0 ||
      StringFind(hlLower, "gold slide") >= 0 || StringFind(hlLower, "gold decline") >= 0 ||
      StringFind(hlLower, "gold slump") >= 0 || StringFind(hlLower, "gold low") >= 0)
      bearScore += 3;
   
   if(StringFind(hlLower, "rate hike") >= 0 || StringFind(hlLower, "hawkish") >= 0 ||
      StringFind(hlLower, "tightening") >= 0 || StringFind(hlLower, "higher rate") >= 0)
      bearScore += 2;
   
   if(StringFind(hlLower, "dollar strong") >= 0 || StringFind(hlLower, "usd ris") >= 0 ||
      StringFind(hlLower, "dollar gain") >= 0 || StringFind(hlLower, "dollar surge") >= 0 ||
      StringFind(hlLower, "dxy high") >= 0)
      bearScore += 2;
   
   if(StringFind(hlLower, "inflation cool") >= 0 || StringFind(hlLower, "inflation eas") >= 0 ||
      StringFind(hlLower, "cpi low") >= 0 || StringFind(hlLower, "disinflation") >= 0)
      bearScore += 1;
   
   if(StringFind(hlLower, "risk on") >= 0 || StringFind(hlLower, "optimis") >= 0 ||
      (StringFind(hlLower, "rally") >= 0 && StringFind(hlLower, "stock") >= 0))
      bearScore += 1;
   
   if(bullScore > bearScore) return "BULLISH";
   if(bearScore > bullScore) return "BEARISH";
   return "NEUTRAL";
}

//+------------------------------------------------------------------+
//| OVERALL NEWS SENTIMENT - Aggregate all sources                    |
//+------------------------------------------------------------------+
void AnalyzeNewsSentiment()
{
   g_NewsBullish = 0;
   g_NewsBearish = 0;
   
   // From headlines
   for(int i = 0; i < g_HeadlineCount; i++)
   {
      if(g_Headlines[i].sentiment == "BULLISH") g_NewsBullish++;
      else if(g_Headlines[i].sentiment == "BEARISH") g_NewsBearish++;
   }
   
   // From calendar events (actual vs forecast)
   for(int i = 0; i < g_NewsCount; i++)
   {
      if(g_UpcomingNews[i].actual != "--" && g_UpcomingNews[i].forecast != "--")
      {
         double actual = StringToDouble(g_UpcomingNews[i].actual);
         double forecast = StringToDouble(g_UpcomingNews[i].forecast);
         
         // For USD events: better-than-expected USD data = bearish gold
         if(g_UpcomingNews[i].currency == "USD")
         {
            if(actual > forecast) g_NewsBearish++; // Strong USD = bearish gold
            else if(actual < forecast) g_NewsBullish++; // Weak USD = bullish gold
         }
      }
   }
   
   if(g_NewsBullish > g_NewsBearish + 1) g_NewsSentiment = "BULLISH";
   else if(g_NewsBearish > g_NewsBullish + 1) g_NewsSentiment = "BEARISH";
   else g_NewsSentiment = "NEUTRAL";
}

//+------------------------------------------------------------------+
//| CHECK IF HIGH-IMPACT NEWS IS NEAR (pause trading)                 |
//+------------------------------------------------------------------+
bool IsHighImpactNewsPaused()
{
   if(!InpPauseBeforeNews) return false;
   return g_HighImpactSoon;
}

//+------------------------------------------------------------------+
//| BUILD NEWS CONTEXT FOR AI (sent along with technical data)        |
//+------------------------------------------------------------------+
string BuildNewsContext()
{
   if(!InpUseNews && !InpNewsAffectsAI) return "";
   
   string ctx = "\n=== REAL-TIME NEWS & FUNDAMENTALS ===\n";
   ctx += "News Sentiment: " + g_NewsSentiment + 
          " (Bullish: " + IntegerToString(g_NewsBullish) + 
          " | Bearish: " + IntegerToString(g_NewsBearish) + ")\n";
   
   if(g_HighImpactSoon)
      ctx += "*** HIGH-IMPACT NEWS IMMINENT - TRADING PAUSED ***\n";
   
   // Upcoming calendar events
   if(g_NewsCount > 0)
   {
      ctx += "\nECONOMIC CALENDAR (next 24h):\n";
      for(int i = 0; i < MathMin(g_NewsCount, 10); i++)
      {
         string timeStr = "";
         int m = g_UpcomingNews[i].minutesUntil;
         if(m > 60) timeStr = "in " + IntegerToString(m/60) + "h" + IntegerToString(m%60) + "m";
         else if(m > 0) timeStr = "in " + IntegerToString(m) + "m";
         else if(m > -60) timeStr = IntegerToString(-m) + "m ago";
         else timeStr = IntegerToString(-m/60) + "h ago";
         
         ctx += "  [" + g_UpcomingNews[i].impact + "] " + g_UpcomingNews[i].currency + " " +
                g_UpcomingNews[i].title + " (" + timeStr + ")";
         
         if(g_UpcomingNews[i].actual != "--")
            ctx += " Actual=" + g_UpcomingNews[i].actual;
         if(g_UpcomingNews[i].forecast != "--")
            ctx += " Forecast=" + g_UpcomingNews[i].forecast;
         if(g_UpcomingNews[i].previous != "--")
            ctx += " Prev=" + g_UpcomingNews[i].previous;
         ctx += "\n";
      }
   }
   
   // Headlines
   if(g_HeadlineCount > 0)
   {
      ctx += "\nMARKET NEWS HEADLINES:\n";
      for(int i = 0; i < MathMin(g_HeadlineCount, 10); i++)
      {
         ctx += "  [" + g_Headlines[i].sentiment + "] " + 
                StringSubstr(g_Headlines[i].headline, 0, 100) + 
                " (" + g_Headlines[i].source + ")\n";
      }
   }
   
   ctx += "\nNEWS TRADING GUIDANCE:\n";
   ctx += "- If high-impact news is imminent, consider WAIT\n";
   ctx += "- Better-than-expected USD data = bearish gold (stronger dollar)\n";
   ctx += "- Rate cuts/dovish Fed = bullish gold (weaker dollar)\n";
   ctx += "- Geopolitical tensions/crises = bullish gold (safe haven)\n";
   ctx += "- Factor news sentiment into your confidence level\n";
   ctx += "- News can override technicals - a strong NFP miss can reverse trends\n";
   
   return ctx;
}

//+------------------------------------------------------------------+
//| UPDATE ALL DATA                                                   |
//+------------------------------------------------------------------+
void UpdateAllData()
{
   // Refresh all MTF indicators
   RefreshMTFData();

   // V4: Advanced analysis (every 5 seconds)
   static datetime lastV4Refresh = 0;
   if(TimeCurrent() - lastV4Refresh >= 5)
   {
      RefreshIchimokuData();
      DetectDivergences();
      CalculateFibonacci();
      DetectOrderBlocks();
      DetectFairValueGaps();
      CalculateVWAP();
      RefreshPrevDayLevels();
      TrackAsianRange();
      CheckLondonFix();
      lastV4Refresh = TimeCurrent();
   }

   // Refresh news & economic calendar
   RefreshEconomicCalendar();

   // Detect key levels (every 60 seconds)
   static datetime lastLevelDetect = 0;
   if(TimeCurrent() - lastLevelDetect >= 60) { DetectKeyLevels(); lastLevelDetect = TimeCurrent(); }

   // Calculate confluence
   g_Confluence = CalculateConfluence();

   // Tick velocity
   datetime curSec = TimeCurrent();
   if(curSec != g_LastSec) { g_LastSec = curSec; g_TicksPerSec = 0; }
   g_TicksPerSec++;

   // Update UI
   MTFData m1 = g_MTF[0];
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   UpdateUI("RSI", DoubleToString(m1.rsi,1), (m1.rsi<30)?ClrBuy:(m1.rsi>70)?ClrSell:ClrValue);
   UpdateUI("MACD", (m1.macdHist>0?"BULL ":"BEAR ") + DoubleToString(m1.macdHist, g_Digits), (m1.macdHist>0)?ClrBuy:ClrSell);
   UpdateUI("Stoch", DoubleToString(m1.stochK,1)+"/"+DoubleToString(m1.stochD,1), (m1.stochK<20)?ClrBuy:(m1.stochK>80)?ClrSell:ClrValue);
   UpdateUI("ADX", DoubleToString(m1.adx,1) + (m1.adx>25?" TREND":" RANGE"), (m1.adx>25)?ClrBuy:ClrNeutral);
   UpdateUI("BB", (bid>=m1.bbUpper?"UPPER":(bid<=m1.bbLower?"LOWER":"MID")), (bid<=m1.bbLower)?ClrBuy:(bid>=m1.bbUpper)?ClrSell:ClrValue);
   UpdateUI("Pattern", g_LastPattern.name, g_LastPattern.isBullish?ClrBuy:ClrSell);

   // MTF structure
   string structStr = "";
   for(int i = 0; i < g_MTFCount; i++)
   {
      string tfName = "";
      switch(g_MTFList[i])
      {
         case PERIOD_M1: tfName="M1"; break; case PERIOD_M5: tfName="M5"; break;
         case PERIOD_M15: tfName="M15"; break; case PERIOD_H1: tfName="H1"; break;
         case PERIOD_H4: tfName="H4"; break;
      }
      string bStr = (g_MTF[i].bias==BIAS_BULLISH)?"B":(g_MTF[i].bias==BIAS_BEARISH)?"S":"N";
      if(i > 0) structStr += " ";
      structStr += tfName + ":" + bStr;
   }
   UpdateUI("MTF", structStr, ClrValue);

   // Confluence
   color cfColor = (g_Confluence.signal=="BUY")?ClrBuy:(g_Confluence.signal=="SELL")?ClrSell:ClrWarning;
   UpdateUI("Confluence", g_Confluence.signal + " [" + IntegerToString(g_Confluence.score) + "/15]", cfColor);
   UpdateUI("ConfDetail", IntegerToString(g_Confluence.buyPoints)+"B / "+IntegerToString(g_Confluence.sellPoints)+"S", cfColor);

   // Session
   string sess = GetSession();
   UpdateUI("Session", sess, (sess=="OVERLAP")?ClrBuy:(sess=="ASIAN")?ClrNeutral:ClrValue);

   // Positions
   int openPos = CountPositions();
   UpdateUI("Positions", IntegerToString(openPos)+"/"+IntegerToString(InpMaxPositions), (openPos>=InpMaxPositions)?ClrWarning:ClrValue);

   // Daily P&L
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double dailyPL = equity - g_DailyStartBalance;
   double dailyPct = (g_DailyStartBalance > 0) ? (dailyPL / g_DailyStartBalance * 100.0) : 0;
   UpdateUI("DailyPL", DoubleToString(dailyPL,2)+" ("+DoubleToString(dailyPct,2)+"%)", (dailyPL>=0)?ClrBuy:ClrSell);

   // Win rate
   double wr = (g_TotalTrades>0) ? ((double)g_Wins / g_TotalTrades * 100.0) : 0;
   UpdateUI("WinRate", IntegerToString(g_Wins)+"/"+IntegerToString(g_TotalTrades)+" ("+DoubleToString(wr,0)+"%)", (wr>=50)?ClrBuy:ClrSell);

   // Velocity
   UpdateUI("Velocity", IntegerToString(g_TicksPerSec)+" t/s", ClrValue);

   // News
   if(InpUseNews)
   {
      color newsColor = (g_NewsSentiment=="BULLISH")?ClrBuy:(g_NewsSentiment=="BEARISH")?ClrSell:ClrNeutral;
      UpdateUI("NewsSentiment", g_NewsSentiment + " (" + IntegerToString(g_NewsBullish) + "B/" + IntegerToString(g_NewsBearish) + "S)", newsColor);
      string nextEvt = StringSubstr(g_NextNewsEvent, 0, 35);
      color evtColor = (g_HighImpactSoon)?ClrSell:ClrValue;
      UpdateUI("NextNews", nextEvt, evtColor);
      UpdateUI("NewsPause", g_HighImpactSoon?"PAUSED - HIGH IMPACT":"Trading OK", g_HighImpactSoon?ClrSell:ClrBuy);
   }

   // V4: Advanced dashboard updates
   if(InpUseIchimoku)
   {
      string ichiSig = g_Ichimoku[0].signal;
      if(g_Ichimoku[0].tkCross) ichiSig += (g_Ichimoku[0].isBullish ? " TK↑" : " TK↓");
      color ichiClr = (g_Ichimoku[0].signal=="ABOVE_CLOUD")?ClrBuy:(g_Ichimoku[0].signal=="BELOW_CLOUD")?ClrSell:ClrWarning;
      UpdateUI("Ichimoku", ichiSig, ichiClr);
   }
   {
      int divB=0, divS=0;
      for(int dv=0; dv<ArraySize(g_Divergences); dv++)
      { if(g_Divergences[dv].isBullish) divB++; else divS++; }
      string divStr = (ArraySize(g_Divergences)==0) ? "None" : IntegerToString(divB)+"B/"+IntegerToString(divS)+"S";
      color divClr = (divB>divS)?ClrBuy:(divS>divB)?ClrSell:ClrNeutral;
      UpdateUI("Diverg", divStr, divClr);
   }
   if(g_VWAP > 0)
   {
      double vBid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      UpdateUI("VWAP", DoubleToString(g_VWAP, g_Digits) + (vBid>g_VWAP?" ↑":" ↓"), (vBid>g_VWAP)?ClrBuy:ClrSell);
   }
   UpdateUI("SMC", IntegerToString(ArraySize(g_OrderBlocks))+"OB "+IntegerToString(ArraySize(g_FVGs))+"FVG", ClrValue);
   if(g_PrevDayHigh > 0)
      UpdateUI("PrevDay", "H:"+DoubleToString(g_PrevDayHigh,g_Digits)+" L:"+DoubleToString(g_PrevDayLow,g_Digits), ClrValue);
   if(g_AsianRangeSet)
   {
      double aBid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      string arStr = DoubleToString(g_AsianLow,g_Digits)+"-"+DoubleToString(g_AsianHigh,g_Digits);
      color arClr = (aBid>g_AsianHigh)?ClrBuy:(aBid<g_AsianLow)?ClrSell:ClrNeutral;
      UpdateUI("AsianR", arStr, arClr);
   }

   // AI
   if(InpUseAI) UpdateAI();

   // Trading
   if(InpEnableTrading)
   {
      ManageTrailing();
      ManagePositions();
      if(!InpTestMode || !g_TestDone)
         CheckTrades();
   }
}

//+------------------------------------------------------------------+
//| AI ANALYSIS                                                       |
//+------------------------------------------------------------------+
void UpdateAI()
{
   datetime now = TimeCurrent();
   if((int)(now - g_LastAIUpdate) < InpAIUpdateSec && g_LastAIUpdate != 0) {
      // Just update UI with cached values
      UpdateAIUI();
      return;
   }
   g_LastAIUpdate = now;

   string context = BuildAIContext();
   string aiResp = CallClaudeAI(context);
   ParseAIResponse(aiResp);

   Print("AI: ", g_AISignal, " conf=", DoubleToString(g_AIConfidence,2), " | ", g_AIReasoning);
   UpdateAIUI();
}

void UpdateAIUI()
{
   color sc = (g_AISignal=="BUY")?ClrBuy:(g_AISignal=="SELL")?ClrSell:ClrWarning;
   UpdateUI("AISignal", g_AISignal, sc);
   UpdateUI("AIConf", DoubleToString(g_AIConfidence*100,1)+"%", (g_AIConfidence>=InpAIConfidenceMin)?ClrBuy:ClrWarning);
   string reason = StringSubstr(g_AIReasoning, 0, 40);
   if(StringLen(g_AIReasoning) > 40) reason += "...";
   UpdateUI("AIReason", reason, sc);
   UpdateUI("AIStatus", "AI: " + g_AIStatus, (g_AIStatus=="ACTIVE")?ClrBuy:(g_AIStatus=="ERROR")?ClrSell:ClrWarning);
}

//+------------------------------------------------------------------+
//| BUILD RICH AI CONTEXT                                             |
//+------------------------------------------------------------------+
string BuildAIContext()
{
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double equity  = AccountInfoDouble(ACCOUNT_EQUITY);
   double freeMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
   double wr = (g_TotalTrades>0) ? ((double)g_Wins/g_TotalTrades*100.0) : 0;

   string ctx = "You are an elite institutional Gold (XAUUSD) trading AI with expertise in Smart Money Concepts, Ichimoku, and macro analysis.\n";
   ctx += "Analyze ALL data: technicals, MTF, Ichimoku Cloud, divergences, Fibonacci, Order Blocks, FVGs, VWAP, and news.\n";
   ctx += "Think like a Goldman Sachs proprietary trader who combines SMC order flow with macro fundamentals.\n";
   ctx += "GOLD KNOWLEDGE: Gold is inversely correlated with USD/DXY, positively with uncertainty/fear.\n";
   ctx += "Gold rallies on: rate cuts, dovish Fed, inflation fears, geopolitical risk, weak USD, risk-off.\n";
   ctx += "Gold falls on: rate hikes, hawkish Fed, strong USD, risk-on sentiment, deflation fears.\n";
   ctx += "KEY: Ichimoku cloud, Order Blocks, divergences, and VWAP are HIGH-WEIGHT signals for gold.\n";
   ctx += "NEWS IS CRITICAL: Factor economic calendar events and headlines into your decision and confidence.\n\n";

   // Account
   ctx += "ACCOUNT: Balance=" + DoubleToString(balance,2) + " Equity=" + DoubleToString(equity,2) +
          " FreeMargin=" + DoubleToString(freeMargin,2) + "\n";
   ctx += "PERFORMANCE: " + IntegerToString(g_TotalTrades) + " trades, " +
          IntegerToString(g_Wins) + "W/" + IntegerToString(g_Losses) + "L (" +
          DoubleToString(wr,1) + "%), P&L=" + DoubleToString(g_TotalProfit,2) + "\n";
   double dailyPL = equity - g_DailyStartBalance;
   ctx += "TODAY: " + DoubleToString(dailyPL,2) + " (" + DoubleToString(dailyPL/MathMax(g_DailyStartBalance,1)*100,2) + "%)\n\n";

   // Price
   ctx += "PRICE: Bid=" + DoubleToString(bid, g_Digits) + " Ask=" + DoubleToString(ask, g_Digits) +
          " Spread=" + DoubleToString((ask-bid)/g_Point, 0) + "pts\n";
   ctx += "Session: " + GetSession() + " | Velocity: " + IntegerToString(g_TicksPerSec) + " t/s\n\n";

   // MTF Technical Analysis
   ctx += "=== MULTI-TIMEFRAME ANALYSIS ===\n";
   for(int i = 0; i < g_MTFCount; i++)
   {
      string tfName = "";
      switch(g_MTFList[i])
      {
         case PERIOD_M1: tfName="M1"; break; case PERIOD_M5: tfName="M5"; break;
         case PERIOD_M15: tfName="M15"; break; case PERIOD_H1: tfName="H1"; break;
         case PERIOD_H4: tfName="H4"; break;
      }
      string biasStr = (g_MTF[i].bias==BIAS_BULLISH)?"BULLISH":(g_MTF[i].bias==BIAS_BEARISH)?"BEARISH":"NEUTRAL";
      string structStr = (g_MTF[i].structure==STRUCT_UPTREND)?"UPTREND":(g_MTF[i].structure==STRUCT_DOWNTREND)?"DOWNTREND":"RANGING";
      ctx += tfName + ": Bias=" + biasStr + " Structure=" + structStr +
             " RSI=" + DoubleToString(g_MTF[i].rsi,1) +
             " MACD=" + DoubleToString(g_MTF[i].macdHist, g_Digits) +
             " Stoch=" + DoubleToString(g_MTF[i].stochK,0) + "/" + DoubleToString(g_MTF[i].stochD,0) +
             " ADX=" + DoubleToString(g_MTF[i].adx,0) +
             " ATR=" + DoubleToString(g_MTF[i].atr, g_Digits) + "\n";
      ctx += "  MAs: EMA9=" + DoubleToString(g_MTF[i].maFast, g_Digits) +
             " EMA21=" + DoubleToString(g_MTF[i].maMid, g_Digits) +
             " EMA50=" + DoubleToString(g_MTF[i].maSlow, g_Digits) +
             " SMA200=" + DoubleToString(g_MTF[i].ma200, g_Digits) + "\n";
      ctx += "  BB: Upper=" + DoubleToString(g_MTF[i].bbUpper, g_Digits) +
             " Mid=" + DoubleToString(g_MTF[i].bbMiddle, g_Digits) +
             " Lower=" + DoubleToString(g_MTF[i].bbLower, g_Digits) +
             " Sentiment=" + DoubleToString(g_MTF[i].sentiment, 0) + "%\n";
   }

   // Candle patterns
   ctx += "\n=== CANDLESTICK PATTERNS ===\n";
   ENUM_TIMEFRAMES patTFs[3];
   patTFs[0] = PERIOD_M1;
   patTFs[1] = PERIOD_M5;
   patTFs[2] = PERIOD_M15;
   for(int i = 0; i < 3; i++)
   {
      CandlePatternResult p = DetectCandlePatterns(patTFs[i]);
      string tfN = (i==0)?"M1":(i==1)?"M5":"M15";
      if(p.pattern != PAT_NONE)
         ctx += tfN + ": " + p.name + " (" + (p.isBullish?"Bullish":"Bearish") + " str=" + DoubleToString(p.strength,2) + ")\n";
      else
         ctx += tfN + ": No pattern\n";
   }

   // Key levels
   ctx += "\n=== KEY LEVELS ===\n";
   for(int i = 0; i < MathMin(ArraySize(g_KeyLevels), 10); i++)
   {
      double dist = (bid - g_KeyLevels[i].price) / g_Point;
      ctx += g_KeyLevels[i].label + ": " + DoubleToString(g_KeyLevels[i].price, g_Digits) +
             " (" + DoubleToString(dist, 0) + "pts " + (dist>0?"above":"below") + ") " +
             (g_KeyLevels[i].isSupport?"[Support]":"[Resistance]") + "\n";
   }

   // V4: Ichimoku Cloud
   if(InpUseIchimoku)
   {
      ctx += "\n=== ICHIMOKU CLOUD ===\n";
      for(int ic = 0; ic < g_MTFCount; ic++)
      {
         string tfN2 = "";
         switch(g_MTFList[ic])
         {
            case PERIOD_M1: tfN2="M1"; break; case PERIOD_M5: tfN2="M5"; break;
            case PERIOD_M15: tfN2="M15"; break; case PERIOD_H1: tfN2="H1"; break;
            case PERIOD_H4: tfN2="H4"; break;
         }
         ctx += tfN2 + ": " + g_Ichimoku[ic].signal +
                " Tenkan=" + DoubleToString(g_Ichimoku[ic].tenkan, g_Digits) +
                " Kijun=" + DoubleToString(g_Ichimoku[ic].kijun, g_Digits) +
                " SenkouA=" + DoubleToString(g_Ichimoku[ic].senkouA, g_Digits) +
                " SenkouB=" + DoubleToString(g_Ichimoku[ic].senkouB, g_Digits);
         if(g_Ichimoku[ic].tkCross) ctx += " [TK CROSS " + (string)(g_Ichimoku[ic].isBullish ? "BULL" : "BEAR") + "]";
         ctx += "\n";
      }
   }

   // V4: Divergences
   if(InpUseDivergence && ArraySize(g_Divergences) > 0)
   {
      ctx += "\n=== DIVERGENCES DETECTED ===\n";
      for(int dv = 0; dv < ArraySize(g_Divergences); dv++)
         ctx += "  " + g_Divergences[dv].description + (g_Divergences[dv].isHidden ? " (hidden)" : " (regular)") + "\n";
   }

   // V4: Fibonacci
   if(InpUseFibonacci && ArraySize(g_FibLevels) > 0)
   {
      ctx += "\n=== FIBONACCI RETRACEMENT (H4) ===\n";
      for(int fb = 0; fb < ArraySize(g_FibLevels); fb++)
      {
         double fibDist = (bid - g_FibLevels[fb].price) / g_Point;
         ctx += "  " + g_FibLevels[fb].label + ": " + DoubleToString(g_FibLevels[fb].price, g_Digits) +
                " (" + DoubleToString(fibDist, 0) + "pts)\n";
      }
   }

   // V4: Smart Money Concepts
   if(InpUseOrderBlocks && ArraySize(g_OrderBlocks) > 0)
   {
      ctx += "\n=== ORDER BLOCKS (SMC) ===\n";
      for(int ob = 0; ob < ArraySize(g_OrderBlocks); ob++)
      {
         double obDist2 = (bid - (g_OrderBlocks[ob].priceHigh + g_OrderBlocks[ob].priceLow) / 2.0) / g_Point;
         ctx += "  " + (string)(g_OrderBlocks[ob].isBullish ? "DEMAND" : "SUPPLY") + " OB: " +
                DoubleToString(g_OrderBlocks[ob].priceLow, g_Digits) + "-" +
                DoubleToString(g_OrderBlocks[ob].priceHigh, g_Digits) +
                " (" + DoubleToString(obDist2, 0) + "pts) str=" + DoubleToString(g_OrderBlocks[ob].strength, 2) + "\n";
      }
   }
   if(InpUseFVG && ArraySize(g_FVGs) > 0)
   {
      ctx += "\n=== FAIR VALUE GAPS ===\n";
      for(int fv = 0; fv < ArraySize(g_FVGs); fv++)
         ctx += "  " + (string)(g_FVGs[fv].isBullish ? "BULLISH" : "BEARISH") + " FVG: " +
                DoubleToString(g_FVGs[fv].low, g_Digits) + "-" + DoubleToString(g_FVGs[fv].high, g_Digits) + "\n";
   }

   // V4: VWAP
   if(InpUseVWAP && g_VWAP > 0)
   {
      ctx += "\n=== VWAP ===\n";
      ctx += "VWAP=" + DoubleToString(g_VWAP, g_Digits) +
             " Upper=" + DoubleToString(g_VWAPUpper, g_Digits) +
             " Lower=" + DoubleToString(g_VWAPLower, g_Digits) +
             " Price " + (bid > g_VWAP ? "ABOVE" : "BELOW") + " VWAP\n";
   }

   // V4: Previous Day & Asian Range
   if(InpUsePrevDayHL && g_PrevDayHigh > 0)
   {
      ctx += "\n=== PREV DAY & SESSION ===\n";
      ctx += "Prev Day: High=" + DoubleToString(g_PrevDayHigh, g_Digits) +
             " Low=" + DoubleToString(g_PrevDayLow, g_Digits) +
             " Close=" + DoubleToString(g_PrevDayClose, g_Digits) + "\n";
   }
   if(InpUseAsianRange && g_AsianRangeSet)
   {
      ctx += "Asian Range: High=" + DoubleToString(g_AsianHigh, g_Digits) +
             " Low=" + DoubleToString(g_AsianLow, g_Digits) +
             " Width=" + DoubleToString((g_AsianHigh - g_AsianLow) / g_Point, 0) + "pts" +
             " Price " + (bid > g_AsianHigh ? "ABOVE" : (bid < g_AsianLow ? "BELOW" : "INSIDE")) + "\n";
   }
   if(g_NearLondonFix) ctx += "*** NEAR LONDON FIX TIME - Expect increased gold volatility ***\n";

   // Confluence
   ctx += "\n=== CONFLUENCE SCORING ===\n";
   ctx += "Signal: " + g_Confluence.signal + " Score: " + IntegerToString(g_Confluence.score) + "/10\n";
   ctx += "Buy points: " + IntegerToString(g_Confluence.buyPoints) + " | Sell points: " + IntegerToString(g_Confluence.sellPoints) + "\n";
   ctx += "Reasons:\n";
   for(int i = 0; i < ArraySize(g_Confluence.reasons); i++)
      ctx += "  - " + g_Confluence.reasons[i] + "\n";

   // Last 30 M1 candles
   ctx += "\n=== LAST 30 M1 CANDLES ===\n";
   double m1O[], m1H[], m1L[], m1C[]; long m1V[];
   ArraySetAsSeries(m1O,true); ArraySetAsSeries(m1H,true);
   ArraySetAsSeries(m1L,true); ArraySetAsSeries(m1C,true); ArraySetAsSeries(m1V,true);
   if(CopyOpen(_Symbol,PERIOD_M1,0,30,m1O)>=30 && CopyHigh(_Symbol,PERIOD_M1,0,30,m1H)>=30 &&
      CopyLow(_Symbol,PERIOD_M1,0,30,m1L)>=30 && CopyClose(_Symbol,PERIOD_M1,0,30,m1C)>=30 &&
      CopyTickVolume(_Symbol,PERIOD_M1,0,30,m1V)>=30)
   {
      for(int i = 0; i < 30; i++)
      {
         bool bull = (m1C[i]>m1O[i]);
         ctx += IntegerToString(i+1) + ": " + (bull?"↑":"↓") +
                " O=" + DoubleToString(m1O[i],g_Digits) + " H=" + DoubleToString(m1H[i],g_Digits) +
                " L=" + DoubleToString(m1L[i],g_Digits) + " C=" + DoubleToString(m1C[i],g_Digits) +
                " V=" + IntegerToString((int)m1V[i]) + "\n";
      }
   }

   // Open positions
   int posCount = CountPositions();
   if(posCount > 0)
   {
      ctx += "\n=== OPEN POSITIONS ===\n";
      for(int i = PositionsTotal()-1; i >= 0; i--)
      {
         ulong tk = PositionGetTicket(i);
         if(tk > 0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==314159)
         {
            double entry = PositionGetDouble(POSITION_PRICE_OPEN);
            double sl = PositionGetDouble(POSITION_SL);
            double tp = PositionGetDouble(POSITION_TP);
            double profit = PositionGetDouble(POSITION_PROFIT);
            ENUM_POSITION_TYPE pt = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            double cp = (pt==POSITION_TYPE_BUY) ? bid : ask;
            double pPct = ((pt==POSITION_TYPE_BUY) ? (cp-entry) : (entry-cp)) / entry * 100;
            ctx += "#" + IntegerToString(tk) + " " + (pt==POSITION_TYPE_BUY?"LONG":"SHORT") +
                   " Entry=" + DoubleToString(entry,g_Digits) + " SL=" + DoubleToString(sl,g_Digits) +
                   " TP=" + DoubleToString(tp,g_Digits) + " P/L=" + DoubleToString(pPct,3) +
                   "% ($" + DoubleToString(profit,2) + ")\n";
         }
      }
   }

   // Instructions
   ctx += "\n=== DECISION RULES ===\n";
   ctx += "Confluence minimum: " + IntegerToString(InpMinConfluence) + "/15 (V4: 21-factor engine)\n";
   ctx += "Max positions: " + IntegerToString(InpMaxPositions) + " (current: " + IntegerToString(posCount) + ")\n";
   if(IsDailyDrawdownExceeded()) ctx += "*** DAILY DRAWDOWN LIMIT HIT - NO NEW TRADES! ***\n";
   if(!IsActiveSession()) ctx += "Session: Off-peak hours - still trade but note lower liquidity.\n";
   if(IsVolatilitySpike()) ctx += "*** VOLATILITY SPIKE - widen SL consideration ***\n";
   if(IsHighImpactNewsPaused()) ctx += "*** HIGH-IMPACT NEWS NEARBY - Consider WAIT ***\n";

   if(wr < 30 && g_TotalTrades > 25) ctx += "NOTE: Win rate below 30% after 25+ trades - tighten entries.\n";

   // Inject news context for AI
   if(InpNewsAffectsAI)
      ctx += BuildNewsContext();

   ctx += "\nIMPORTANT: You MUST commit to BUY or SELL in most situations. Only say WAIT if signals genuinely conflict.\n";
   ctx += "Gold always has a directional bias — find it. A 55% edge is enough to act. Do NOT default to WAIT.\n";
   ctx += "If confluence score >= 3, you MUST pick BUY or SELL with confidence >= 0.55.\n";
   ctx += "Respond EXACTLY: SIGNAL|CONFIDENCE|REASONING|SUMMARY\n";
   ctx += "SIGNAL: BUY or SELL (use WAIT only if signals are 50/50 split)\n";
   ctx += "CONFIDENCE: 0.50-1.00 (0.55+ means act on it)\n";
   ctx += "REASONING: Brief technical explanation (max 50 words)\n";
   ctx += "SUMMARY: Analysis (max 100 words)\n";

   return ctx;
}

//+------------------------------------------------------------------+
//| CALL CLAUDE AI                                                    |
//+------------------------------------------------------------------+
string CallClaudeAI(string marketData)
{
   if(StringLen(InpClaudeAPIKey) < 20)
   {
      g_AIStatus = "SIMULATED";
      g_AIIsActive = false;
      return SimulatedAI();
   }

   string escaped = EscapeJSON(marketData);
   string json = "{\"model\":\"" + InpClaudeModel + "\",\"max_tokens\":2000,\"messages\":[{\"role\":\"user\",\"content\":\"" + escaped + "\"}]}";

   string headers = "Content-Type: application/json\r\nx-api-key: " + InpClaudeAPIKey + "\r\nanthropic-version: 2023-06-01\r\n";
   char postData[], result[];
   string resultHeaders;
   int jsonLen = StringLen(json);
   ArrayResize(postData, jsonLen);
   StringToCharArray(json, postData, 0, jsonLen);

   int res = WebRequest("POST", "https://api.anthropic.com/v1/messages", headers, 15000, postData, result, resultHeaders);

   if(res == -1)
   {
      int err = GetLastError();
      if(err == 4060)
         Print("AI ERROR: Add https://api.anthropic.com to Tools > Options > Expert Advisors > Allow WebRequest");
      g_AIStatus = "ERROR";
      g_AIIsActive = false;
      return SimulatedAI();
   }

   if(res != 200)
   {
      Print("AI ERROR: HTTP ", res, " - ", CharArrayToString(result));
      g_AIStatus = "ERROR";
      g_AIIsActive = false;
      return SimulatedAI();
   }

   string jsonResp = CharArrayToString(result);
   string aiMsg = ParseClaudeJSON(jsonResp);
   if(StringLen(aiMsg) > 0)
   {
      g_AIStatus = "ACTIVE";
      g_AIIsActive = true;
      return aiMsg;
   }

   g_AIStatus = "ERROR";
   g_AIIsActive = false;
   return SimulatedAI();
}

string ParseClaudeJSON(string jsonResponse)
{
   int cs = StringFind(jsonResponse, "\"text\":\"");
   if(cs < 0) return "";
   cs += StringLen("\"text\":\"");

   int ce = cs;
   while(ce < StringLen(jsonResponse) - 1)
   {
      int nq = StringFind(jsonResponse, "\"", ce);
      if(nq < 0) break;
      bool esc = false;
      if(nq > 0)
      {
         int bp = nq - 1; int bc = 0;
         while(bp >= cs && StringGetCharacter(jsonResponse, bp) == '\\') { bc++; bp--; }
         esc = (bc % 2 == 1);
      }
      if(!esc) { ce = nq; break; }
      ce = nq + 1;
   }

   string content = StringSubstr(jsonResponse, cs, ce - cs);
   StringReplace(content, "\\\\", "\x01");
   StringReplace(content, "\\\"", "\"");
   StringReplace(content, "\\n", "\n");
   StringReplace(content, "\\r", "\r");
   StringReplace(content, "\\t", "\t");
   StringReplace(content, "\x01", "\\");

   string parts[];
   if(StringSplit(content, '|', parts) >= 4) return content;

   // Fallback extraction
   string signal = "WAIT"; double conf = 0.5;
   if(StringFind(content, "BUY") >= 0 || StringFind(content, "LONG") >= 0) { signal = "BUY"; conf = 0.7; }
   else if(StringFind(content, "SELL") >= 0 || StringFind(content, "SHORT") >= 0) { signal = "SELL"; conf = 0.7; }
   return signal + "|" + DoubleToString(conf, 2) + "|AI analysis|" + StringSubstr(content, 0, 200);
}

string SimulatedAI()
{
   MTFData m1 = g_MTF[0];
   // Extreme RSI — high confidence
   if(m1.rsi < 30 && g_Confluence.buyPoints >= 2)
      return "BUY|0.85|RSI oversold + confluence buy|Simulated: strong oversold buy";
   if(m1.rsi > 70 && g_Confluence.sellPoints >= 2)
      return "SELL|0.85|RSI overbought + confluence sell|Simulated: strong overbought sell";
   // Confluence signal — follow it
   if(g_Confluence.signal == "BUY" && g_Confluence.score >= InpMinConfluence)
      return "BUY|0.70|Confluence buy score " + IntegerToString(g_Confluence.score) + "|Simulated: confluence buy";
   if(g_Confluence.signal == "SELL" && g_Confluence.score >= InpMinConfluence)
      return "SELL|0.70|Confluence sell score " + IntegerToString(g_Confluence.score) + "|Simulated: confluence sell";
   // Leaning signal — still act on it
   if(g_Confluence.buyPoints > g_Confluence.sellPoints && g_Confluence.buyPoints >= 2)
      return "BUY|0.58|Leaning bullish " + IntegerToString(g_Confluence.buyPoints) + "B vs " + IntegerToString(g_Confluence.sellPoints) + "S|Simulated: lean buy";
   if(g_Confluence.sellPoints > g_Confluence.buyPoints && g_Confluence.sellPoints >= 2)
      return "SELL|0.58|Leaning bearish " + IntegerToString(g_Confluence.sellPoints) + "S vs " + IntegerToString(g_Confluence.buyPoints) + "B|Simulated: lean sell";
   // MA bias fallback
   if(m1.maFast > m1.maMid && m1.maMid > m1.maSlow)
      return "BUY|0.55|MA alignment bullish|Simulated: MA bullish bias";
   if(m1.maFast < m1.maMid && m1.maMid < m1.maSlow)
      return "SELL|0.55|MA alignment bearish|Simulated: MA bearish bias";
   return "WAIT|0.45|Truly flat market|Simulated: no directional bias";
}

void ParseAIResponse(string response)
{
   string parts[];
   int count = StringSplit(response, '|', parts);
   if(count >= 4)
   {
      g_AISignal = parts[0]; StringTrimLeft(g_AISignal); StringTrimRight(g_AISignal);
      g_AIConfidence = StringToDouble(parts[1]);
      g_AIReasoning = parts[2]; StringTrimLeft(g_AIReasoning); StringTrimRight(g_AIReasoning);
      g_AISummary = parts[3];
      if(g_AISignal != "BUY" && g_AISignal != "SELL" && g_AISignal != "WAIT") g_AISignal = "WAIT";
      g_AIConfidence = MathMax(0.0, MathMin(1.0, g_AIConfidence));
   }
   else
   {
      g_AISignal = "WAIT"; g_AIConfidence = 0; g_AIReasoning = "Invalid response";
   }
}

string EscapeJSON(string text)
{
   string r = text;
   StringReplace(r, "\\", "\\\\");
   StringReplace(r, "\"", "\\\"");
   StringReplace(r, "\n", "\\n");
   StringReplace(r, "\r", "\\r");
   StringReplace(r, "\t", "\\t");
   StringReplace(r, "\x00", "");
   return r;
}

//+------------------------------------------------------------------+
//| TRADE EXECUTION                                                   |
//+------------------------------------------------------------------+
void CheckTrades()
{
   datetime curBar = iTime(_Symbol, PERIOD_M1, 0);
   if(curBar == g_LastTradeBar) return;
   g_LastTradeBar = curBar;

   if(CountPositions() >= InpMaxPositions) return;
   if(IsDailyDrawdownExceeded()) return;
   if(IsVolatilitySpike()) return;

   // V4: Spread filter
   if(InpMaxSpreadPts > 0)
   {
      double curSpread = (SymbolInfoDouble(_Symbol, SYMBOL_ASK) - SymbolInfoDouble(_Symbol, SYMBOL_BID)) / g_Point;
      if(curSpread > InpMaxSpreadPts) return;
   }

   // V4: Max daily trades
   MqlDateTime dtTrade;
   TimeToStruct(TimeCurrent(), dtTrade);
   datetime todayTrade = TimeCurrent() - dtTrade.hour*3600 - dtTrade.min*60 - dtTrade.sec;
   if(todayTrade != g_DailyTradeResetDay) { g_DailyTradeResetDay = todayTrade; g_DailyTradeCount = 0; }
   if(InpMaxDailyTrades > 0 && g_DailyTradeCount >= InpMaxDailyTrades) return;

   // V4: Consecutive loss cooldown
   if(g_ConsecutiveLosses >= InpMaxConsecLoss && TimeCurrent() < g_CooldownUntil)
   {
      static datetime lastCoolLog = 0;
      if(TimeCurrent() - lastCoolLog > 60)
      { Print("COOLDOWN: ", g_ConsecutiveLosses, " consecutive losses, waiting..."); lastCoolLog = TimeCurrent(); }
      return;
   }
   if(TimeCurrent() >= g_CooldownUntil && g_ConsecutiveLosses >= InpMaxConsecLoss) g_ConsecutiveLosses = 0;

   if(IsHighImpactNewsPaused())
   {
      static datetime lastNewsPauseLog = 0;
      if(TimeCurrent() - lastNewsPauseLog > 60)
      {
         Print("NEWS PAUSE: High-impact event within ", InpNewsPauseMinutes, "min - no new trades");
         lastNewsPauseLog = TimeCurrent();
      }
      return;
   }

   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double atr = g_MTF[0].atr;
   if(atr <= 0)
   {
      // Fallback: use spread * 30 as minimum ATR estimate so SL is always calculated
      atr = (ask - bid) * 30;
      if(atr <= 0) return; // truly no data
   }

   // Decision: combine confluence + AI (V4: more aggressive)
   string finalSignal = "WAIT";
   double finalConf = 0;

   if(InpUseAI && g_AIIsActive)
   {
      // PATH 1: AI says BUY/SELL with enough confidence
      if(g_AISignal == "BUY" && g_AIConfidence >= InpAIConfidenceMin)
      {
         if(g_Confluence.signal == "BUY" && g_Confluence.score >= InpMinConfluence)
         { finalSignal = "BUY"; finalConf = g_AIConfidence; }
         else if(InpAIOverride && g_AIConfidence >= 0.55)
         { finalSignal = "BUY"; finalConf = g_AIConfidence * 0.9; }
         else if(g_Confluence.buyPoints >= 2)
         { finalSignal = "BUY"; finalConf = g_AIConfidence * 0.85; }
      }
      else if(g_AISignal == "SELL" && g_AIConfidence >= InpAIConfidenceMin)
      {
         if(g_Confluence.signal == "SELL" && g_Confluence.score >= InpMinConfluence)
         { finalSignal = "SELL"; finalConf = g_AIConfidence; }
         else if(InpAIOverride && g_AIConfidence >= 0.55)
         { finalSignal = "SELL"; finalConf = g_AIConfidence * 0.9; }
         else if(g_Confluence.sellPoints >= 2)
         { finalSignal = "SELL"; finalConf = g_AIConfidence * 0.85; }
      }
      // PATH 2: AI says WAIT but confluence is strong — trade anyway!
      if(finalSignal == "WAIT" && g_Confluence.score >= 4)
      {
         if(g_Confluence.signal == "BUY")
         { finalSignal = "BUY"; finalConf = MathMin(0.80, g_Confluence.score / 15.0 + 0.3); }
         else if(g_Confluence.signal == "SELL")
         { finalSignal = "SELL"; finalConf = MathMin(0.80, g_Confluence.score / 15.0 + 0.3); }
      }
   }
   else
   {
      // Confluence-only mode (no AI)
      if(g_Confluence.signal == "BUY" && g_Confluence.score >= InpMinConfluence)
      { finalSignal = "BUY"; finalConf = MathMin(0.90, g_Confluence.score / 15.0 + 0.3); }
      else if(g_Confluence.signal == "SELL" && g_Confluence.score >= InpMinConfluence)
      { finalSignal = "SELL"; finalConf = MathMin(0.90, g_Confluence.score / 15.0 + 0.3); }
   }

   // MTF alignment filter (when enabled)
   if(InpRequireMTFAlign && finalSignal != "WAIT")
   {
      int aligned = 0;
      ENUM_MARKET_BIAS reqBias = (finalSignal == "BUY") ? BIAS_BULLISH : BIAS_BEARISH;
      for(int i = 1; i < g_MTFCount; i++)
         if(g_MTF[i].bias == reqBias) aligned++;
      if(aligned < 1) { finalSignal = "WAIT"; } // Need at least 1 higher TF aligned
   }

   // Session filter
   if(!IsActiveSession() && finalSignal != "WAIT") { finalSignal = "WAIT"; }

   // Execute
   if(finalSignal == "BUY")
   {
      double sl = ask - (atr * InpStopLossATR);
      double tp = ask + (atr * InpTP2_ATR);
      sl = NormalizeDouble(sl, g_Digits);
      tp = NormalizeDouble(tp, g_Digits);
      
      // SAFETY: Ensure SL is valid
      if(sl >= ask) { Print("ERROR: Invalid BUY SL >= Ask"); return; }
      if(tp <= ask) { Print("ERROR: Invalid BUY TP <= Ask"); return; }
      
      double slPts = (ask - sl) / g_Point;
      double lots = CalcLotSize(slPts);

      Print(">>> AUTO-TRADE BUY | Conf=", DoubleToString(finalConf,2),
            " Score=", g_Confluence.score, " Lots=", lots, 
            " SL=", sl, " TP=", tp, " ATR=", DoubleToString(atr, g_Digits));
      ExecuteOrder(ORDER_TYPE_BUY, ask, sl, tp, lots, "GPv4 BUY");
   }
   else if(finalSignal == "SELL")
   {
      double sl = bid + (atr * InpStopLossATR);
      double tp = bid - (atr * InpTP2_ATR);
      sl = NormalizeDouble(sl, g_Digits);
      tp = NormalizeDouble(tp, g_Digits);
      
      // SAFETY: Ensure SL is valid
      if(sl <= bid) { Print("ERROR: Invalid SELL SL <= Bid"); return; }
      if(tp >= bid) { Print("ERROR: Invalid SELL TP >= Bid"); return; }
      
      double slPts = (sl - bid) / g_Point;
      double lots = CalcLotSize(slPts);

      Print(">>> AUTO-TRADE SELL | Conf=", DoubleToString(finalConf,2),
            " Score=", g_Confluence.score, " Lots=", lots, 
            " SL=", sl, " TP=", tp, " ATR=", DoubleToString(atr, g_Digits));
      ExecuteOrder(ORDER_TYPE_SELL, bid, sl, tp, lots, "GPv4 SELL");
   }
}

void ExecuteOrder(ENUM_ORDER_TYPE type, double price, double sl, double tp, double lots, string comment)
{
   if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !MQLInfoInteger(MQL_TRADE_ALLOWED))
   { Print("ERROR: AutoTrading disabled"); return; }

   // Validate stops
   double minStop = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * g_Point;
   if(minStop > 0)
   {
      if(type == ORDER_TYPE_BUY)
      {
         if((price - sl) < minStop) sl = NormalizeDouble(price - minStop, g_Digits);
         if((tp - price) < minStop) tp = NormalizeDouble(price + minStop, g_Digits);
      }
      else
      {
         if((sl - price) < minStop) sl = NormalizeDouble(price + minStop, g_Digits);
         if((price - tp) < minStop) tp = NormalizeDouble(price - minStop, g_Digits);
      }
   }

   MqlTradeRequest req = {};
   MqlTradeResult res = {};
   req.action = TRADE_ACTION_DEAL;
   req.symbol = _Symbol;
   req.volume = lots;
   req.type   = type;
   req.price  = price;
   req.sl     = sl;
   req.tp     = tp;
   req.deviation = 10;
   req.magic  = 314159;
   req.comment = comment;

   // SAFETY: Ensure SL and TP are ALWAYS set
   if(sl <= 0 || tp <= 0)
   {
      Print("ERROR: Refusing to open trade without SL/TP! SL=", sl, " TP=", tp);
      return;
   }

   long fm = SymbolInfoInteger(_Symbol, SYMBOL_FILLING_MODE);
   if((fm & SYMBOL_FILLING_FOK)==SYMBOL_FILLING_FOK) req.type_filling = ORDER_FILLING_FOK;
   else if((fm & SYMBOL_FILLING_IOC)==SYMBOL_FILLING_IOC) req.type_filling = ORDER_FILLING_IOC;
   else req.type_filling = ORDER_FILLING_RETURN;

   if(OrderSend(req, res))
   {
      if(res.retcode == TRADE_RETCODE_DONE || res.retcode == TRADE_RETCODE_PLACED)
      {
         Print("ORDER OK! Ticket=", res.order, " Price=", res.price);
         g_TotalTrades++;
         g_DailyTradeCount++;
         g_ConsecutiveLosses = 0;
         g_LastTicket = res.order;

         // Track for trailing
         int sz = ArraySize(g_TrackedTickets);
         ArrayResize(g_TrackedTickets, sz+1);
         ArrayResize(g_MaxProfitPrice, sz+1);
         ArrayResize(g_TP1Hit, sz+1);
         g_TrackedTickets[sz] = res.order;
         g_MaxProfitPrice[sz] = price;
         g_TP1Hit[sz] = false;
      }
      else Print("ORDER PARTIAL: rc=", res.retcode);
   }
   else
   {
      Print("ORDER FAILED: rc=", res.retcode, " ", res.comment);
      // Retry with different filling
      if(res.retcode == TRADE_RETCODE_REJECT || StringFind(res.comment, "filling") >= 0)
      {
         if(req.type_filling == ORDER_FILLING_FOK) req.type_filling = ORDER_FILLING_IOC;
         else req.type_filling = ORDER_FILLING_RETURN;
         if(OrderSend(req, res) && (res.retcode == TRADE_RETCODE_DONE || res.retcode == TRADE_RETCODE_PLACED))
         {
            Print("RETRY OK! Ticket=", res.order);
            g_TotalTrades++;
            g_LastTicket = res.order;
         }
      }
   }
}

//+------------------------------------------------------------------+
//| SMART TRAILING STOP + PARTIAL CLOSE                              |
//+------------------------------------------------------------------+
void ManageTrailing()
{
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double minStop = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * g_Point;
   if(minStop <= 0) minStop = 10 * g_Point;

   for(int i = PositionsTotal()-1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol || PositionGetInteger(POSITION_MAGIC) != 314159) continue;

      ENUM_POSITION_TYPE pType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      double entry = PositionGetDouble(POSITION_PRICE_OPEN);
      double curSL = PositionGetDouble(POSITION_SL);
      double curTP = PositionGetDouble(POSITION_TP);
      double curPrice = (pType == POSITION_TYPE_BUY) ? bid : ask;
      double volume = PositionGetDouble(POSITION_VOLUME);

      // Get ATR for this position's calculations
      double atr = g_MTF[0].atr;
      if(atr <= 0) continue;

      // Find tracker
      int idx = -1;
      for(int j = 0; j < ArraySize(g_TrackedTickets); j++)
         if(g_TrackedTickets[j] == ticket) { idx = j; break; }
      if(idx < 0) continue;

      double profitPts = 0;
      if(pType == POSITION_TYPE_BUY)
      {
         profitPts = (curPrice - entry);
         if(curPrice > g_MaxProfitPrice[idx]) g_MaxProfitPrice[idx] = curPrice;

         // Breakeven move
         if(profitPts >= atr * InpBreakevenATR && curSL < entry)
         {
            double newSL = entry + g_Point;
            newSL = NormalizeDouble(newSL, g_Digits);
            if(newSL < curPrice - minStop)
            {
               g_Trade.PositionModify(ticket, newSL, curTP);
               Print("BE: #", ticket, " SL->", newSL);
            }
         }

         // Trailing once past breakeven
         if(curSL >= entry)
         {
            double trailSL = g_MaxProfitPrice[idx] - (atr * InpTrailATR);
            trailSL = NormalizeDouble(trailSL, g_Digits);
            if(trailSL > curSL && trailSL < curPrice - minStop)
            {
               g_Trade.PositionModify(ticket, trailSL, curTP);
            }
         }

         // Partial close at TP1
         if(!g_TP1Hit[idx] && profitPts >= atr * InpTP1_ATR && InpPartialClosePct > 0)
         {
            double closeLots = NormalizeDouble(volume * (InpPartialClosePct / 100.0), 2);
            double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
            if(closeLots >= minLot && (volume - closeLots) >= minLot)
            {
               if(g_Trade.PositionClosePartial(ticket, closeLots))
               {
                  Print("PARTIAL CLOSE: #", ticket, " closed ", closeLots, " lots at TP1");
                  g_TP1Hit[idx] = true;
               }
            }
            else g_TP1Hit[idx] = true; // lot too small, skip
         }
      }
      else // SELL
      {
         profitPts = (entry - curPrice);
         if(curPrice < g_MaxProfitPrice[idx]) g_MaxProfitPrice[idx] = curPrice;

         // Breakeven
         if(profitPts >= atr * InpBreakevenATR && curSL > entry)
         {
            double newSL = entry - g_Point;
            newSL = NormalizeDouble(newSL, g_Digits);
            if(newSL > curPrice + minStop)
            {
               g_Trade.PositionModify(ticket, newSL, curTP);
               Print("BE: #", ticket, " SL->", newSL);
            }
         }

         // Trailing
         if(curSL <= entry && curSL > 0)
         {
            double trailSL = g_MaxProfitPrice[idx] + (atr * InpTrailATR);
            trailSL = NormalizeDouble(trailSL, g_Digits);
            if(trailSL < curSL && trailSL > curPrice + minStop)
            {
               g_Trade.PositionModify(ticket, trailSL, curTP);
            }
         }

         // Partial close at TP1
         if(!g_TP1Hit[idx] && profitPts >= atr * InpTP1_ATR && InpPartialClosePct > 0)
         {
            double closeLots = NormalizeDouble(volume * (InpPartialClosePct / 100.0), 2);
            double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
            if(closeLots >= minLot && (volume - closeLots) >= minLot)
            {
               if(g_Trade.PositionClosePartial(ticket, closeLots))
               {
                  Print("PARTIAL CLOSE: #", ticket, " closed ", closeLots, " lots at TP1");
                  g_TP1Hit[idx] = true;
               }
            }
            else g_TP1Hit[idx] = true;
         }
      }
   }

   // Cleanup stale trackers
   for(int k = ArraySize(g_TrackedTickets)-1; k >= 0; k--)
   {
      bool exists = false;
      for(int m = PositionsTotal()-1; m >= 0; m--)
         if(PositionGetTicket(m) == g_TrackedTickets[k]) { exists = true; break; }
      if(!exists)
      {
         for(int n = k; n < ArraySize(g_TrackedTickets)-1; n++)
         {
            g_TrackedTickets[n] = g_TrackedTickets[n+1];
            g_MaxProfitPrice[n] = g_MaxProfitPrice[n+1];
            g_TP1Hit[n] = g_TP1Hit[n+1];
         }
         ArrayResize(g_TrackedTickets, ArraySize(g_TrackedTickets)-1);
         ArrayResize(g_MaxProfitPrice, ArraySize(g_MaxProfitPrice)-1);
         ArrayResize(g_TP1Hit, ArraySize(g_TP1Hit)-1);
      }
   }
}

//+------------------------------------------------------------------+
//| MANAGE / CLOSE POSITIONS (AI + Confluence driven)                |
//+------------------------------------------------------------------+
void ManagePositions()
{
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);

   for(int i = PositionsTotal()-1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(ticket <= 0) continue;
      if(PositionGetString(POSITION_SYMBOL) != _Symbol || PositionGetInteger(POSITION_MAGIC) != 314159) continue;

      ENUM_POSITION_TYPE pType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      double profit = PositionGetDouble(POSITION_PROFIT);
      double entry = PositionGetDouble(POSITION_PRICE_OPEN);
      double curPrice = (pType == POSITION_TYPE_BUY) ? bid : ask;
      double pPct = ((pType==POSITION_TYPE_BUY) ? (curPrice-entry) : (entry-curPrice)) / entry * 100;

      bool shouldClose = false;
      string reason = "";

      // AI opposite signal with high confidence
      if(InpUseAI && g_AIIsActive && g_AIConfidence >= 0.75)
      {
         if(pType == POSITION_TYPE_BUY && g_AISignal == "SELL")
         { shouldClose = true; reason = "AI reversal SELL"; }
         else if(pType == POSITION_TYPE_SELL && g_AISignal == "BUY")
         { shouldClose = true; reason = "AI reversal BUY"; }
      }

      // Confluence flipped
      if(pType == POSITION_TYPE_BUY && g_Confluence.signal == "SELL" && g_Confluence.score >= 7 && pPct > 0)
      { shouldClose = true; reason = "Confluence flipped SELL"; }
      else if(pType == POSITION_TYPE_SELL && g_Confluence.signal == "BUY" && g_Confluence.score >= 7 && pPct > 0)
      { shouldClose = true; reason = "Confluence flipped BUY"; }

      if(shouldClose)
      {
         Print("CLOSING #", ticket, " reason: ", reason, " P/L=", DoubleToString(pPct,3), "%");
         if(g_Trade.PositionClose(ticket))
         {
            if(profit > 0) { g_Wins++; g_ConsecutiveLosses = 0; }
            else {
               g_Losses++;
               g_ConsecutiveLosses++;
               if(g_ConsecutiveLosses >= InpMaxConsecLoss)
                  g_CooldownUntil = TimeCurrent() + InpCooldownMinutes * 60;
            }
            g_TotalProfit += profit;
         }
      }
   }
}

//+------------------------------------------------------------------+
//| COUNT POSITIONS                                                   |
//+------------------------------------------------------------------+
int CountPositions()
{
   int c = 0;
   for(int i = PositionsTotal()-1; i >= 0; i--)
   {
      ulong tk = PositionGetTicket(i);
      if(tk > 0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==314159) c++;
   }
   return c;
}

//+------------------------------------------------------------------+
//| TEST MODE                                                         |
//+------------------------------------------------------------------+
void RunTestMode()
{
   if(g_TestDone) return;

   if(g_TestStep == 0)
   {
      if(!TerminalInfoInteger(TERMINAL_CONNECTED) || !TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !MQLInfoInteger(MQL_TRADE_ALLOWED))
      { Print("TEST: Trading not available"); g_TestDone = true; return; }
      Print("=== TEST MODE: Starting 3-step test ===");
      g_TestStep = 1;
   }

   static int tickCount = 0;
   tickCount++;
   if(tickCount < 3) return;

   if(g_TestStep == 1) // Place
   {
      double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
      double atr = g_MTF[0].atr > 0 ? g_MTF[0].atr : (SymbolInfoDouble(_Symbol, SYMBOL_ASK) - SymbolInfoDouble(_Symbol, SYMBOL_BID)) * 10;
      double sl = NormalizeDouble(ask - atr*2, g_Digits);
      ExecuteOrder(ORDER_TYPE_BUY, ask, sl, 0, 0.01, "GPv4 TEST");
      g_TestStep = 2; tickCount = 0; g_TestLastAction = TimeCurrent();
   }
   else if(g_TestStep == 2) // Modify
   {
      for(int i = PositionsTotal()-1; i >= 0; i--)
      {
         ulong tk = PositionGetTicket(i);
         if(tk > 0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==314159)
         {
            double entry = PositionGetDouble(POSITION_PRICE_OPEN);
            double newSL = NormalizeDouble(entry, g_Digits);
            double newTP = NormalizeDouble(entry + 100*g_Point, g_Digits);
            double minStop = SymbolInfoInteger(_Symbol, SYMBOL_TRADE_STOPS_LEVEL) * g_Point;
            if(minStop > 0 && (SymbolInfoDouble(_Symbol, SYMBOL_BID) - newSL) < minStop)
               newSL = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID) - minStop - g_Point, g_Digits);
            g_Trade.PositionModify(tk, newSL, newTP);
            Print("TEST: Modified SL/TP on #", tk);
            g_TestStep = 3; tickCount = 0;
            return;
         }
      }
      if(TimeCurrent() - g_TestLastAction > 5) { g_TestStep = 3; tickCount = 0; }
   }
   else if(g_TestStep == 3) // Close
   {
      for(int i = PositionsTotal()-1; i >= 0; i--)
      {
         ulong tk = PositionGetTicket(i);
         if(tk > 0 && PositionGetString(POSITION_SYMBOL)==_Symbol && PositionGetInteger(POSITION_MAGIC)==314159)
         {
            g_Trade.PositionClose(tk);
            Print("TEST: Closed #", tk);
            break;
         }
      }
      Print("=== TEST COMPLETE ===");
      g_TestDone = true;
   }
}

//+------------------------------------------------------------------+
//| DASHBOARD UI                                                      |
//+------------------------------------------------------------------+
void DrawDashboard()
{
   int x = InpXLeft, y = InpYTop, w = InpWidthLeft;

   CreateRect("BG", x, y, w, InpPanelHeight, ClrBackground);
   CreateLabel("Title", "GOLD PRO v4.0 By Salman RK", x+10, y+5, ClrHeader, true, 11);
   y += 28;

   // Section: Status
   CreateLabelPair("AIStatus",    "AI STATUS:",  x, y, w); y += 16;
   CreateLabelPair("Session",     "SESSION:",    x, y, w); y += 16;
   CreateLabelPair("Positions",   "POSITIONS:",  x, y, w); y += 16;
   CreateLabelPair("Velocity",    "VELOCITY:",   x, y, w); y += 20;

   // Section: Price
   CreateLabel("SecPrice", "── PRICE ──", x+10, y, ClrHeader, true, 9); y += 16;
   CreateLabelPair("Price",   "PRICE:",   x, y, w); y += 16;
   CreateLabelPair("Spread",  "SPREAD:",  x, y, w); y += 20;

   // Section: Indicators
   CreateLabel("SecInd", "── INDICATORS ──", x+10, y, ClrHeader, true, 9); y += 16;
   CreateLabelPair("RSI",     "RSI:",     x, y, w); y += 16;
   CreateLabelPair("MACD",    "MACD:",    x, y, w); y += 16;
   CreateLabelPair("Stoch",   "STOCH:",   x, y, w); y += 16;
   CreateLabelPair("ADX",     "ADX:",     x, y, w); y += 16;
   CreateLabelPair("BB",      "BB POS:",  x, y, w); y += 16;
   CreateLabelPair("Pattern", "PATTERN:", x, y, w); y += 20;

   // Section: MTF
   CreateLabel("SecMTF", "── MULTI-TF ──", x+10, y, ClrHeader, true, 9); y += 16;
   CreateLabelPair("MTF", "M1/M5/M15/H1/H4:", x, y, w); y += 20;

   // Section: Confluence
   CreateLabel("SecConf", "── CONFLUENCE ──", x+10, y, ClrHeader, true, 9); y += 16;
   CreateLabelPair("Confluence", "SIGNAL:",  x, y, w); y += 16;
   CreateLabelPair("ConfDetail", "POINTS:", x, y, w); y += 20;

   // Section: AI
   CreateLabel("SecAI", "── AI ANALYSIS ──", x+10, y, ClrHeader, true, 9); y += 16;
   CreateLabelPair("AISignal", "AI SIGNAL:", x, y, w); y += 16;
   CreateLabelPair("AIConf",   "AI CONF:",  x, y, w); y += 16;
   CreateLabelPair("AIReason", "AI REASON:", x, y, w); y += 20;

   // Section: Performance
   CreateLabel("SecPerf", "── PERFORMANCE ──", x+10, y, ClrHeader, true, 9); y += 16;
   CreateLabelPair("DailyPL",  "DAILY P&L:", x, y, w); y += 16;
   CreateLabelPair("WinRate",  "WIN RATE:",  x, y, w); y += 20;

   // Section: News
   CreateLabel("SecNews", "── NEWS & CALENDAR ──", x+10, y, ClrHeader, true, 9); y += 16;
   CreateLabelPair("NewsSentiment", "SENTIMENT:",  x, y, w); y += 16;
   CreateLabelPair("NextNews",      "NEXT EVENT:", x, y, w); y += 16;
   CreateLabelPair("NewsPause",     "NEWS RISK:",  x, y, w); y += 20;

   // Section: V4 Advanced
   CreateLabel("SecV4", "── V4 ADVANCED ──", x+10, y, ClrHeader, true, 9); y += 16;
   CreateLabelPair("Ichimoku",  "ICHIMOKU:",   x, y, w); y += 16;
   CreateLabelPair("Diverg",    "DIVERGENCE:", x, y, w); y += 16;
   CreateLabelPair("VWAP",      "VWAP:",       x, y, w); y += 16;
   CreateLabelPair("SMC",       "SMC OB/FVG:", x, y, w); y += 16;
   CreateLabelPair("PrevDay",   "PREV DAY:",   x, y, w); y += 16;
   CreateLabelPair("AsianR",    "ASIAN RNG:",  x, y, w); y += 16;
}

void CreateRect(string name, int x, int y, int w, int h, color c)
{
   string obj = g_Prefix + name;
   if(ObjectFind(0, obj) < 0) ObjectCreate(0, obj, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSetInteger(0, obj, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, obj, OBJPROP_YDISTANCE, y);
   ObjectSetInteger(0, obj, OBJPROP_XSIZE, w);
   ObjectSetInteger(0, obj, OBJPROP_YSIZE, h);
   ObjectSetInteger(0, obj, OBJPROP_BGCOLOR, c);
   ObjectSetInteger(0, obj, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSetInteger(0, obj, OBJPROP_BACK, false);
   ObjectSetInteger(0, obj, OBJPROP_SELECTABLE, false);
}

void CreateLabel(string name, string text, int x, int y, color c, bool bold, int sz)
{
   string obj = g_Prefix + name;
   if(ObjectFind(0, obj) < 0) ObjectCreate(0, obj, OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, obj, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, obj, OBJPROP_YDISTANCE, y);
   ObjectSetString(0, obj, OBJPROP_TEXT, text);
   ObjectSetInteger(0, obj, OBJPROP_COLOR, c);
   ObjectSetInteger(0, obj, OBJPROP_FONTSIZE, sz);
   ObjectSetString(0, obj, OBJPROP_FONT, bold ? "Consolas Bold" : "Consolas");
   ObjectSetInteger(0, obj, OBJPROP_BACK, false);
   ObjectSetInteger(0, obj, OBJPROP_SELECTABLE, false);
}

void CreateLabelPair(string suffix, string label, int x, int y, int w)
{
   CreateLabel("L_"+suffix, label, x+10, y, ClrLabel, false, 9);
   CreateLabel("V_"+suffix, "--", x+110, y, ClrValue, true, 9);
}

void UpdateUI(string suffix, string value, color clr)
{
   string obj = g_Prefix + "V_" + suffix;
   if(ObjectFind(0, obj) >= 0)
   {
      ObjectSetString(0, obj, OBJPROP_TEXT, value);
      ObjectSetInteger(0, obj, OBJPROP_COLOR, clr);
   }
}
//+------------------------------------------------------------------+
