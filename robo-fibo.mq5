datetime lastWeeklyBarTime = 0;

#include <Trade/Trade.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/PositionInfo.mqh>

CTrade Trade;
CPositionInfo PositionInfo;
CSymbolInfo SymbolInfo;

input double risco = 500; // Risco em USD
input int magic = 5147; // Número Mágico do robo

input group "Tamanho dos canais";

input double tam25 = 0.25;
input double tam50 = 0.50;
input double tam75 = 0.75;



string ultimoTrade = 0;


int OnInit()
  {
//---


   TracarLinhas();
   Trade.SetExpertMagicNumber(magic);
   

   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   
// Obtém o tempo da última barra semanal fechada
   datetime currentWeeklyBarTime = iTime(_Symbol, PERIOD_W1, 1);
   
   // Se a barra semanal atual for diferente da última processada, traça novas linhas
   if(currentWeeklyBarTime != lastWeeklyBarTime)
     {
      lastWeeklyBarTime = currentWeeklyBarTime;
      TracarLinhas();
     }
     
   // Informações para compra e venda
   double minima = iLow(_Symbol,PERIOD_W1,1); // Mínima Barra Semanal
   double maxima = iHigh(_Symbol, PERIOD_W1,1); // Máxima barra Semanal
   double amplitude = maxima - minima;

   double tamNivel25 = amplitude * tam25;
   double tamNivel50 = amplitude * tam50;
   double tamNivel75 = amplitude * tam75;
   
   double preco25 = minima + tamNivel25;
   double preco50 = minima + tamNivel50;
   double preco75 = minima + tamNivel75;
   
   // Vela m15
   double aberturaVela = iOpen(_Symbol,PERIOD_M15, 1);
   double fechamentoVela = iClose(_Symbol, PERIOD_M15, 1);
   
   // Niveis de negociação, preço de 50% de cada canal
   double canal1 = (minima + preco25) * 0.5;
   double canal2 = (preco25 + preco50) * 0.5;
   double canal3 = (preco50 + preco75) * 0.5;
   double canal4 = (preco75 + maxima) * 0.5;
   
   bool semPosicao = SemPosicao();
   
   // Preço atual
   SymbolInfo.RefreshRates();
   
   double precoCompra = SymbolInfo.Bid();
   double precoVenda = SymbolInfo.Ask();
   
  // Lógica Ordens de compra
  
      if(aberturaVela < canal1 && fechamentoVela > canal1 && semPosicao)
      {
         double lote = CalculaLote(risco, minima, preco25);
         Trade.Buy(lote, _Symbol, 0, minima, preco25, NULL);
         ultimoTrade = "C1";
      }
      else if(aberturaVela < canal2 && fechamentoVela > canal2 && semPosicao)
      {
         double lote = CalculaLote(risco, preco25, preco50);
         Trade.Buy(lote, _Symbol, 0, preco25, preco50, NULL);
         ultimoTrade = "C2";
      }
       else if(aberturaVela < canal3 && fechamentoVela > canal3 && semPosicao)
      {
         double lote = CalculaLote(risco, preco50, preco75);
         Trade.Buy(lote, _Symbol, 0, preco50, preco75, NULL);
         ultimoTrade = "C3";
      }
      else if(aberturaVela < canal4 && fechamentoVela > canal4 && semPosicao)
      {
         double lote = CalculaLote(risco, preco75, maxima);
         Trade.Buy(lote, _Symbol, 0, preco75, maxima, NULL);
         ultimoTrade = "C4";
      }
   
   
   // Lógica Ordens de venda
  
      if(aberturaVela > canal1 && fechamentoVela < canal1 && semPosicao)
      {
         double lote = CalculaLote(risco, preco25, minima);
         Trade.Sell(lote, _Symbol, 0, preco25, minima, NULL);
         ultimoTrade = "V1";
      }
      else if(aberturaVela > canal2 && fechamentoVela < canal2 && semPosicao)
      {
         double lote = CalculaLote(risco, preco50, preco25);
         Trade.Sell(lote, _Symbol, 0, preco50, preco25, NULL);
         ultimoTrade = "V2";
      }
       else if(aberturaVela > canal3 && fechamentoVela < canal3 && semPosicao)
      {
         double lote = CalculaLote(risco, preco75, preco50);
         Trade.Sell(lote, _Symbol, 0, preco75, preco50, NULL);
         ultimoTrade = "V3";
      }
      else if(aberturaVela > canal4 && fechamentoVela < canal4 && semPosicao)
      {
         double lote = CalculaLote(risco, maxima, preco75);
         Trade.Sell(lote, _Symbol, 0, maxima, preco75, NULL);
         ultimoTrade = "V4";
      } 
  
   
  
  }
//+------------------------------------------------------------------+
//| Calcula o tamanho do lote com base no risco e no stop loss       |
//+------------------------------------------------------------------+
double CalculaLote(double risco, double precoEntrada, double precoSL)
{
   double pipValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double point = SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   double variacao = MathAbs(precoEntrada - precoSL) / point; // Valor do Stop em pontos / Valor do Ponto

   // Risco por pip
   double riscoPorPip = risco / variacao;

   // Calcular tamanho do lote
   double lote = riscoPorPip / pipValue;

   // Ajuste de lote para ser múltiplo de 0.01
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   double loteAjustado = NormalizeDouble(lote, 2);

   return loteAjustado;
}
//+------------------------------------------------------------------+
//| Função para desenhar linhas horizontais                          |
//+------------------------------------------------------------------+
void desenhaLinhaHorizontal(string nome, datetime dt, double price, color cor=clrBlueViolet)
{
   ObjectDelete(0, nome);
   ObjectCreate(0, nome, OBJ_HLINE, 0, dt, price);
   ObjectSetInteger(0, nome, OBJPROP_COLOR, cor);
}
//+------------------------------------------------------------------+
//| Função para traçar as linhas dos níveis                          |
//+------------------------------------------------------------------+
void TracarLinhas()
{
   double minima = iLow(_Symbol, PERIOD_W1, 1); // Mínima Barra Semanal
   double maxima = iHigh(_Symbol, PERIOD_W1, 1); // Máxima barra Semanal
   double amplitude = maxima - minima;

   double tamNivel25 = amplitude * tam25;
   double tamNivel50 = amplitude * tam50;
   double tamNivel75 = amplitude * tam75;

   double preco25 = minima + tamNivel25;
   double preco50 = minima + tamNivel50;
   double preco75 = minima + tamNivel75;

   desenhaLinhaHorizontal("Maxima 100%", lastWeeklyBarTime, maxima, clrBisque);
   desenhaLinhaHorizontal("Nivel 75%", lastWeeklyBarTime, preco75, clrBisque);
   desenhaLinhaHorizontal("Nivel 50%", lastWeeklyBarTime, preco50, clrBisque);
   desenhaLinhaHorizontal("Nível 25%", lastWeeklyBarTime, preco25, clrBisque);
   desenhaLinhaHorizontal("Nível 0%", lastWeeklyBarTime, minima, clrBisque);
}
//+------------------------------------------------------------------+
//| Função para verificar se há posições abertas                     |
//+------------------------------------------------------------------+
bool SemPosicao()
{
   for(int i = 0; i < PositionsTotal(); i++)
   {
      if(PositionInfo.SelectByIndex(i))
      {
         if(PositionGetInteger(POSITION_MAGIC) == magic && PositionGetString(POSITION_SYMBOL) == _Symbol)
            return false;
      }
   }
   return true;
}
