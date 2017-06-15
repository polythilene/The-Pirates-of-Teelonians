package  
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class Serializer
	{
		private const SERIALIZER_KEY:String = "_PIRATES_OF_TEELONIANS_1_";
		
		static private var m_instance:Serializer;
		
		public function Serializer(lock:SingletonLock) {}
		
		public function saveData():void
		{
			trace("Saving Data");
			var m_shared:SharedObject = SharedObject.getLocal(SERIALIZER_KEY);
			
			// unlock data
			m_shared.data.CURRENT_LEVEL 		= GlobalVars.CURRENT_LEVEL;
			m_shared.data.CURRENT_SUB_LEVEL		= GlobalVars.CURRENT_SUB_LEVEL;
			m_shared.data.TOTAL_COIN			= GlobalVars.TOTAL_COIN + NPCManager.getInstance().returnTrainCost();
			m_shared.data.RESEARCH_POINT		= GlobalVars.RESEARCH_POINT;
			m_shared.data.IS_VICTORY			= false;
			
			m_shared.data.UNLOCKED_LEEGOS		= GlobalVars.UNLOCKED_MG;
			m_shared.data.UNLOCKED_SEELDY		= GlobalVars.UNLOCKED_MED_CANNON;
			m_shared.data.UNLOCKED_AGEESUM		= GlobalVars.UNLOCKED_THROWER;
			m_shared.data.UNLOCKED_FEELA		= GlobalVars.UNLOCKED_MORTAR;	
			m_shared.data.UNLOCKED_ELONEE		= GlobalVars.UNLOCKED_ROCKET;
			m_shared.data.UNLOCKED_ENDROGEE		= GlobalVars.UNLOCKED_BEAR_TRAP;
			m_shared.data.UNLOCKED_UGEE			= GlobalVars.UNLOCKED_GLUE_TRAP;	
			m_shared.data.UNLOCKED_BARRICADE	= GlobalVars.UNLOCKED_HOLE_TRAP;
			m_shared.data.UNLOCKED_TRAP			= GlobalVars.UNLOCKED_TIMER_BOMB;
			m_shared.data.UNLOCKED_BALLISTA		= GlobalVars.UNLOCKED_TNT;
			
			m_shared.flush();
		}
		
		public function loadData():void
		{
			trace("Loading Data");
			var m_shared:SharedObject = SharedObject.getLocal(SERIALIZER_KEY);
			
			// unlock data
			GlobalVars.CURRENT_LEVEL 		= (m_shared.data.CURRENT_LEVEL) ? m_shared.data.CURRENT_LEVEL : 0;
			GlobalVars.CURRENT_SUB_LEVEL	= (m_shared.data.CURRENT_SUB_LEVEL) ? m_shared.data.CURRENT_SUB_LEVEL : 0;
			GlobalVars.IS_VICTORY			= false;
			
			if (!GlobalVars.HACK)
			{
				GlobalVars.TOTAL_COIN			= (m_shared.data.TOTAL_COIN) ? m_shared.data.TOTAL_COIN : 400;
				GlobalVars.RESEARCH_POINT		= (m_shared.data.RESEARCH_POINT) ? m_shared.data.RESEARCH_POINT : 0;
				
				GlobalVars.UNLOCKED_MG 		= (m_shared.data.UNLOCKED_LEEGOS) ? m_shared.data.UNLOCKED_LEEGOS : false;
				GlobalVars.UNLOCKED_MED_CANNON 		= (m_shared.data.UNLOCKED_SEELDY) ? m_shared.data.UNLOCKED_SEELDY : false;
				GlobalVars.UNLOCKED_THROWER 	= (m_shared.data.UNLOCKED_AGEESUM) ? m_shared.data.UNLOCKED_AGEESUM : false;
				GlobalVars.UNLOCKED_MORTAR 		= (m_shared.data.UNLOCKED_FEELA) ? m_shared.data.UNLOCKED_FEELA : false;
				GlobalVars.UNLOCKED_ROCKET 		= (m_shared.data.UNLOCKED_ELONEE) ? m_shared.data.UNLOCKED_ELONEE : false;
				GlobalVars.UNLOCKED_BEAR_TRAP 	= (m_shared.data.UNLOCKED_ENDROGEE) ? m_shared.data.UNLOCKED_ENDROGEE : false;
				GlobalVars.UNLOCKED_GLUE_TRAP 		= (m_shared.data.UNLOCKED_UGEE) ? m_shared.data.UNLOCKED_UGEE : false;
				GlobalVars.UNLOCKED_HOLE_TRAP 	= (m_shared.data.UNLOCKED_BARRICADE) ? m_shared.data.UNLOCKED_BARRICADE : false;
				GlobalVars.UNLOCKED_TIMER_BOMB 		= (m_shared.data.UNLOCKED_TRAP) ? m_shared.data.UNLOCKED_TRAP : false;
				GlobalVars.UNLOCKED_TNT 	= (m_shared.data.UNLOCKED_BALLISTA) ? m_shared.data.UNLOCKED_BALLISTA : false;
			}
			else
			{
				GlobalVars.TOTAL_COIN			= 999999;
				GlobalVars.RESEARCH_POINT		= 999;
				
				GlobalVars.UNLOCKED_MG 		= GlobalVars.HACK;
				GlobalVars.UNLOCKED_MED_CANNON 		= GlobalVars.HACK;
				GlobalVars.UNLOCKED_THROWER 	= GlobalVars.HACK;
				GlobalVars.UNLOCKED_MORTAR 		= GlobalVars.HACK;
				GlobalVars.UNLOCKED_ROCKET 		= GlobalVars.HACK;
				GlobalVars.UNLOCKED_BEAR_TRAP 	= GlobalVars.HACK;
				GlobalVars.UNLOCKED_GLUE_TRAP 		= GlobalVars.HACK;
				GlobalVars.UNLOCKED_HOLE_TRAP 	= GlobalVars.HACK;
				GlobalVars.UNLOCKED_TIMER_BOMB 		= GlobalVars.HACK;
				GlobalVars.UNLOCKED_TNT 	= GlobalVars.HACK;
			}
			
			trace("Coin:", GlobalVars.TOTAL_COIN);
		}
		
		public function dataExists():Boolean
		{
			var m_shared:SharedObject = SharedObject.getLocal(SERIALIZER_KEY);
			return (m_shared.data.CURRENT_LEVEL != null);
		}
		
		public function resetData():void
		{
			trace("Resetting Data");
			
			// unlock data
			GlobalVars.CURRENT_LEVEL 		= 0;
			GlobalVars.CURRENT_SUB_LEVEL	= 0;
			GlobalVars.TOTAL_COIN			= GlobalVars.HACK ? 999999 : 400;
			GlobalVars.RESEARCH_POINT		= GlobalVars.HACK ? 999 : 0;
			
			GlobalVars.UNLOCKED_MG 		= GlobalVars.HACK;
			GlobalVars.UNLOCKED_MED_CANNON 		= GlobalVars.HACK;
			GlobalVars.UNLOCKED_THROWER 	= GlobalVars.HACK;
			GlobalVars.UNLOCKED_MORTAR 		= GlobalVars.HACK;
			GlobalVars.UNLOCKED_ROCKET 		= GlobalVars.HACK;
			GlobalVars.UNLOCKED_BEAR_TRAP 	= GlobalVars.HACK;
			GlobalVars.UNLOCKED_GLUE_TRAP 		= GlobalVars.HACK;
			GlobalVars.UNLOCKED_HOLE_TRAP 	= GlobalVars.HACK;
			GlobalVars.UNLOCKED_TIMER_BOMB 		= GlobalVars.HACK;
			GlobalVars.UNLOCKED_TNT 	= GlobalVars.HACK;
			
			saveData();
		}
		
		static public function getInstance(): Serializer
		{
			if( m_instance == null ){
				m_instance = new Serializer( new SingletonLock() );
			}
			return m_instance;
		}
	}
}

class SingletonLock{}