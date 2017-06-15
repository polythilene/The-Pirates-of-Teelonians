package  
{
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	
	public class State_PlanScreen extends CGameState
	{
		static private var m_instance:State_PlanScreen;
		private var m_PlanScreen:mcPlanScreen;
		private var m_delay:Timer;
		
		public function State_PlanScreen(lock:SingletonLock)
		{
			
		}
		
		override public function initialize(owner:DisplayObjectContainer):void 
		{
			super.initialize(owner);
			
			m_PlanScreen = new mcPlanScreen();
		}
		
		override public function enter():void 
		{
			super.enter();
			m_owner.addChild(m_PlanScreen);
			
			invalidateResource();
			
			registerButtons();
		}
		
		override public function exit():void 
		{
			unregisterButtons();
			m_owner.removeChild(m_PlanScreen);
			super.exit();
		}
		
		private function registerButtons():void
		{
			registerButton( m_PlanScreen.mcItemButton01 );
			registerButton( m_PlanScreen.mcItemButton02 );
			registerButton( m_PlanScreen.mcItemButton03 );
			registerButton( m_PlanScreen.mcItemButton04 );
			registerButton( m_PlanScreen.mcItemButton05 );
			registerButton( m_PlanScreen.mcItemButton06 );
			registerButton( m_PlanScreen.mcItemButton07 );
			registerButton( m_PlanScreen.mcItemButton08 );
			registerButton( m_PlanScreen.mcItemButton09 );
			registerButton( m_PlanScreen.mcItemButton10 );
			
			registerButton( m_PlanScreen.mcButtonToWar );
		}
		
		private function unregisterButtons():void
		{
			unregisterButton( m_PlanScreen.mcItemButton01 );
			unregisterButton( m_PlanScreen.mcItemButton02 );
			unregisterButton( m_PlanScreen.mcItemButton03 );
			unregisterButton( m_PlanScreen.mcItemButton04 );
			unregisterButton( m_PlanScreen.mcItemButton05 );
			unregisterButton( m_PlanScreen.mcItemButton06 );
			unregisterButton( m_PlanScreen.mcItemButton07 );
			unregisterButton( m_PlanScreen.mcItemButton08 );
			unregisterButton( m_PlanScreen.mcItemButton09 );
			unregisterButton( m_PlanScreen.mcItemButton10 );
			
			unregisterButton( m_PlanScreen.mcButtonToWar );
		}
		
		private function registerButton(mc:MovieClip):void
		{
			mc.useHandCursor = mc.buttonMode = true;
			
			mc.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			mc.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			mc.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function unregisterButton(mc:MovieClip):void
		{
			mc.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mc.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			mc.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			mc.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			
			switch( mc )
			{
				case m_PlanScreen.mcItemButton01:
						if ( GlobalVars.TOTAL_COIN >= GlobalVars.PRICE_MATERIAL_POISON )
						{
							GlobalVars.STOCK_MATERIAL_POISON++;
							GlobalVars.TOTAL_COIN -= GlobalVars.PRICE_MATERIAL_POISON;
						}
						break;
				case m_PlanScreen.mcItemButton02:	
						if ( GlobalVars.TOTAL_COIN >= GlobalVars.PRICE_MATERIAL_KNOCKBACK )
						{
							GlobalVars.STOCK_MATERIAL_KNOCKBACK++;
							GlobalVars.TOTAL_COIN -= GlobalVars.PRICE_MATERIAL_KNOCKBACK;
						}
						break;
				case m_PlanScreen.mcItemButton03:		
						if ( GlobalVars.TOTAL_COIN >= GlobalVars.PRICE_MATERIAL_STUN )
						{
							GlobalVars.STOCK_MATERIAL_STUN++;
							GlobalVars.TOTAL_COIN -= GlobalVars.PRICE_MATERIAL_STUN;
						}
						break;
				case m_PlanScreen.mcItemButton04:		
						if ( GlobalVars.TOTAL_COIN >= GlobalVars.PRICE_MATERIAL_CONFUSE )
						{
							GlobalVars.STOCK_MATERIAL_CONFUSE++;
							GlobalVars.TOTAL_COIN -= GlobalVars.PRICE_MATERIAL_CONFUSE;
						}
						break;
				case m_PlanScreen.mcItemButton05:		
						if ( GlobalVars.TOTAL_COIN >= GlobalVars.PRICE_MATERIAL_POWER )
						{
							GlobalVars.STOCK_MATERIAL_POWER++;
							GlobalVars.TOTAL_COIN -= GlobalVars.PRICE_MATERIAL_POWER;
						}
						break;
				case m_PlanScreen.mcItemButton06:		
						if ( GlobalVars.TOTAL_COIN >= GlobalVars.PRICE_MATERIAL_FIRERATE )
						{
							GlobalVars.STOCK_MATERIAL_FIRERATE++;
							GlobalVars.TOTAL_COIN -= GlobalVars.PRICE_MATERIAL_FIRERATE;
						}
						break;
				case m_PlanScreen.mcItemButton07:	
						if ( GlobalVars.TOTAL_COIN >= GlobalVars.PRICE_MATERIAL_DOUBLE )
						{
							GlobalVars.STOCK_MATERIAL_DOUBLE++;
							GlobalVars.TOTAL_COIN -= GlobalVars.PRICE_MATERIAL_DOUBLE;
						}
						break;
				case m_PlanScreen.mcItemButton08:		
						if ( GlobalVars.TOTAL_COIN >= GlobalVars.PRICE_MATERIAL_EXPLODE )
						{
							GlobalVars.STOCK_MATERIAL_EXPLODE++;
							GlobalVars.TOTAL_COIN -= GlobalVars.PRICE_MATERIAL_EXPLODE;
						}
						break;
				case m_PlanScreen.mcItemButton09:		
						if ( GlobalVars.TOTAL_COIN >= GlobalVars.PRICE_MATERIAL_09 )
						{
							GlobalVars.STOCK_MATERIAL_09++;
							GlobalVars.TOTAL_COIN -= GlobalVars.PRICE_MATERIAL_09;
						}
						break;
				case m_PlanScreen.mcItemButton10:		
						if ( GlobalVars.TOTAL_COIN >= GlobalVars.PRICE_MATERIAL_10)
						{
							GlobalVars.STOCK_MATERIAL_10++;
							GlobalVars.TOTAL_COIN -= GlobalVars.PRICE_MATERIAL_10;
						}
						break;
				case m_PlanScreen.mcItemButton10:		
						GameStateManager.getInstance().setState( State_GameLoop.getInstance() );
						break;		
			}
			
			invalidateResource();
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
		}
		
		private function invalidateResource():void
		{
			m_PlanScreen.mcItemLabel01.htmlText = GlobalVars.STOCK_MATERIAL_POISON.toString();
			m_PlanScreen.mcItemLabel02.htmlText = GlobalVars.STOCK_MATERIAL_KNOCKBACK.toString();
			m_PlanScreen.mcItemLabel03.htmlText = GlobalVars.STOCK_MATERIAL_STUN.toString();
			m_PlanScreen.mcItemLabel04.htmlText = GlobalVars.STOCK_MATERIAL_CONFUSE.toString();
			m_PlanScreen.mcItemLabel05.htmlText = GlobalVars.STOCK_MATERIAL_POWER.toString();
			m_PlanScreen.mcItemLabel06.htmlText = GlobalVars.STOCK_MATERIAL_FIRERATE.toString();
			m_PlanScreen.mcItemLabel07.htmlText = GlobalVars.STOCK_MATERIAL_DOUBLE.toString();
			m_PlanScreen.mcItemLabel08.htmlText = GlobalVars.STOCK_MATERIAL_EXPLODE.toString();
			m_PlanScreen.mcItemLabel09.htmlText = GlobalVars.STOCK_MATERIAL_09.toString();
			m_PlanScreen.mcItemLabel10.htmlText = GlobalVars.STOCK_MATERIAL_10.toString();
			
			m_PlanScreen.mcItemLabelGold.htmlText = GlobalVars.TOTAL_COIN.toString();
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
		}
		
		/* ============================
		 * 			SINGLETON
		 * ============================
		*/
		
		static public function getInstance(): State_PlanScreen
		{
			if ( m_instance == null )
			{
				m_instance = new State_PlanScreen( new SingletonLock() );
			}
			return m_instance;
		}
	}

}
class SingletonLock{}