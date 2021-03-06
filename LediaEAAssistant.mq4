//+------------------------------------------------------------------+
//|                                            LediaEA Assistant.mq4 |
//|                                                          LediaEA |
//|                                          https://www.lediaea.com |
//+------------------------------------------------------------------+
#property strict
#property description "LediaEA | Trade Assistant"
#property icon "Assest\icon.ico"
#property description "Make your trading easier & smarter ;)"
#property strict

#include "SettingsManager.mq4";
#include "Dialog.mqh";
#include "LediaPanel.mqh";
#include "ChartTools.mqh";
#include "GUI.mqh";
#include "OrdersTab.mqh"
#include "AssistantTab.mqh"
#include "magic.mq4";
#include "LediaEA.mq4";

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+
//--- main class instance
LediaEAAssistant *Ledia= new LediaEAAssistant();
//--- gui manager instance
LediaEAGUI *LediaGUI;
//--- tabs assistant instance
LediaEAAssistantTab *Tabs_Assistant;
//--- tabs orders instance
OrdersTab *Tabs_Orders;
// panel instance
LediaEAPanel LediaPanel;

bool LEDIAEA_ENABLED=true;
bool pause=true;
string LEDIA_NAME_PREFIX="LediaEAAssistant_";
int LEDIA_ID;
int LEDIA_WIDTH=380;
int LEDIA_HEIGHT=390;
int LEDIA_CLIENT_WIDTH=LEDIA_WIDTH-10;
int LEDIA_CLIENT_HEIGHT=LEDIA_HEIGHT-10;
//--- indents and gaps
int TABS_SPACE=40;
int HALF_TABS_SPACE=TABS_SPACE/2;
int TAB_WIDTH=20;
int VERTICAL_SPACE=10;
int VERTICAL_SPACE_SMALL=5;
int TOGGLE_BUTTON_HEIGHT=20;
int INPUT_HEIGHT=20;
int HEADER_HEIGHT=70;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   EventSetTimer(3);
   ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,1);
   pause=true;
//--- 
   LEDIA_ID = iMakeExpertId();
   
   //--- init
   return(Ledia.init());
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy dialog
   Ledia.Destroy(reason);
   ObjectDelete(0, "LediaMain");
  }
//+------------------------------------------------------------------+
//| Expert chart event function                                      |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // event ID  
                  const long& lparam,   // event parameter of the long type
                  const double& dparam, // event parameter of the double type
                  const string& sparam) // event parameter of the string type
  {
   Ledia.ChartEvent(id,lparam,dparam,sparam);
  }
  
 
//+------------------------------------------------------------------+
//|  Timer                                                           |
//+------------------------------------------------------------------+
void OnTimer()
  {
   pause=!pause;
  }
  
void OnTick()
  {
   MqlTick last_tick;
//---
   if(LediaGUI.active_tab==0 && !Tabs_Assistant.custom_price_selected && LEDIAEA_ENABLED && SymbolInfoTick(Symbol(),last_tick)){
      Tabs_Assistant.setCurrentPrice(Ask);
    }
//---
//---
   if(Ledia.IsNewBar()){
      LediaGUI.ShiftVisual();
   }
   
   if(LEDIAEA_ENABLED&&LediaGUI.active_tab==1 && Tabs_Orders.checkOrders()){
      Tabs_Orders.rebuild();
   }
  }