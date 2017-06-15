package
{
	import com.game.CBaseTeelos;
	/**
	 * ...
	 * @author Wiwitt
	 */
	public class GlobalVars
	{
		// DATA
		static public var TOTAL_COIN:int = 1000;
		static public var RESEARCH_POINT:int;
		
		// GAME VARS
		static public var CURRENT_LEVEL:int = 0;
		static public var CURRENT_SUB_LEVEL:int = 4;
		static public var IS_VICTORY:Boolean = true;
		static public var CUSTOM_CURSOR:Boolean = true;
		
		//static public var LEVEL:int = 1;					//	dari siput
		
		static public function getLevelGlobal():int
		{
			var ret:int;
			switch(CURRENT_LEVEL)
			{
				case 0:
						ret = CURRENT_SUB_LEVEL + 1; break;
				case 1:
						ret = CURRENT_SUB_LEVEL + 6; break;
				case 2:
						ret = CURRENT_SUB_LEVEL + 11; break;
				case 3:
						ret = CURRENT_SUB_LEVEL + 16; break;
				case 4:
						ret = CURRENT_SUB_LEVEL + 21; break;
			}
			
			return ret;
		}
		
		// STAT DATA (AFTER PLAY)
		static public var UNIT_BONUS:int;
		static public var KILL_SCORE:int;
		static public var RES_POINT_GAIN:int;
		
		
		static public const UNIT_SMALL_CANNON:int 			= 1;
		static public const UNIT_MG:int 					= 2;
		static public const UNIT_MED_CANNON:int 			= 3;
		static public const UNIT_THROWER:int 				= 4;
		static public const UNIT_MORTAR:int 				= 5;
		static public const UNIT_ROCKET:int 				= 6;
		static public const UNIT_BEAR_TRAP:int 				= 7;
		static public const UNIT_GLUE_TRAP:int 				= 8;
		static public const UNIT_HOLE_TRAP:int 				= 9;
		static public const UNIT_STONE_TRAP:int 			= 10;
		static public const UNIT_TIMER_BOMB:int 			= 11;
		static public const UNIT_TNT:int 					= 12;

		
		
		// UNIT LOCK STATUS
		static public var CHOSEN_UNIT:Array				= [UNIT_SMALL_CANNON, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		
		static public var UNLOCKED_SMALL_CANNON:Boolean = true;
		static public var UNLOCKED_MG:Boolean			= false;
		static public var UNLOCKED_MED_CANNON:Boolean	= false;
		static public var UNLOCKED_THROWER:Boolean		= false;
		static public var UNLOCKED_MORTAR:Boolean		= false;	
		static public var UNLOCKED_ROCKET:Boolean		= false;
		static public var UNLOCKED_BEAR_TRAP:Boolean	= false;
		static public var UNLOCKED_GLUE_TRAP:Boolean	= false;	
		static public var UNLOCKED_HOLE_TRAP:Boolean	= false;
		static public var UNLOCKED_STONE_TRAP:Boolean	= false;
		static public var UNLOCKED_TIMER_BOMB:Boolean	= false;
		static public var UNLOCKED_TNT:Boolean			= false;
		
		// MATERIAL STOCK
		static public var STOCK_MATERIAL_POISON:int 	= 0;
		static public var STOCK_MATERIAL_KNOCKBACK:int 	= 0;
		static public var STOCK_MATERIAL_STUN:int 		= 0;
		static public var STOCK_MATERIAL_CONFUSE:int 	= 0;
		static public var STOCK_MATERIAL_POWER:int 		= 0;
		static public var STOCK_MATERIAL_FIRERATE:int 	= 0;
		static public var STOCK_MATERIAL_DOUBLE:int 	= 0;
		static public var STOCK_MATERIAL_EXPLODE:int 	= 0;
		static public var STOCK_MATERIAL_09:int 		= 0;
		static public var STOCK_MATERIAL_10:int 		= 0;
		
		// MATERIAL PRICE
		static public var PRICE_MATERIAL_POISON:int 	= 1;
		static public var PRICE_MATERIAL_KNOCKBACK:int 	= 2;
		static public var PRICE_MATERIAL_STUN:int 		= 3;
		static public var PRICE_MATERIAL_CONFUSE:int 	= 4;
		static public var PRICE_MATERIAL_POWER:int 		= 5;
		static public var PRICE_MATERIAL_FIRERATE:int 	= 6;
		static public var PRICE_MATERIAL_DOUBLE:int 	= 7;
		static public var PRICE_MATERIAL_EXPLODE:int 	= 8;
		static public var PRICE_MATERIAL_09:int 		= 9;
		static public var PRICE_MATERIAL_10:int 		= 10;
		
		// ROLLBACK STATUS
		static public var LAST_RESEARCH_POINT:int 		= 0;
		static public var LAST_STATE_LEEGOS:Boolean		= false;
		static public var LAST_STATE_SEELDY:Boolean		= false;
		static public var LAST_STATE_AGEESUM:Boolean	= false;
		static public var LAST_STATE_FEELA:Boolean		= false;	
		static public var LAST_STATE_ELONEE:Boolean		= false;
		static public var LAST_STATE_ENDROGEE:Boolean	= false;
		static public var LAST_STATE_UGEE:Boolean		= false;	
		static public var LAST_STATE_BARRICADE:Boolean	= false;
		static public var LAST_STATE_TREASURY:Boolean	= false;
		static public var LAST_STATE_TRAP:Boolean		= false;
		static public var LAST_STATE_BALLISTA:Boolean	= false;
		
		static public var LAST_ASSET_STATE:int			= 0;
		static public var LAST_GOLD_STATE:int			= 0;
		// ....
		
		//GOLD TRIBUTE
		static public var LEVEL_DONATION:Array = [ [250, 500, 750 , 1000, 2000], 
												   [3000,4000,5000,6000,7000],
												   [8000, 12000, 12000, 12000,14000],
												   [14000, 15000, 15000, 20000, 20000],
												   [30000]];
												   
												   
		// BOSS FIGHT
		static public var BOSS_INSTANCE:CBaseTeelos = null;
		
		//MISC
		static public var HACK:Boolean = false;
		
		//MINIGAME
		static public var MINIGAME_SCORE:int = 0;
		
	}
}