package  
{
	import com.game.*;
	import com.game.ai.*;
	import com.game.fx.*;
	import com.greensock.easing.*;
	import com.greensock.TweenMax;
	import flash.display.*;
	import flash.display.StageQuality;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.*;
	import flash.utils.*;
	import math.*;
	
	
	
	import com.game.fx.CEffect_Heal;
	
	/**
	 * ...
	 * @author Wiwitt
	 */
	public class State_GameLoop extends CGameState
	{
		static private var m_instance:State_GameLoop;
		
		static private var MOUSE_TRAIL_ENABLE:Boolean = true;
		
		private const STATE_DEFAULT:int 		= 1000;
		private const STATE_PLACING:int 		= 2000;
		private const STATE_RETREAT:int 		= 3000;
		private const STATE_SWAP_PHASE_01:int 	= 4001;
		private const STATE_SWAP_PHASE_02:int 	= 4002;
		private const STATE_BARRAGE_TARGET:int	= 5000;		
		private const STATE_PAUSE:int			= 6000;
		
		private const STATE_MOVING_CAPTAIN:int 	= 88000;
		
		//
		public const STATE_RAGE_JACK:int		= 7000;
		//
		public const STATE_DYNAMITE_JACK:int	= 8000;
		public const STATE_GRENADE1_JACK:int	= 9000;
		public const STATE_GRENADE2_JACK:int	= 10000;
		public const STATE_LINESTRIKE_JACK:int = 11000;

		//
		public const STATE_RAGE_SMITH:int		= 12000;
		//
		public const STATE_POWERUP_SMITH:int 		= 13000;
		public const STATE_RATEUP_SMITH:int		= 14000;
		public const STATE_DOUBLESHOT_SMITH:int	= 15000;
		public const STATE_FIXIT_SMITH:int			= 16000;
		
		//
		public const STATE_RAGE_BAKUBA:int		= 17000;
		//
		public const STATE_IMMORTAL_BAKUBA:int 	= 18000;
		public const STATE_CLONE_BAKUBA:int		= 19000;
		public const STATE_CANNON_BAKUBA:int		= 20000;
		public const STATE_DROPARMY_BAKUBA:int		= 21000;
		
		private const WAVE_NORMAL:String 	= "normal";
		private const WAVE_BIG:String 		= "big";
		private const WAVE_FINAL:String 	= "final";
		private const WAVE_BOSSFIGHT:String = "bossfight";
		private const WAVE_COMPLETE:String 	= "complete";
		
		private const COST_SMALL_CANNON:int 		= 15;
		private const COST_LEEGOS:int 				= 220; //siput
		private const COST_SEELDY:int 				= 200;
		private const COST_AGEESUM:int 				= 600;
		private const COST_FEELA:int 				= 180;
		private const COST_ELONEE:int 				= 500;
		private const COST_ENDROGEE:int				= 350;
		private const COST_UGEE:int 				= 300;
		private const COST_BARRICADE:int 			= 750;
		private const COST_TREASURY:int 			= 150;
		private const COST_TRAP:int 				= 250; //siput
		private const COST_BALLISTA:int 			= 4500;
		
		private const COOLDOWN_SMALL_CANNON:int		= 3;
		
		
		private var COST_SELECTED:int;
		private var COOLDOWN_SELECTED:int;
		private var UNITCLASS_SELECTED:Class;
		
		private const CAPTAIN_JACK:int		= 0;
		private const CAPTAIN_BAKUBA:int	= 1;
		private const CAPTAIN_SMITH:int		= 2;
		
		private var m_background:mcBackground;
		private var m_bgOverlay:MovieClip;
		private var m_battleLayer:MovieClip;
		private var m_interface:mcUserInterface;
		private var m_effectLayer:MovieClip;
		private var m_gameContainer:MovieClip;
		private var m_nodes:Array;
		private var m_nodeView:Array;
		
		private var m_captNodes:Array;
		
		private var m_state:int;
		
		private var m_idleTimer:Timer;
		private var m_spawnActive:Boolean;
		private var m_startWave:Boolean; //siput;
		private var m_dummyCursor:mcDummyCursor;
		
		private var m_mouseX:int;
		private var m_mouseY:int;
		
		
		private var m_selectedButton:MovieClip;
		private var m_selectedBar:MovieClip;
		private var m_selectedCooldown:int;
		
		private var m_selectedCost:int;
		private var m_laneLayers:Array;
		private var m_placementNodeShown:Boolean;
		private var m_barrageUsed:Boolean;
		
		
		// wave data
		private var m_currSpawnTick:int;
		private var m_spawnTick:int;
		private var m_spawnCount:int;
		private var m_laneMax:int;
		private var m_ctrLane:int; //siput
		private var m_researchPointGain:int;
		private var m_tickCounter:int;
		
		private var m_waveIndex:int;
		private var m_waveCurrGroup:int;
		private var m_waveCurrGroupIndex:int; //siput
		private var m_waveCurrCtr:int;
		
		private var m_currentWaveState:String;
		private var m_waves:XML;
		private var m_totalWaveTime:int;
		private var m_currentWaveTime:int;
		private var m_waveMarks:Array;			// wave icons
		private var m_gameComplete:Boolean;
		
		// swap data
		private var m_swapUnit01:CBaseTeelos;
		private var m_swapUnit02:CBaseTeelos;
		
		//misc objects
		private var m_bgm:CSoundObject;
		private var m_screenOption:mc_OptionInGame;
		private var m_bgOption:mc_optionBG;
		private var m_exitPrompt:exit_prompt;
		private var m_customCursor:mcCustomCursor;
		private var m_debris:mc_debris;
		private var m_barrageTarget:mcBarrageTarget;
		private var m_camera:CVirtualCamera;
		
		private var m_dynamiteTarget:mcDynamiteTarget;
		private var m_grenadeStunTarget:mcGrenadeStunTarget;
		private var m_grenadePoisonTarget:mcGrenadePoisonTarget;
		private var m_summonImmortalTarget:mcImmortalTarget;
		private var m_summonCannonTarget:mcSummonCannonTarget;
		private var m_dropArmyTarget:mcDropArmyTarget;
		
		private var m_forfeit:Boolean;
		
		public var m_lastTacticHover:CBaseTeelos;
		
		public var m_readyToBuild:Boolean;
		/**/
		private var m_activeCaptain:int;
		private var m_currCaptain:CBaseTeelos;
		private var m_dropTarget:int;
		
		private const MAX_HORIZONTAL_NODE:int 	= 4;
		private const MAX_VERTICAL_NODE:int		= 5;
				
		private var mouseX:int;
		private var mouseY:int;
		
		public function State_GameLoop(lock:SingletonLock) {}
		
		override public function initialize(owner:DisplayObjectContainer):void 
		{
			super.initialize(owner);
			m_background = new mcBackground();
			m_gameContainer = new MovieClip();
			m_bgOverlay = new MovieClip();
			m_interface = new mcUserInterface();
			m_idleTimer = new Timer(22000);
			m_battleLayer = new MovieClip();
			m_dummyCursor = new mcDummyCursor();
			m_effectLayer = new MovieClip();
			m_customCursor = new mcCustomCursor();
			m_customCursor.cacheAsBitmap = true;
			m_customCursor.mouseEnabled = m_customCursor.mouseChildren = false;
			m_debris = new mc_debris();
			m_debris.cacheAsBitmap = true;
			m_dummyCursor.alpha = 0.5;
			m_dummyCursor.mouseChildren = m_dummyCursor.mouseEnabled = false;
			
			m_grenadeStunTarget = new mcGrenadeStunTarget();
			m_grenadeStunTarget.cacheAsBitmap = true;
			m_bgOverlay.addChild(m_grenadeStunTarget);
			m_grenadeStunTarget.visible = false;
			m_grenadeStunTarget.alpha = 0.3;
			m_grenadeStunTarget.x = 0;
			m_grenadeStunTarget.y = 192;
			
			m_dynamiteTarget = new mcDynamiteTarget();
			m_dynamiteTarget.cacheAsBitmap = true;
			m_bgOverlay.addChild(m_dynamiteTarget);
			m_dynamiteTarget.visible = false;
			m_dynamiteTarget.alpha = 0.3;
			m_dynamiteTarget.x = 0;
			m_dynamiteTarget.y = 192;
			
			m_grenadePoisonTarget = new mcGrenadePoisonTarget();
			m_grenadePoisonTarget.cacheAsBitmap = true;
			m_bgOverlay.addChild(m_grenadePoisonTarget);
			m_grenadePoisonTarget.visible = false;
			m_grenadePoisonTarget.alpha = 0.3;
			m_grenadePoisonTarget.x = 0;
			m_grenadePoisonTarget.y = 192;
			
			m_summonImmortalTarget = new mcImmortalTarget();
			m_summonImmortalTarget.cacheAsBitmap = true;
			m_bgOverlay.addChild(m_summonImmortalTarget);
			m_summonImmortalTarget.visible = false;
			m_summonImmortalTarget.alpha = 0.3;
			m_summonImmortalTarget.x = 0;
			m_summonImmortalTarget.y = 192;
			
			m_summonCannonTarget = new mcSummonCannonTarget();
			m_summonCannonTarget.cacheAsBitmap = true;
			m_bgOverlay.addChild(m_summonCannonTarget);
			m_summonCannonTarget.visible = false;
			m_summonCannonTarget.alpha = 0.3;
			m_summonCannonTarget.x = 0;
			m_summonCannonTarget.y = 192;
			
			m_dropArmyTarget = new mcDropArmyTarget();
			m_dropArmyTarget.cacheAsBitmap = true;
			m_bgOverlay.addChild(m_dropArmyTarget);
			m_dropArmyTarget.visible = false;
			m_dropArmyTarget.alpha = 0.3;
			m_dropArmyTarget.x = 0;
			m_dropArmyTarget.y = 192;
			
			m_waveMarks = [];
			
			SoundManager.getInstance().addMusic("BGM_Throne", new BGM_Throne());
			SoundManager.getInstance().addMusic("BGM_01", new BGM_01());
			SoundManager.getInstance().addMusic("BGM_02", new BGM_02());
			SoundManager.getInstance().addMusic("BGM_03", new BGM_03());
			
			ParticleManager.getInstance().enable = true;
			ParticleManager.getInstance().initialize(1600, 500);
			
			m_laneLayers = [];
			for ( var i:int = 0; i < 5; i++ )
			{
				m_laneLayers[i] = new MovieClip();
			}
			m_laneLayers.reverse();
			registerGameObjects();
			createNodes();
		}
		
		private function registerGameObjects():void
		{
			// player teelos
			NPCManager.getInstance().registerEntity( CTeeloTeemy, 1 );
			NPCManager.getInstance().registerEntity( CTeeloLeegos, 1 );
			NPCManager.getInstance().registerEntity( CTeeloFeela, 1 );
			NPCManager.getInstance().registerEntity( CTeeloElonee, 1 );
			NPCManager.getInstance().registerEntity( CTeeloSeeldy, 1 );
			NPCManager.getInstance().registerEntity( CTeeloEndrogee, 1 );
			NPCManager.getInstance().registerEntity( CTeeloUgee, 1 );
			NPCManager.getInstance().registerEntity( CTeeloAgeesum, 1 );
			NPCManager.getInstance().registerEntity( CTeeloTrap, 1 );
			NPCManager.getInstance().registerEntity( CTeeloBallistaTower, 1 );
			NPCManager.getInstance().registerEntity( CTeeloTreasury, 1 );
			NPCManager.getInstance().registerEntity( CTeeloBarricade, 1 );
			NPCManager.getInstance().registerEntity( CTeeloLastBarricade, 1 );
			
			NPCManager.getInstance().registerEntity( CTeeloSmallCannon , 1);
			NPCManager.getInstance().registerEntity( CTeeloMediumCannon, 1);
			NPCManager.getInstance().registerEntity( CTeeloSummoned_Infantro, 1);
			NPCManager.getInstance().registerEntity( CTeeloSummoned_Immortal, 1);
			
			NPCManager.getInstance().registerEntity( CCaptainJack, 1 );
			NPCManager.getInstance().registerEntity( CCaptainBakuba_Clone, 1);
			NPCManager.getInstance().registerEntity( CCaptainBakuba, 1 );
			NPCManager.getInstance().registerEntity( CCaptainSmith, 1 );
			
			
			NPCManager.getInstance().registerEntity( CTeeloWorkerReturn, 1 );
			
			// enemy teelos
			//NPCManager.getInstance().registerEntity( CTeeloInfantro, 1 );
			//NPCManager.getInstance().registerEntity( CTeeloKapitro, 1 );
			NPCManager.getInstance().registerEntity( CTeeloCroztan, 1 );
			NPCManager.getInstance().registerEntity( CTeeloTeeclon, 1 );
			NPCManager.getInstance().registerEntity( CTeeloUdizark, 1 );
			NPCManager.getInstance().registerEntity( CTeeloPoztazark, 1 );
			NPCManager.getInstance().registerEntity( CTeeloUmaz, 1 );
			NPCManager.getInstance().registerEntity( CTeeloCaplozton, 1 );
			NPCManager.getInstance().registerEntity( CTeeloCaploztonCatapult, 1 );
			NPCManager.getInstance().registerEntity( CTeeloFlagee, 1 );
			NPCManager.getInstance().registerEntity( CTeeloHestaclan, 1 );
			NPCManager.getInstance().registerEntity( CTeeloRammer, 1 );
			NPCManager.getInstance().registerEntity( CTeeloBalistatoz, 1 );
			NPCManager.getInstance().registerEntity( CTeeloWeezee, 1 );
			NPCManager.getInstance().registerEntity( CTeeloTeegor, 1 );
			
			// register projectiles
			MissileManager.getInstance().registerEntity( CMissileArrow_Feela, 1 );
			MissileManager.getInstance().registerEntity( CMissileFireball_Elonee, 1 );
			MissileManager.getInstance().registerEntity( CMissileIceBall_Endrogee, 1 );
			MissileManager.getInstance().registerEntity( CMissileBallista_Tower, 1 );
			MissileManager.getInstance().registerEntity( CMissileArrow_Croztan, 1 );
			MissileManager.getInstance().registerEntity( CMissileArrow_Hestaclan, 1 );
			MissileManager.getInstance().registerEntity( CMissileBallista_Balistatoz, 1 );
			MissileManager.getInstance().registerEntity( CMissileBarrage, 1 );
			
			//add-ons
			MissileManager.getInstance().registerEntity( CMissileDynamite, 1);
			MissileManager.getInstance().registerEntity( CMissileGrenadeStun, 1);
			MissileManager.getInstance().registerEntity( CMissileGrenadePoison, 1);
			MissileManager.getInstance().registerEntity( CMissileLineStrike , 1);
			MissileManager.getInstance().registerEntity( CMissileCannon_Small, 1);
			MissileManager.getInstance().registerEntity( CMissileCannon_Medium, 1);
			MissileManager.getInstance().registerEntity( CMissileCrow_Bakuba, 1);
			MissileManager.getInstance().registerEntity( CMissileBall_Smith, 1);

			MissileManager.getInstance().registerEntity( CMissileFireball_Weezee, 1 );
			MissileManager.getInstance().registerEntity( CMissileFireball_Teegor, 1 );
			MissileManager.getInstance().registerEntity( CMissileIceBall_Teegor, 1 );
			
			// register effects
			ParticleManager.getInstance().registerEmitter( CEffect_FireExplosion, 1 );
			ParticleManager.getInstance().registerEmitter( CEffect_IceExplosion, 1 );
			ParticleManager.getInstance().registerEmitter( CEffect_Heal, 1 );
			ParticleManager.getInstance().registerEmitter( CEffect_Barrage, 1 );
			ParticleManager.getInstance().registerEmitter( CEffect_Summon , 1);
						
			// register particle
			ParticleManager.getInstance().registerEmitter( CEmitterForestMist, 1);
			ParticleManager.getInstance().registerEmitter( CEmitterFallingLeaves, 1);
			ParticleManager.getInstance().registerEmitter( CEmitterMildDust, 1);
			
			// items
			ItemManager.getInstance().registerEntity( CItem_GoldCoin, 1 );
			ItemManager.getInstance().registerEntity( CItem_SilverCoin, 1);
		}
		
		override public function enter():void 
		{
			super.enter();
			
			//debug used:
			//m_laneMax = MAX_VERTICAL_NODE;
			/////
			
			m_state = STATE_DEFAULT;
			m_spawnActive = false;
			m_gameComplete = false;
			m_forfeit = false;
				
			stage.addChild(m_gameContainer);
			m_gameContainer.addChild( m_background );
			m_gameContainer.addChild( m_bgOverlay );
			m_gameContainer.addChild( m_battleLayer );
			for ( var i:int = 0; i < 5; i++ )
			{
				m_battleLayer.addChild( m_laneLayers[i] );
			}
			m_gameContainer.addChild( m_effectLayer );
			m_gameContainer.addChild( m_debris );
			
			m_camera = new CVirtualCamera();
			m_camera.width = 800;
			m_camera.height = 500;
			m_camera.setCameraTarget(400, 250);
			m_gameContainer.addChild( m_camera );
			
			stage.addChild( m_interface );
			
			/*switch( GlobalVars.CURRENT_LEVEL )
			{
				case 0: 
					m_background.gotoAndStop(1); 
					m_bgm = SoundManager.getInstance().playMusic("BGM_01");
					break;
				case 1: 
					m_background.gotoAndStop(2);	
					m_bgm = SoundManager.getInstance().playMusic("BGM_02");
					break;
				case 2: 
					m_background.gotoAndStop(3);	
					m_bgm = SoundManager.getInstance().playMusic("BGM_02");
					break;
				default: 
					m_background.gotoAndStop(4);	
					m_bgm = SoundManager.getInstance().playMusic("BGM_03");	
					break;
			}*/	
			
			m_activeCaptain = CAPTAIN_SMITH;
			GlobalVars.TOTAL_COIN = 10000;
			
			
			registerButtons();
			invalidateGold();
			GlobalVars.KILL_SCORE = 0;
			invalidateScore();
			
			stage.addChild(m_dummyCursor);
			stage.addChild(m_customCursor);
			setupNodes();
			
			m_interface.topBar.cooldownBar01.visible = 
			m_interface.topBar.cooldownBar02.visible = 
			m_interface.topBar.cooldownBar03.visible = 
			m_interface.topBar.cooldownBar04.visible = 
			m_interface.topBar.cooldownBar05.visible = 
			m_interface.topBar.cooldownBar06.visible = 
			m_interface.topBar.cooldownBar07.visible = 
			m_interface.topBar.cooldownBar08.visible = 
			m_interface.topBar.cooldownBar09.visible = 
			m_interface.topBar.cooldownBar10.visible = false;
			
			m_interface.topBar.cooldownAbilityBar01.visible = 
			m_interface.topBar.cooldownAbilityBar02.visible =
			m_interface.topBar.cooldownAbilityBar03.visible =
			m_interface.topBar.cooldownAbilityBar04.visible = false;
			
			m_interface.waveMessage.visible = false;
			m_dummyCursor.visible = false;
			m_customCursor.visible = false;
			m_barrageUsed = false;
			m_tickCounter = 0;
			
			m_dynamiteTarget.visible = false;
			m_grenadePoisonTarget.visible = false;
			m_grenadeStunTarget.visible = false;
			
			//m_barrageTarget.visible = false;
			m_lastTacticHover = null;
			
			m_interface.bottomBar.buttonReady.visible = true;
			
			if ( GlobalVars.CURRENT_LEVEL + 1 == 5 )
			{
				m_interface.topBar.levelText.text = "BOSS FIGHT";
				m_interface.bottomBar.progressLevel.progressMask.gotoAndStop(100);
				//m_interface.topBar.barrageButton.visible = false;
			}
			else
			{
				m_interface.topBar.levelText.text = "Level " + String(GlobalVars.CURRENT_LEVEL + 1) + "-" + String(GlobalVars.CURRENT_SUB_LEVEL + 1);
				m_interface.bottomBar.progressLevel.progressMask.gotoAndStop(1);
				//m_interface.topBar.barrageButton.visible = true;
			}
			
			m_interface.topBar.y = -100;
			m_interface.bottomBar.y = 600;
			TweenMax.to(m_interface.topBar, 0.5, { y:0 } );
			TweenMax.to(m_interface.bottomBar, 0.5, { y:500 } );
			
			//m_interface.topBar.barrageButton.gotoAndStop(1);
			
			if (GlobalVars.HACK)
			{
				m_interface.topBar.cheatButton.visible = false;
			}
			
			GlobalVars.LAST_GOLD_STATE = GlobalVars.TOTAL_COIN;
			GlobalVars.LAST_ASSET_STATE = NPCManager.getInstance().returnTrainCost();
			
			loadWaveData();
			//placeTowers();
			placeCaptain();
			
			//setupWaveProgressBar();
			
			/*switch( m_laneMax )
			{
				case 1: m_debris.gotoAndStop(2); break;
				case 3: m_debris.gotoAndStop(3); break;
				case 5: m_debris.gotoAndStop(1); break;
			}
				
			m_idleTimer.delay = ( GlobalVars.IS_VICTORY ) ? 22000 : 100000;
			m_idleTimer.addEventListener(TimerEvent.TIMER, onIdleComplete);
			m_idleTimer.reset();
			m_idleTimer.start();
			
			m_interface.bottomBar.progressLevel.progressMask.gotoAndStop(100);*/
			
			
			var mc:MovieClip = m_interface.bottomBar.progressLevel.bar;
			TweenMax.to( mc, 0.1, 
						 { colorMatrixFilter: { colorize:0x00CC00, amount:1 },
						   onComplete:function():void
						   {
							   TweenMax.to(mc, m_idleTimer.delay / 1000, {colorMatrixFilter:{colorize:0xCC0000, amount:1} });
						   }
						 });
			
			
			TweenMax.to(m_interface.bottomBar.progressLevel.progressMask, m_idleTimer.delay / 1000, { frame:1 } );
			
			m_interface.topBar.debug.text = "";
			toggleCustomCursor();
			
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			m_interface.topBar.debug.visible = false;
			
			ParticleManager.getInstance().attach(m_effectLayer);
			
			switch( GlobalVars.CURRENT_LEVEL )
			{
				case 0: ParticleManager.getInstance().add(CEmitterForestMist); break;
				case 1: ParticleManager.getInstance().add(CEmitterFallingLeaves); break;
				case 2: ParticleManager.getInstance().add(CEmitterFallingLeaves); break;
				default: ParticleManager.getInstance().add(CEmitterMildDust); break;
			}
			
			NPCManager.getInstance().refreshLife();
			
			/*if( MOUSE_TRAIL_ENABLE )
				stage.addEventListener(MouseEvent.CLICK, _checkMouseEventTrail);*/
		}
		
		private function setupWaveProgressBar():void
		{
			m_currentWaveTime = 0;
			
			m_totalWaveTime = WaveManager.getInstance().getWaveTotalTime(GlobalVars.CURRENT_LEVEL, GlobalVars.CURRENT_SUB_LEVEL) - 
							  WaveManager.getInstance().getSpawnTick(GlobalVars.CURRENT_LEVEL, GlobalVars.CURRENT_SUB_LEVEL);	
			
			
			var waveMarks:Array = WaveManager.getInstance().getWaveMarks(GlobalVars.CURRENT_LEVEL, GlobalVars.CURRENT_SUB_LEVEL);
			
			if ( waveMarks.length > 0 )
			{
				var barLength:int = 203;
				for ( var i:int; i < waveMarks.length; i++ )
				{
					var finalW:Boolean = (i == waveMarks.length - 1) ? true : false;
					
					if( !finalW )
						var percentage:Number = waveMarks[i] / m_totalWaveTime;
					else	
						percentage = 1;
					
					var pos:int = barLength * percentage;
					var icon:MovieClip = new mcWaveMilestone();
					icon.mouseEnabled = icon.mouseChildren = false;
					m_interface.bottomBar.addChild(icon);
					
					var offset:int = (finalW) ? 12 : 8;
					icon.x = (757 - pos) + offset;
					icon.y = -18.50;
					icon.alpha = 0;
					icon.scaleX = icon.scaleY = 4;
					
					m_waveMarks.push(icon);
				}
			}
		}
		
		private function showWaveMilestone():void
		{
			if ( m_waveMarks.length > 0 )
			{
				for ( var i:int; i < m_waveMarks.length; i++ )
				{
					var mc:MovieClip = MovieClip(m_waveMarks[i]);
					TweenMax.to(mc, 0.75, { alpha:1, scaleX:1, scaleY:1, delay:i*0.2, ease:Back.easeOut } );
				}
			}
		}
		
		private function clearWaveProgressBar():void
		{
			while ( m_waveMarks.length > 0 )
			{
				var icon:MovieClip = MovieClip(m_waveMarks[0]);
				m_interface.bottomBar.removeChild(icon);
				
				m_waveMarks.splice(0, 1);
			}
		}
		
		private function loadWaveData():void
		{
			var curr_level:int = GlobalVars.CURRENT_LEVEL;
			var curr_sub_level:int = GlobalVars.CURRENT_SUB_LEVEL;
			
			m_currentWaveState = WaveManager.getInstance().getFirstWaveType(curr_level, curr_sub_level);
			m_currSpawnTick = 0;
			
			m_spawnTick = WaveManager.getInstance().getSpawnTick(curr_level, curr_sub_level);
			m_spawnCount = WaveManager.getInstance().getSpawnTickCount(curr_level, curr_sub_level);
			m_laneMax = WaveManager.getInstance().getLaneCount(curr_level, curr_sub_level);
			m_researchPointGain = WaveManager.getInstance().getRPGained(curr_level, curr_sub_level);
			
			m_waveIndex = 0;
			m_waveCurrGroup = 0;
			m_waveCurrGroupIndex = 0;
			m_waveCurrCtr = 0;
			m_ctrLane = 0;
			
			m_waves = WaveManager.getInstance().getWave(curr_level, curr_sub_level);
		}
		
		override public function exit():void 
		{
			m_bgm.stop();
			
			if( MOUSE_TRAIL_ENABLE )
				stage.removeEventListener(MouseEvent.CLICK, _checkMouseEventTrail);
			
			clearWaveProgressBar();
			
			ParticleManager.getInstance().clear();
			ParticleManager.getInstance().detach();
			MissileManager.getInstance().clear();
			ItemManager.getInstance().clear();
			
			var clearPlayer:Boolean = (GlobalVars.CURRENT_SUB_LEVEL == 0 || m_forfeit);
			NPCManager.getInstance().removeBarricades();
			NPCManager.getInstance().clear(clearPlayer, true);
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			
			
			m_interface.bottomBar.buttonMenu.removeEventListener(MouseEvent.MOUSE_UP, onBottomBarMouseUp);
			m_interface.bottomBar.buttonMenu.removeEventListener(MouseEvent.MOUSE_UP, onBottomBarMouseUp);
			m_interface.bottomBar.buttonMenu.removeEventListener(MouseEvent.MOUSE_OUT, onBottomBarMouseLeave);
			
			m_interface.bottomBar.buttonExit.removeEventListener(MouseEvent.MOUSE_UP, onBottomBarMouseDown);
			m_interface.bottomBar.buttonExit.removeEventListener(MouseEvent.MOUSE_UP, onBottomBarMouseDown);
			m_interface.bottomBar.buttonExit.removeEventListener(MouseEvent.MOUSE_OUT, onBottomBarMouseLeave);
			
			m_idleTimer.removeEventListener(TimerEvent.TIMER, onIdleComplete);
			m_idleTimer.reset();
			
			m_state = STATE_DEFAULT ;
			m_dummyCursor.visible = false;
			m_customCursor.visible = false;
			Mouse.show();
			
			unregisterButtons();
			removeNodes();
			
			stage.removeChild( m_interface );
			
			/*
			stage.removeChild(m_customCursor);
			stage.removeChild(m_dummyCursor);
			stage.removeChild( m_debris );
			stage.removeChild( m_effectLayer );
			
			for ( var i:int = 0; i < 5; i++ )
			{
				m_battleLayer.removeChild( m_laneLayers[i] );
			}
			stage.removeChild( m_battleLayer );
			stage.removeChild( m_bgOverlay );
			stage.removeChild( m_background );
			*/
			
			
			stage.removeChild(m_customCursor);
			stage.removeChild(m_dummyCursor);
			
			
			m_gameContainer.removeChild( m_debris );
			m_gameContainer.removeChild( m_effectLayer );
			
			for ( var i:int = 0; i < 5; i++ )
			{
				m_battleLayer.removeChild( m_laneLayers[i] );
			}
			m_gameContainer.removeChild( m_battleLayer );
			m_gameContainer.removeChild( m_bgOverlay );
			m_gameContainer.removeChild( m_background );
			m_gameContainer.removeChild( m_camera );
			stage.removeChild( m_gameContainer );
			
			super.exit();
		}
		
		private function onIdleComplete(event:TimerEvent = null):void
		{
			m_interface.bottomBar.buttonReady.visible = false;
			m_idleTimer.reset();
			m_spawnActive = true;
			m_startWave = true;
			m_currSpawnTick = m_spawnTick;
			showWaveMilestone();
		}
		
		private function registerButtons():void
		{
			for (var i:int = 0; i < GlobalVars.CHOSEN_UNIT.length ; i++)
			{
				var unitId:int = GlobalVars.CHOSEN_UNIT[i];
				if (GlobalVars.CHOSEN_UNIT[i] != 0)
				{
					m_interface.topBar["buttonUnit0" + (i + 1)].gotoAndStop(unitId);
					m_interface.topBar["buttonUnit0" + (i + 1)].id = unitId;
				}
				else
				{
					m_interface.topBar["buttonUnit0" + (i + 1)].visible = false;
				}
			}
			
			registerButtonEvents(m_interface.topBar.buttonUnit01);
			/*m_interface.topBar.buttonTeemy.visible = GlobalVars.UNLOCKED_TEEMY;
			m_interface.topBar.buttonLeegos.visible = GlobalVars.UNLOCKED_LEEGOS;
			m_interface.topBar.buttonFeela.visible = GlobalVars.UNLOCKED_FEELA;
			m_interface.topBar.buttonElonee.visible = GlobalVars.UNLOCKED_ELONEE;
			m_interface.topBar.buttonSeeldy.visible = GlobalVars.UNLOCKED_SEELDY;
			m_interface.topBar.buttonEndrogee.visible = GlobalVars.UNLOCKED_ENDROGEE;
			m_interface.topBar.buttonUgee.visible = GlobalVars.UNLOCKED_UGEE;
			m_interface.topBar.buttonAgeesum.visible = GlobalVars.UNLOCKED_AGEESUM;
			m_interface.topBar.buttonTrap.visible = GlobalVars.UNLOCKED_TRAP;
			m_interface.topBar.buttonBallista.visible = GlobalVars.UNLOCKED_BALLISTA;
			m_interface.topBar.buttonTreasury.visible = GlobalVars.UNLOCKED_TREASURY;
			m_interface.topBar.buttonBarricade.visible = GlobalVars.UNLOCKED_BARRICADE;*/
			
			/*m_interface.topBar.buttonTeemy.costText.text = String(COST_TEEMY);
			m_interface.topBar.buttonLeegos.costText.text = String(COST_LEEGOS);
			m_interface.topBar.buttonFeela.costText.text = String(COST_FEELA);
			m_interface.topBar.buttonElonee.costText.text = String(COST_ELONEE);
			m_interface.topBar.buttonSeeldy.costText.text = String(COST_SEELDY);
			m_interface.topBar.buttonEndrogee.costText.text = String(COST_ENDROGEE);
			m_interface.topBar.buttonUgee.costText.text = String(COST_UGEE);
			m_interface.topBar.buttonAgeesum.costText.text = String(COST_AGEESUM);
			m_interface.topBar.buttonTrap.costText.text = String(COST_TRAP);
			m_interface.topBar.buttonBallista.costText.text = String(COST_BALLISTA);
			m_interface.topBar.buttonTreasury.costText.text = String(COST_TREASURY);
			m_interface.topBar.buttonBarricade.costText.text = String(COST_BARRICADE);*/
			
			/*registerButtonEvents(m_interface.topBar.buttonTeemy);
			registerButtonEvents(m_interface.topBar.buttonLeegos);
			registerButtonEvents(m_interface.topBar.buttonFeela);
			registerButtonEvents(m_interface.topBar.buttonElonee);
			registerButtonEvents(m_interface.topBar.buttonSeeldy);
			registerButtonEvents(m_interface.topBar.buttonEndrogee);
			registerButtonEvents(m_interface.topBar.buttonUgee);
			registerButtonEvents(m_interface.topBar.buttonAgeesum);
			registerButtonEvents(m_interface.topBar.buttonTrap);
			registerButtonEvents(m_interface.topBar.buttonBallista);
			registerButtonEvents(m_interface.topBar.buttonTreasury);
			registerButtonEvents(m_interface.topBar.buttonBarricade);*/
			
			registerAbilityButton(m_interface.topBar.ability01);
			registerAbilityButton(m_interface.topBar.ability02);
			registerAbilityButton(m_interface.topBar.ability03);
			registerAbilityButton(m_interface.topBar.ability04);
			
			
			/*siput*/
			m_interface.bottomBar.buttonMenu.addEventListener(MouseEvent.MOUSE_DOWN, onBottomBarMouseDown);
			m_interface.bottomBar.buttonMenu.addEventListener(MouseEvent.MOUSE_UP, onBottomBarMouseUp);
			m_interface.bottomBar.buttonMenu.addEventListener(MouseEvent.MOUSE_OUT, onBottomBarMouseLeave);
			
			m_interface.bottomBar.buttonExit.addEventListener(MouseEvent.MOUSE_DOWN, onBottomBarMouseDown);
			m_interface.bottomBar.buttonExit.addEventListener(MouseEvent.MOUSE_UP, onBottomBarMouseUp);
			m_interface.bottomBar.buttonExit.addEventListener(MouseEvent.MOUSE_OUT, onBottomBarMouseLeave);
			
			/*m_interface.topBar.retreatDummy.addEventListener(MouseEvent.MOUSE_UP, onTacticButtonMouseUp);
			m_interface.topBar.swapDummy.addEventListener(MouseEvent.MOUSE_UP, onTacticButtonMouseUp);
			m_interface.topBar.barrageDummy.addEventListener(MouseEvent.MOUSE_UP, onBarrageButtonMouseUp);*/
			
			/*if (!GlobalVars.HACK)
			{
				m_interface.topBar.cheatDummy.addEventListener(MouseEvent.MOUSE_UP, playCheatMode);
				m_interface.topBar.cheatDummy.buttonMode = m_interface.topBar.cheatDummy.useHandCursor = true;
			}
			
			m_interface.topBar.retreatDummy.buttonMode = m_interface.topBar.retreatDummy.useHandCursor = true;
			m_interface.topBar.swapDummy.buttonMode = m_interface.topBar.swapDummy.useHandCursor = true;
			m_interface.topBar.barrageDummy.buttonMode = m_interface.topBar.barrageDummy.useHandCursor = true;*/
			
			m_interface.bottomBar.buttonMenu.buttonMode = m_interface.bottomBar.buttonMenu.useHandCursor = true;
			m_interface.bottomBar.buttonExit.buttonMode = m_interface.bottomBar.buttonExit.useHandCursor = true;
			
			m_interface.bottomBar.buttonReady.addEventListener(MouseEvent.MOUSE_DOWN, onButtonReadyDown);
			m_interface.bottomBar.buttonReady.addEventListener(MouseEvent.MOUSE_UP, onButtonReadyUp);
			m_interface.bottomBar.buttonReady.addEventListener(MouseEvent.MOUSE_OUT, onButtonReadyOut);
			
			m_interface.bottomBar.sponsorLogo.addEventListener(MouseEvent.MOUSE_DOWN, linkClicked);
			m_interface.bottomBar.sponsorLogo.addEventListener(MouseEvent.ROLL_OVER, logoRollOver);
			m_interface.bottomBar.sponsorLogo.addEventListener(MouseEvent.ROLL_OUT, logoRollOut);
			m_interface.bottomBar.sponsorLogo.addEventListener(MouseEvent.MOUSE_OUT, onBottomBarMouseLeave);
			m_interface.bottomBar.sponsorLogo.buttonMode = m_interface.bottomBar.sponsorLogo.useHandCursor = true;
		}
		
		private function unregisterButtons():void
		{
			m_interface.bottomBar.sponsorLogo.removeEventListener(MouseEvent.MOUSE_DOWN, linkClicked);
			m_interface.bottomBar.sponsorLogo.removeEventListener(MouseEvent.ROLL_OVER, logoRollOver);
			m_interface.bottomBar.sponsorLogo.removeEventListener(MouseEvent.ROLL_OUT, logoRollOut);
			m_interface.bottomBar.sponsorLogo.removeEventListener(MouseEvent.MOUSE_OUT, onBottomBarMouseLeave);
			
			m_interface.bottomBar.buttonReady.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonReadyDown);
			m_interface.bottomBar.buttonReady.removeEventListener(MouseEvent.MOUSE_UP, onButtonReadyUp);
			m_interface.bottomBar.buttonReady.removeEventListener(MouseEvent.MOUSE_OUT, onButtonReadyOut);
			
			m_interface.topBar.retreatDummy.removeEventListener(MouseEvent.MOUSE_UP, onTacticButtonMouseUp);
			m_interface.topBar.swapDummy.removeEventListener(MouseEvent.MOUSE_UP, onTacticButtonMouseUp);
			m_interface.topBar.barrageDummy.removeEventListener(MouseEvent.MOUSE_UP, onBarrageButtonMouseUp);
			
			if (!GlobalVars.HACK)
			{
				m_interface.topBar.cheatDummy.removeEventListener(MouseEvent.MOUSE_UP, playCheatMode);
			}
			
			unregisterButtonEvents(m_interface.topBar.buttonBarricade);
			unregisterButtonEvents(m_interface.topBar.buttonTreasury);
			unregisterButtonEvents(m_interface.topBar.buttonTeemy);
			unregisterButtonEvents(m_interface.topBar.buttonLeegos);
			unregisterButtonEvents(m_interface.topBar.buttonFeela);
			unregisterButtonEvents(m_interface.topBar.buttonElonee);
			unregisterButtonEvents(m_interface.topBar.buttonSeeldy);
			unregisterButtonEvents(m_interface.topBar.buttonEndrogee);
			unregisterButtonEvents(m_interface.topBar.buttonUgee);
			unregisterButtonEvents(m_interface.topBar.buttonAgeesum);
			unregisterButtonEvents(m_interface.topBar.buttonTrap);
			unregisterButtonEvents(m_interface.topBar.buttonBallista);
		}
				
		private function createNodes():void
		{
			var yStart:int = 200;
			var xStart:int = 140;
			var xIncr:int = 75;
			var yIncr:int = 65;
			
			//
			var captYstart:int = 200;
			var captXstart:int = 50;
			var captYincr:int = 65;
			
			// node object
			m_nodes = [];
			var ypos:int = yStart;
			for( var y:int = 0; y < MAX_VERTICAL_NODE; y++ )
			{
				var xpos:int = xStart;
				
				m_nodes[y] = [];
				for (var x:int = 0; x < MAX_HORIZONTAL_NODE; x++ )
				{
					var node:CPlacementNode = new CPlacementNode();
					node.x = xpos;
					node.y = ypos;
					node.laneId = y;
					node.alpha = 0;
					m_nodes[y][x] = node;
					
					xpos += xIncr;
				}
				
				ypos += yIncr;
			}
			
			// node view
			m_nodeView = [];
			for( y = 0; y < MAX_VERTICAL_NODE; y++ )
			{
				m_nodeView[y] = [];
				for(x = 0; x < MAX_HORIZONTAL_NODE; x++ )
				{
					node = m_nodes[y][x];
					
					var dummy:PlacementDummy = new PlacementDummy();
					
					dummy.x = node.x-5;
					dummy.y = node.y-10;
					dummy.visible = false;
					m_bgOverlay.addChild(dummy);
					
					m_nodeView[y][x] = dummy;
				}
			}
			
			/*captain invisible nodes*/
			m_captNodes = [];
			var captYpos:int = captYstart;
			for( var cy:int = 0; cy < MAX_VERTICAL_NODE; cy++ )
			{
				var captXpos:int = captXstart;
				
				m_captNodes[cy] = [];
				for (var cx:int = 0; cx < 1; cx++ )
				{
					var captainNode:CCaptainMoveNode = new CCaptainMoveNode();
					captainNode.x = captXpos;
					captainNode.y = captYpos;
					captainNode.laneId = cy;
					captainNode.alpha = 0;
					
					m_captNodes[cy][cx] = captainNode;
		
				}
				
				captYpos += captYincr;
			}
		}
		
		private function setupNodes():void
		{
			for (var y:int = 0; y < MAX_VERTICAL_NODE; y++ )
			{
				for (var x:int = 0; x < MAX_HORIZONTAL_NODE; x++ )
				{
					var node:CPlacementNode = m_nodes[y][x];
					stage.addChild(node);
					node.addEventListener(MouseEvent.MOUSE_DOWN, onNodeMouseDown);
					node.addEventListener(MouseEvent.MOUSE_UP, onNodeMouseUp);
					/*node.addEventListener(MouseEvent.MOUSE_OVER, onNodeMouseOver);
					node.addEventListener(MouseEvent.MOUSE_OUT, onNodeMouseOut);*/
				}
			}
			
			for (var cy:int = 0; cy < MAX_VERTICAL_NODE ; cy++)
			{
				for (var cx:int = 0; cx < 1; cx++)
				{
					var cNode:CCaptainMoveNode = m_captNodes[cy][cx];
					stage.addChild(cNode);
					cNode.addEventListener(MouseEvent.MOUSE_DOWN, onCaptNodeMouseDown);
					cNode.addEventListener(MouseEvent.MOUSE_UP, onCaptNodeMouseUp);
				}
			}
			
			m_placementNodeShown = false;
			toggleNodeMouseEnable(false);
			toggleBottomBarEnable(true);
		}
		
		private function toggleNodeMouseEnable(value:Boolean):void
		{
			for (var y:int = 0; y < MAX_VERTICAL_NODE; y++ )
			{
				for (var x:int = 0; x < MAX_HORIZONTAL_NODE; x++ )
				{
					var node:CPlacementNode = m_nodes[y][x];
					node.mouseEnabled = value;
					if ( value )
						stage.setChildIndex(node, stage.numChildren - 1);
					
				}
			}
			
			/*for (var cy:int = 0; cy < MAX_VERTICAL_NODE ; cy++)
			{
				for (var cx:int = 0; cx < 1; cx++)
				{
					var cNode:CCaptainMoveNode = m_captNodes[cy][cx];
					cNode.mouseEnabled = value;
					if (value)
						stage.setChildIndex(cNode, stage.numChildren - 1);
				}
			}	*/
		}
		
		private function toggleBottomBarEnable(value:Boolean):void
		{
			m_interface.bottomBar.mouseEnabled = m_interface.bottomBar.mouseChildren = value;
		}
		
		private function removeNodes():void
		{
			hidePlacementNode();
			for (var y:int = 0; y < MAX_VERTICAL_NODE; y++ )
			{
				for (var x:int = 0; x < MAX_HORIZONTAL_NODE; x++ )
				{
					var node:CPlacementNode = m_nodes[y][x];
					
					node.removeEventListener(MouseEvent.MOUSE_DOWN, onNodeMouseDown);
					node.removeEventListener(MouseEvent.MOUSE_UP, onNodeMouseUp);
					/*node.removeEventListener(MouseEvent.MOUSE_OVER, onNodeMouseOver);
					node.removeEventListener(MouseEvent.MOUSE_OUT, onNodeMouseOut);*/
					
					stage.removeChild(node);
				}
			}
		}
		
		private function placeTowers():void
		{
			for ( var i:int = 0; i < m_laneMax; i++ )
			{
				NPCManager.getInstance().add( CTeeloLastBarricade, i, 20, m_laneLayers[i] );
			}
		}
		
		private function placeCaptain():void
		{
			//var i:int;
			var lane:int = 1;
			switch (m_activeCaptain)
			{
				case 0:				
				m_currCaptain = NPCManager.getInstance().add( CCaptainJack, lane , 45, m_laneLayers[1] );
				break;
				case 1:
				m_currCaptain = NPCManager.getInstance().add( CCaptainBakuba, lane , 50, m_laneLayers[2] );
				break;
				case 2:
				m_currCaptain = NPCManager.getInstance().add( CCaptainSmith, lane , 50, m_laneLayers[2] );
				break;
			}
			m_currCaptain.laneIndex = lane;

		}
		
		private function onNodeMouseDown(event:MouseEvent):void
		{
		}
		
		
		private function onNodeMouseUp(event:MouseEvent):void
		{
			var node:CPlacementNode = CPlacementNode(event.currentTarget);
			if (m_state == STATE_PLACING && node.laneId < m_laneMax)
			{
				if ( !node.obtained )
				{
					hidePlacementNode();
					m_state = STATE_DEFAULT ;
					toggleNodeMouseEnable(false);
					toggleBottomBarEnable(true);
					
					SoundManager.getInstance().playSFX("SN16");
					
					node.obtained = true;
					
					m_dummyCursor.visible = false;
					showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
					
					GlobalVars.TOTAL_COIN -= m_selectedCost;
					invalidateGold();
					
					var teelo:CPlayerTeelos;
					var teeloClass:Class;
					
					switch( m_selectedButton )
					{
						case m_interface.topBar.buttonUnit01:
								checkUnitType(m_selectedButton.id);
								teeloClass = UNITCLASS_SELECTED; 		
								break;
						case m_interface.topBar.buttonLeegos:
								teeloClass = CTeeloLeegos; 		break;
						case m_interface.topBar.buttonFeela:
								teeloClass = CTeeloFeela; 		break;
						case m_interface.topBar.buttonElonee:
								teeloClass = CTeeloElonee; 		break;		
						case m_interface.topBar.buttonSeeldy:
								teeloClass = CTeeloSeeldy;		break;
						case m_interface.topBar.buttonEndrogee:
								teeloClass = CTeeloEndrogee;	break;
						case m_interface.topBar.buttonUgee:
								teeloClass = CTeeloUgee;		break;
						case m_interface.topBar.buttonAgeesum:
								teeloClass = CTeeloAgeesum;		break;		
						case m_interface.topBar.buttonTrap:
								teeloClass = CTeeloTrap;		break;
						case m_interface.topBar.buttonTreasury:
								teeloClass = CTeeloTreasury;	break;
						case m_interface.topBar.buttonBallista:
								teeloClass = CTeeloBallistaTower;		break;		
						case m_interface.topBar.buttonBarricade:
								teeloClass = CTeeloBarricade;		break;			
					}
					teelo = CPlayerTeelos( NPCManager.getInstance().add( teeloClass, node.laneId, node.x , m_laneLayers[node.laneId] ) );	
					//trace(teelo);
					teelo.setDestination( node.x );
					teelo.placementNode = node;
					
				}
			}
			//trace(node.laneId);
			
		}
		
		/*private function onNodeMouseOver(event:MouseEvent):void
		{
			
		}
		
		private function onNodeMouseOut(event:MouseEvent):void
		{
			
		}*/
		
		
		private function onCaptNodeMouseUp(event:MouseEvent):void
		{
			if (m_state == STATE_DEFAULT)
			{
				var cNode:CCaptainMoveNode = CCaptainMoveNode(event.currentTarget);
				var captain:MovieClip = CPlayerCaptain(m_currCaptain).getSprite();
				
				var step:int = Math.abs(m_currCaptain.laneIndex - cNode.laneId);
				
				m_currCaptain.laneIndex = cNode.laneId;
				m_currCaptain.setCurrentFrame(2);
				
				CBaseTeelos(m_currCaptain).walk = true;
				TweenMax.to(captain, step * m_currCaptain.speed, { y:cNode.y , onComplete:function():void {
					m_currCaptain.setCurrentFrame(1);
					CBaseTeelos(m_currCaptain).walk = false;
					}} );
			}
			
		}
		private function onCaptNodeMouseDown(event:MouseEvent):void
		{
			
		}
		
		private function registerButtonEvents(button:MovieClip):void
		{
			button.buttonMode = button.useHandCursor = true;
			button.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			button.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseUp);
			button.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseOver);
			button.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseOut);
		}
		private function registerAbilityButton(button:MovieClip):void
		{
			button.buttonMode = button.useHandCursor = true;
			button.addEventListener(MouseEvent.MOUSE_DOWN, onAbilityMouseDown);
			button.addEventListener(MouseEvent.MOUSE_DOWN, onAbilityMouseUp);
			button.addEventListener(MouseEvent.MOUSE_DOWN, onAbilityMouseOver);
			button.addEventListener(MouseEvent.MOUSE_DOWN, onAbilityMouseOut);
		}
		
		private function unregisterButtonEvents(button:MovieClip):void
		{
			button.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
			button.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseUp);
			button.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseOver);
			button.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseOut);
		}
		private function unregisterAbilityButton(button:MovieClip):void
		{
			button.removeEventListener(MouseEvent.MOUSE_DOWN, onAbilityMouseDown);
			button.removeEventListener(MouseEvent.MOUSE_DOWN, onAbilityMouseUp);
			button.removeEventListener(MouseEvent.MOUSE_DOWN, onAbilityMouseOver);
			button.removeEventListener(MouseEvent.MOUSE_DOWN, onAbilityMouseOut);
		}
		
		
		public function set state(value:int):void
		{
			m_state = value;
		}
		public function get state():int
		{
			return m_state;
		}
		public function get stateDefault():int
		{
			return STATE_DEFAULT;
		}
	
		public function get effectLayer():MovieClip
		{
			return m_effectLayer;
		}
		
		private function onAbilityMouseDown(event:MouseEvent):void
		{
			
		}
		private function onAbilityMouseUp(event:MouseEvent):void
		{
			var button:MovieClip = MovieClip(event.currentTarget);
			if (m_state == STATE_DEFAULT)
			{
				m_selectedButton = button;
				switch (m_selectedButton)
				{
					case m_interface.topBar.ability01:
							m_selectedBar = m_interface.topBar.cooldownAbilityBar01;
							if (m_currCaptain is CCaptainJack)
							{
								m_selectedCooldown = 20;
								m_state = STATE_DYNAMITE_JACK;
								m_dynamiteTarget.visible = true;
							}
							else if (m_currCaptain is CCaptainBakuba)
							{
								m_selectedCooldown = 25;
								m_state = STATE_IMMORTAL_BAKUBA;
								m_summonImmortalTarget.visible = true;
							}
							else if (m_currCaptain is CCaptainSmith)
							{
								m_selectedCooldown = 30;
								m_state = STATE_POWERUP_SMITH;
							}
						break;
					case m_interface.topBar.ability02:
							m_selectedBar = m_interface.topBar.cooldownAbilityBar02;
							if (m_currCaptain is CCaptainJack)
							{
								m_selectedCooldown = 40;
								m_state = STATE_GRENADE1_JACK;
								m_grenadeStunTarget.visible = true;
							}
							else if (m_currCaptain is CCaptainBakuba)
							{
								m_selectedCooldown = 40;
								m_state = STATE_CLONE_BAKUBA;
								showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
								m_currCaptain.setCurrentFrame(6);
								CCaptainBakuba(m_currCaptain).isCloning = true;
							}
							else if (m_currCaptain is CCaptainSmith)
							{
								m_selectedCooldown = 12
								m_state = STATE_RATEUP_SMITH;
							}
						break;
					case m_interface.topBar.ability03:
							m_selectedBar = m_interface.topBar.cooldownAbilityBar03;
							if (m_currCaptain is CCaptainJack)
							{
								m_selectedCooldown = 30;
								m_state = STATE_GRENADE2_JACK;
								m_grenadePoisonTarget.visible = true;
							}
							else if (m_currCaptain is CCaptainBakuba)
							{
								m_selectedCooldown = 60;
								m_state = STATE_CANNON_BAKUBA;
								showPlacementNode();
								m_summonCannonTarget.visible = true;
							}
							else if (m_currCaptain is CCaptainSmith)
							{
								m_selectedCooldown = 50;
								m_state = STATE_FIXIT_SMITH;
							}
						break;
					case m_interface.topBar.ability04:
							m_selectedBar = m_interface.topBar.cooldownAbilityBar04;
							if (m_currCaptain is CCaptainJack)
							{
								m_selectedCooldown = 60;
								showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
								m_currCaptain.setCurrentFrame(8);
								CCaptainJack(m_currCaptain).useLineStrike = true;
							}
							else if (m_currCaptain is CCaptainBakuba)
							{
								m_selectedCooldown = 75;
								m_state = STATE_DROPARMY_BAKUBA;
								m_dropArmyTarget.visible = true;
									
							}
							else if (m_currCaptain is CCaptainSmith)
							{
								m_selectedCooldown = 18;
								m_state = STATE_DOUBLESHOT_SMITH;
							}
						break;
				}
			}
			else
			{
				if (button == m_selectedButton)
				{
					switch (m_state)
					{
						case STATE_DYNAMITE_JACK:
						m_dynamiteTarget.visible = false;
						break;
						case STATE_GRENADE1_JACK:
						m_grenadeStunTarget.visible = false;
						break;
						case STATE_GRENADE2_JACK:
						m_grenadePoisonTarget.visible = false;
						break;
					}
					m_state = STATE_DEFAULT;
				}
			}
		}
		private function onAbilityMouseOver(event:MouseEvent):void
		{
			
		}
		private function onAbilityMouseOut(event:MouseEvent):void
		{
			
		}
		
		
		
		private function onButtonMouseDown(event:MouseEvent):void
		{
		
		}
		
		private function checkUnitType(id:int):void
		{
			switch(id)
			{
				case GlobalVars.UNIT_SMALL_CANNON:
				COST_SELECTED = COST_SMALL_CANNON;
				COOLDOWN_SELECTED = COOLDOWN_SMALL_CANNON;
				UNITCLASS_SELECTED = CTeeloSmallCannon;
				break;
			}
		}
		
		private function onButtonMouseUp(event:MouseEvent):void
		{
			var button:MovieClip = MovieClip(event.currentTarget);
		
			if( m_state == STATE_DEFAULT || m_state == STATE_CLONE_BAKUBA )
			{
				m_selectedButton = button;
				var createFlag:Boolean = false;
												
				switch( m_selectedButton )
				{
					case m_interface.topBar.buttonUnit01:
							checkUnitType(m_selectedButton.id);
							if( GlobalVars.TOTAL_COIN >= COST_SELECTED )
							{
								m_dummyCursor.gotoAndStop(m_selectedButton.id); 
								m_selectedBar = m_interface.topBar.cooldownBar01;
								m_selectedCooldown = COOLDOWN_SELECTED;
								m_selectedCost = COST_SELECTED;
								invalidateGold();
								createFlag = true;
							}		
							break;	
					case m_interface.topBar.buttonTeemy:
							if( GlobalVars.TOTAL_COIN >= COST_SMALL_CANNON )
							{
								m_dummyCursor.gotoAndStop(1);
								m_selectedBar = m_interface.topBar.cooldownBar02;
								m_selectedCooldown = 3;
								m_selectedCost = COST_SMALL_CANNON;
								invalidateGold();
								createFlag = true;
							}
							break;
					case m_interface.topBar.buttonLeegos:
							if( GlobalVars.TOTAL_COIN >= COST_LEEGOS )
							{
								m_dummyCursor.gotoAndStop(2);
								m_selectedBar = m_interface.topBar.cooldownBar03;
								m_selectedCooldown = 3;
								m_selectedCost = COST_LEEGOS;
								invalidateGold();
								createFlag = true;
							}
							break;
					case m_interface.topBar.buttonFeela:
							if( GlobalVars.TOTAL_COIN >= COST_FEELA )
							{
								m_dummyCursor.gotoAndStop(3); 
								m_selectedBar = m_interface.topBar.cooldownBar04;
								m_selectedCooldown = 15;
								m_selectedCost = COST_FEELA;
								invalidateGold();
								createFlag = true;
							}
							break;
					case m_interface.topBar.buttonSeeldy:
							if( GlobalVars.TOTAL_COIN >= COST_SEELDY )
							{
								m_dummyCursor.gotoAndStop(4); 
								m_selectedBar = m_interface.topBar.cooldownBar05;
								m_selectedCooldown = 15;
								m_selectedCost = COST_SEELDY;
								invalidateGold();
								createFlag = true;
							}
							break;		
					case m_interface.topBar.buttonElonee:
							if( GlobalVars.TOTAL_COIN >= COST_ELONEE )
							{
								m_dummyCursor.gotoAndStop(5); 
								m_selectedBar = m_interface.topBar.cooldownBar06;
								m_selectedCooldown = 20;
								m_selectedCost = COST_ELONEE;
								invalidateGold();
								createFlag = true;
							}
							break;	
					case m_interface.topBar.buttonEndrogee:
							if( GlobalVars.TOTAL_COIN >= COST_ENDROGEE )
							{
								m_dummyCursor.gotoAndStop(6); 
								m_selectedBar = m_interface.topBar.cooldownBar07;
								m_selectedCooldown = 15;
								m_selectedCost = COST_ENDROGEE;
								invalidateGold();
								createFlag = true;
							}
							break;
					case m_interface.topBar.buttonAgeesum:
							if( GlobalVars.TOTAL_COIN >= COST_AGEESUM )
							{
								m_dummyCursor.gotoAndStop(7); 
								m_selectedBar = m_interface.topBar.cooldownBar08;
								m_selectedCooldown = 20;
								m_selectedCost = COST_AGEESUM;
								invalidateGold();
								createFlag = true;
							}
							break;
					case m_interface.topBar.buttonUgee:
							if( GlobalVars.TOTAL_COIN >= COST_UGEE )
							{
								m_dummyCursor.gotoAndStop(8); 
								m_selectedBar = m_interface.topBar.cooldownBar09;
								m_selectedCooldown = 12;
								m_selectedCost = COST_UGEE;
								invalidateGold();
								createFlag = true;
							}
							break;
					case m_interface.topBar.buttonTrap:
							if( GlobalVars.TOTAL_COIN >= COST_TRAP )
							{
								m_dummyCursor.gotoAndStop(9); 
								m_selectedBar = m_interface.topBar.cooldownBar10;
								m_selectedCooldown = 15;
								m_selectedCost = COST_TRAP;
								invalidateGold();
								createFlag = true;
							}
							break;
					case m_interface.topBar.buttonBallista:
							if( GlobalVars.TOTAL_COIN >= COST_BALLISTA )
							{
								m_dummyCursor.gotoAndStop(10); 
								m_selectedBar = m_interface.topBar.cooldownBar11;
								m_selectedCooldown = 120;
								m_selectedCost = COST_BALLISTA;
								invalidateGold();
								createFlag = true;
							}
							break;
					case m_interface.topBar.buttonBarricade:
							if( GlobalVars.TOTAL_COIN >= COST_BARRICADE )
							{
								m_dummyCursor.gotoAndStop(12); 
								m_selectedBar = m_interface.topBar.cooldownBar12;
								m_selectedCooldown = 30;
								m_selectedCost = COST_BARRICADE;
								invalidateGold();
								createFlag = true;
							}		
							break;			
				}
				
				if ( createFlag )
				{
					m_state = STATE_PLACING;
					m_dummyCursor.visible = true;
					m_dummyCursor.x = m_mouseX;
					m_dummyCursor.y = m_mouseY;
					showPlacementNode();
					toggleNodeMouseEnable(true);
					toggleBottomBarEnable(false);
					
					SoundManager.getInstance().playSFX("SN01");
				}
				else
				{
					SoundManager.getInstance().playSFX("SNAbort");
				}
			}
			else
			{
				m_state = STATE_DEFAULT;
				m_dummyCursor.visible = false;
				m_dummyCursor.x = m_mouseX;
				m_dummyCursor.y = m_mouseY;
				m_customCursor.gotoAndStop(3);
				hidePlacementNode();
				
				
			}
		}
		
		public function showCooldown(plate:MovieClip, intervalSeconds:int, owner:MovieClip):void
		{
			plate.visible = true;
			plate.bar.scaleX = 0;
			TweenMax.to(plate.bar, intervalSeconds, 
						{ scaleX:1, 
						  onComplete:function():void 
						  { 
							  plate.visible = false;
							  // TODO: GLOW BUTTON
						  } 
						} ); 
		}
		
		private function onButtonMouseOver(event:MouseEvent):void
		{
			
		}
		
		private function onButtonMouseOut(event:MouseEvent):void
		{
			
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			setVolume();
			if ( m_state != STATE_PAUSE )
			{
				if ( m_spawnActive && !m_gameComplete )
				{
					updateWave( elapsedTime );
				}
				
				NPCManager.getInstance().update(elapsedTime);
				MissileManager.getInstance().update(elapsedTime);
				ItemManager.getInstance().update(elapsedTime);
				ParticleManager.getInstance().update(elapsedTime);
				m_camera.update(elapsedTime);
			}
		}
		
		
		private function slideMessage():void
		{
			TweenMax.killTweensOf(m_interface.waveMessage);
			m_interface.waveMessage.visible = true;
			m_interface.waveMessage.scaleX = m_interface.waveMessage.scaleY = 4;
			m_interface.waveMessage.alpha = 0;
			
			TweenMax.to(m_interface.waveMessage, 0.75, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeIn,onComplete:function():void
							{
								SoundManager.getInstance().playSFX("wavesign");
								TweenMax.to(m_interface.waveMessage, 3, { onComplete:function():void
												{
													TweenMax.to(m_interface.waveMessage, 0.5, { alpha:0, onComplete:function():void
																	{
																		m_interface.waveMessage.visible = false;
																	}
																});	
												}
											});	
							}
						});
		}
		
		private function updateWave(elapsedTime:int):void
		{
			
			if ( GlobalVars.CURRENT_LEVEL + 1 < 5 )
			{
				m_currentWaveTime += elapsedTime;
					
				var waveProgress:int = Math.floor (m_currentWaveTime / m_totalWaveTime * 100);
				waveProgress = Math.max(1, waveProgress);
						
				if ( waveProgress <= 100 )
				{
					m_interface.topBar.debug.text = String(m_currentWaveTime) + "/" +
													String(m_totalWaveTime) + "=" +
													String(waveProgress) + "%";
						
					m_interface.bottomBar.progressLevel.progressMask.gotoAndStop(waveProgress);
				}
			}
			else
			{
				if ( GlobalVars.BOSS_INSTANCE )
				{
					var bossHP:int = Math.floor(GlobalVars.BOSS_INSTANCE.lifePercentage * 100);
					m_interface.bottomBar.progressLevel.progressMask.gotoAndStop(bossHP);
				}
			}
			
			
			var offset:int;
			m_currSpawnTick += elapsedTime;
			if ( m_currSpawnTick >  m_spawnTick )
			{
				m_tickCounter++;
				
				//show first attack message /*by siput*/
				if (m_waveIndex == 0 && m_startWave)
				{
					m_startWave = false;
					m_interface.waveMessage.gotoAndStop(1);
					slideMessage();
				}
				
				if( m_currentWaveState == WAVE_NORMAL)
				{
					var unitId:String = m_waves.children()[m_waveIndex].children()[m_waveCurrGroup].attribute("id");
						
					var levelmin:int = m_waves.children()[m_waveIndex].children()[m_waveCurrGroup].attribute("min_rank"); 
					var levelmax:int = m_waves.children()[m_waveIndex].children()[m_waveCurrGroup].attribute("max_rank"); 
					var level:int = OpMath.randomRange(levelmin, levelmax);
					var spawnMax:int = m_waves.children()[m_waveIndex].children()[m_waveCurrGroup].attribute("count");
					
					m_waveCurrCtr++;
					
					for (var count:int = 0 ; count < m_spawnCount; count++)
					{
						var diff:int = spawnMax - m_waveCurrCtr;
						//m_waveCurrCtr++;
						
						if (diff >= 1)
						{
							offset = count * OpMath.randomRange(10, 13);
							spawnUnit(unitId, level ,offset);
						}
						else 
						{
							if ( m_waveCurrCtr >= spawnMax )
							{
								m_waveCurrGroup++;
								m_waveCurrCtr = 0;
							}
						}
					}
				
					if ( m_waveCurrGroup >= m_waves.children()[m_waveIndex].children().length() )
					{
						m_waveIndex++; 
						m_currentWaveState = m_waves.children()[m_waveIndex].attribute("type");
						
						if( m_currentWaveState == WAVE_BIG )
						{
							m_interface.waveMessage.gotoAndStop(WAVE_BIG);
							slideMessage();
						}
						else if( m_currentWaveState == WAVE_FINAL )
						{
							m_interface.waveMessage.gotoAndStop(WAVE_FINAL);
							slideMessage();
						}
						
						m_waveCurrGroup = 0;
						m_waveCurrCtr = 0;
					}
				}
				else if( m_currentWaveState == WAVE_BIG)
				{
					for ( var i:int = 0; i < m_waves.children()[m_waveIndex].children().length(); i++ )
					{
						unitId = m_waves.children()[m_waveIndex].children()[i].attribute("id");
						levelmin = m_waves.children()[m_waveIndex].children()[i].attribute("min_rank"); 
						levelmax = m_waves.children()[m_waveIndex].children()[i].attribute("max_rank"); 
						level = OpMath.randomRange(levelmin, levelmax);
						spawnMax = m_waves.children()[m_waveIndex].children()[i].attribute("count"); 
						
						for ( var j:int = 0; j < spawnMax; j++ )
						{
							offset = j * 20;
							spawnUnit(unitId, level, offset);
						}
					}
					
					m_currentWaveState = WAVE_NORMAL;
					m_waveIndex++;
					m_waveCurrGroup = 0;
					m_waveCurrCtr = 0;
				}
				else if( m_currentWaveState == WAVE_FINAL)
				{
					spawnUnit("E13", 1, 20);
					for ( i = 0; i < m_waves.children()[m_waveIndex].children().length(); i++ )
					{
						unitId = m_waves.children()[m_waveIndex].children()[i].attribute("id");
						levelmin = m_waves.children()[m_waveIndex].children()[i].attribute("min_rank"); 
						levelmax = m_waves.children()[m_waveIndex].children()[i].attribute("max_rank"); 
						level = OpMath.randomRange(levelmin, levelmax);
						spawnMax = m_waves.children()[m_waveIndex].children()[i].attribute("count"); 
						
						for ( j = 0; j < spawnMax; j++ )
						{
							offset = j * 20;
							spawnUnit(unitId, level, offset);
						}
					}
					m_currentWaveState = WAVE_COMPLETE;
				}
				if( m_currentWaveState == WAVE_BOSSFIGHT)
				{
					for ( i = 0; i < m_waves.children()[m_waveIndex].children().length(); i++ )
					{
						unitId = m_waves.children()[m_waveIndex].children()[i].attribute("id");
						levelmin = m_waves.children()[m_waveIndex].children()[i].attribute("min_rank"); 
						levelmax = m_waves.children()[m_waveIndex].children()[i].attribute("max_rank"); 
						level = OpMath.randomRange(levelmin, levelmax);
						spawnMax = m_waves.children()[m_waveIndex].children()[i].attribute("count"); 
						
						for ( j = 0; j < spawnMax; j++ )
						{
							offset = j * 20;
							spawnUnit(unitId, level, offset);
						}
					}
					m_currentWaveState = WAVE_COMPLETE;
				}
				else if( m_currentWaveState == WAVE_COMPLETE && NPCManager.getInstance().getEnemyCount() == 0 )
				{
					progressLevel();
				}
				
				m_currSpawnTick = 0;
				m_ctrLane = 0;
			}
		}
		
		private function progressLevel():void
		{
			m_gameComplete = true;
			
			GlobalVars.UNIT_BONUS = NPCManager.getInstance().getPlayerCount();
			GlobalVars.RES_POINT_GAIN = m_researchPointGain;
			GlobalVars.RESEARCH_POINT += m_researchPointGain;
			GlobalVars.IS_VICTORY = true;
					
			GlobalVars.CURRENT_SUB_LEVEL++;
			if ( GlobalVars.CURRENT_SUB_LEVEL >= 5 )
			{
				GlobalVars.CURRENT_LEVEL++;
				GlobalVars.CURRENT_SUB_LEVEL = 0;
				GlobalVars.TOTAL_COIN += NPCManager.getInstance().returnTrainCost();
			}
			
			var dummy:MovieClip = new MovieClip();
			
			trace("Current Level is:", GlobalVars.CURRENT_LEVEL);
			TweenMax.to(dummy, 3, { onComplete:function():void 
									{ 
										if ( GlobalVars.CURRENT_LEVEL == 4 && GlobalVars.CURRENT_SUB_LEVEL == 1)
										{
											m_forfeit = true;
											GameStateManager.getInstance().setState( State_EndingScreen.getInstance() );
										}
										else
										{
											GameStateManager.getInstance().setState( State_WinScreen.getInstance() );
										}
									} 
								  } );
		}
		
		
		
		private function spawnUnit(unitId:String, level:int, offset:int=0 ):void
		{
			var lane:int = Math.floor(OpMath.randomNumber(m_laneMax));
			//var lane:int = 4;
			var spawn:CBaseTeelos;
			
			if(unitId == "E01")
			{
				spawn = NPCManager.getInstance().add(CTeeloInfantro, lane, 850 + offset, m_laneLayers[lane]);
			}
			else if(unitId == "E02")
			{
				spawn = NPCManager.getInstance().add(CTeeloKapitro, lane, 850+offset, m_laneLayers[lane]);	
			}
			else if(unitId == "E03")
			{
				spawn = NPCManager.getInstance().add(CTeeloCroztan, lane, 850+offset, m_laneLayers[lane]);	
			}
			else if(unitId == "E04")
			{
				spawn = NPCManager.getInstance().add(CTeeloHestaclan, lane, 850 + offset, m_laneLayers[lane]);	
			}
			else if(unitId == "E05")
			{
				spawn = NPCManager.getInstance().add(CTeeloTeeclon, lane, 850+offset, m_laneLayers[lane]);	
			}
			else if(unitId == "E06")
			{
				spawn = NPCManager.getInstance().add(CTeeloUdizark, lane, 850+offset, m_laneLayers[lane]);	
			}
			else if(unitId == "E07")
			{
				spawn = NPCManager.getInstance().add(CTeeloUmaz, lane, 850+offset, m_laneLayers[lane]);	
			}
			else if(unitId == "E08")
			{
				spawn = NPCManager.getInstance().add(CTeeloRammer, lane, 850+offset, m_laneLayers[lane]);	
			}
			else if(unitId == "E09")
			{
				spawn = NPCManager.getInstance().add(CTeeloCaploztonCatapult, lane, 850+offset, m_laneLayers[lane]);	
			}
			else if(unitId == "E10")
			{
				spawn = NPCManager.getInstance().add(CTeeloBalistatoz, lane, 850+offset, m_laneLayers[lane]);	
			}
			else if(unitId == "E11")
			{
				spawn = NPCManager.getInstance().add(CTeeloPoztazark, lane, 850+offset, m_laneLayers[lane]);	
			}
			else if(unitId == "E13")
			{
				spawn = NPCManager.getInstance().add(CTeeloFlagee , lane, 850 + offset, m_laneLayers[lane]);	
			}
			else if(unitId == "E12")
			{
				spawn = NPCManager.getInstance().add(CTeeloTeegor, 2, 850+offset, m_laneLayers[2]);	
			}
			else if(unitId == "E14")
			{
				spawn = NPCManager.getInstance().add(CTeeloWeezee, lane, 850+offset, m_laneLayers[lane]);	
			}
			
			spawn.setLevel(level);
		}

		
		public function invalidateGold():void
		{
			m_interface.topBar.goldText.text = String(GlobalVars.TOTAL_COIN);
		}
		
		public function invalidateScore():void
		{
			m_interface.bottomBar.scoreText.text = String(GlobalVars.KILL_SCORE);
		}
		
		public function onStageMouseMove(event:MouseEvent):void
		{
			m_mouseX = event.stageX;
			m_mouseY = event.stageY;
		
			if ( m_state == STATE_PLACING || GlobalVars.CUSTOM_CURSOR )
			{
				m_dummyCursor.x = m_mouseX;
				m_dummyCursor.y = m_mouseY;
			}
			
			if ( m_state == STATE_RETREAT || m_state == STATE_SWAP_PHASE_01 || m_state == STATE_SWAP_PHASE_02 || GlobalVars.CUSTOM_CURSOR )
			{
				m_customCursor.x = m_mouseX;
				m_customCursor.y = m_mouseY;
			}
			
			if ( m_state == STATE_DYNAMITE_JACK )
			{
				m_dynamiteTarget.y = m_currCaptain.y;
				TweenMax.killTweensOf(m_dynamiteTarget);
				TweenMax.to(m_dynamiteTarget, 0.5, { x:m_mouseX } );
			}
			
			if ( m_state == STATE_GRENADE1_JACK )
			{
				m_grenadeStunTarget.y = m_currCaptain.y;
				TweenMax.killTweensOf(m_grenadeStunTarget);
				TweenMax.to(m_grenadeStunTarget, 0.5, { x:m_mouseX } );
			}
			
			if ( m_state == STATE_GRENADE2_JACK )
			{
				m_grenadePoisonTarget.y = m_currCaptain.y;
				TweenMax.killTweensOf(m_grenadePoisonTarget);
				TweenMax.to(m_grenadePoisonTarget, 0.5, { x:m_mouseX } );
			}
			
			if ( m_state == STATE_IMMORTAL_BAKUBA )
			{
				m_summonImmortalTarget.x = m_currCaptain.x;
				if (m_mouseY > 0 && m_mouseY < 200)
				{
					m_summonImmortalTarget.y = 200;
				}
				else if (m_mouseY > 200 && m_mouseY < 265)
				{
					m_summonImmortalTarget.y = 265;
				}
				else if (m_mouseY > 265 && m_mouseY < 325)
				{
					m_summonImmortalTarget.y = 325;
				}
				else if (m_mouseY > 325 && m_mouseY < 385)
				{
					m_summonImmortalTarget.y = 385;
				}
				else if (m_mouseY > 385 && m_mouseY < 445)
				{
					m_summonImmortalTarget.y = 445;
				}
			}
			
			if ( m_state == STATE_CANNON_BAKUBA )
			{
				//m_summonCannonTarget.y = m_currCaptain.y;
				TweenMax.killTweensOf(m_summonCannonTarget);
				TweenMax.to(m_summonCannonTarget, 0.5, { x:m_mouseX } );
			}
			
			if ( m_state == STATE_DROPARMY_BAKUBA)
			{
				m_dropArmyTarget.y = m_currCaptain.y;
				TweenMax.killTweensOf(m_dropArmyTarget);
				TweenMax.to(m_dropArmyTarget, 0.5, { x:m_mouseX} );
			}
			
			// TODO: GLOW UNIT ON HOVER
			
			// glow object (test)
			//if( m_state == STATE_RETREAT || m_state == STATE_SWAP_PHASE_01 || m_state == STATE_SWAP_PHASE_02 )
			if (m_state == STATE_POWERUP_SMITH || m_state == STATE_RATEUP_SMITH
				|| m_state == STATE_FIXIT_SMITH || m_state == STATE_DOUBLESHOT_SMITH)
			{
				
				
				var teelo:CBaseTeelos = NPCManager.getInstance().queryUnitByHit(m_mouseX, m_mouseY);
				
				if(	teelo != null && !(teelo is CPlayerCaptain) )
				{
					if( !teelo.isDead() ) 
					{
					
						if ( m_lastTacticHover && teelo != m_lastTacticHover )
						{
							TweenMax.killTweensOf(m_lastTacticHover.getSprite(), true);
							TweenMax.to(m_lastTacticHover.getSprite(), 0.5, { glowFilter: { color:0x91e600, alpha:0, blurX:0, blurY:0 }	} );
							m_lastTacticHover = null;
						}
					
						if ( teelo && teelo != m_lastTacticHover )
						{
							m_lastTacticHover = teelo;
							TweenMax.killTweensOf(teelo.getSprite(), true);
							TweenMax.to(teelo.getSprite(), 0.5, { glowFilter: { color:0x91e600, alpha:1, blurX:10, blurY:10 } } );
						}
					}
				}
				else
				{
					tacticGlowOff();
				}
			}
		}
		
		public function onStageMouseUp(event:MouseEvent):void
		{
			mouseX = event.stageX;
			mouseY = event.stageY;
			
			//m_currCaptain.changeAIState(AIState_Captain_Ability.getInstance());
			
			//TODO:fix variable defining and scope
			
			var cursorX:int = mouseX;
			var cursorY:int = mouseY;
			
			
			var teelo:CBaseTeelos = NPCManager.getInstance().queryUnitByHit(cursorX, cursorY);
			if (m_state == STATE_POWERUP_SMITH )
			{
				//m_currCaptain.changeAIState(AIState_Smith_POWERUP.getInstance());
				if ( teelo != null && !teelo.isDead() && !(teelo is CPlayerCaptain) &&
					!(teelo.isPowerUp()))
				{
					
					tacticGlowOff();
				
					//adding bonus damage
					CCaptainSmith(m_currCaptain).enchanceTarget = teelo;
					CCaptainSmith(m_currCaptain).usePowerUp = true;
					showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
					m_currCaptain.setCurrentFrame(5);
					
					m_state = STATE_DEFAULT;
					
					//teelo.PowerUP(CCaptainSmith(m_currCaptain).m_powerUpDuration, CPlayerCaptain(m_currCaptain).damageMultiply);
					if ( m_lastTacticHover )
					{
						TweenMax.to(m_lastTacticHover.getSprite(), 0.5, { glowFilter: { color:0x91e600, alpha:0, blurX:0, blurY:0 } } );
						m_lastTacticHover = null;
					}
					
					//toggleCustomCursor();
					//CCaptainSmith(npc).isEnchance = false;
					//npc.changeAIState(AIState_Captain_Idle.getInstance());
					
				}
				
			}
			else if (m_state == STATE_RATEUP_SMITH)
			{
				if ( teelo != null && !teelo.isDead() && !(teelo is CPlayerCaptain) &&
					!(teelo.isRateUp()))
				{
					tacticGlowOff();
					
					//adding bonus damage
					CCaptainSmith(m_currCaptain).enchanceTarget = teelo;
					CCaptainSmith(m_currCaptain).useRateUp = true;
					showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
					m_currCaptain.setCurrentFrame(5);
					
					m_state = STATE_DEFAULT;
					
					//teelo.PowerUP(CCaptainSmith(m_currCaptain).m_powerUpDuration, CPlayerCaptain(m_currCaptain).damageMultiply);
					if ( m_lastTacticHover )
					{
						TweenMax.to(m_lastTacticHover.getSprite(), 0.5, { glowFilter: { color:0x91e600, alpha:0, blurX:0, blurY:0 } } );
						m_lastTacticHover = null;
					}
				}
			}
			else if (m_state == STATE_FIXIT_SMITH)
			{
				if ( teelo != null && !teelo.isDead() && !(teelo is CPlayerCaptain))
				{
					tacticGlowOff();
					
					//adding bonus damage
					CCaptainSmith(m_currCaptain).enchanceTarget = teelo;
					CCaptainSmith(m_currCaptain).useHeal = true;
					showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
					m_currCaptain.setCurrentFrame(6);
					
					m_state = STATE_DEFAULT;
					
					//teelo.PowerUP(CCaptainSmith(m_currCaptain).m_powerUpDuration, CPlayerCaptain(m_currCaptain).damageMultiply);
					if ( m_lastTacticHover )
					{
						TweenMax.to(m_lastTacticHover.getSprite(), 0.5, { glowFilter: { color:0x91e600, alpha:0, blurX:0, blurY:0 } } );
						m_lastTacticHover = null;
					}
				}
			}
			else if (m_state == STATE_DOUBLESHOT_SMITH)
			{
				if ( teelo != null && !teelo.isDead() && !(teelo is CPlayerCaptain) &&
					!(teelo.isDoubleShot()))
				{
					tacticGlowOff();
					
					//adding bonus damage
					CCaptainSmith(m_currCaptain).enchanceTarget = teelo;
					CCaptainSmith(m_currCaptain).useDoubleShot = true;
					showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
					m_currCaptain.setCurrentFrame(5);
					
					m_state = STATE_DEFAULT;
					
					//teelo.PowerUP(CCaptainSmith(m_currCaptain).m_powerUpDuration, CPlayerCaptain(m_currCaptain).damageMultiply);
					if ( m_lastTacticHover )
					{
						TweenMax.to(m_lastTacticHover.getSprite(), 0.5, { glowFilter: { color:0x91e600, alpha:0, blurX:0, blurY:0 } } );
						m_lastTacticHover = null;
					}
				}
			}
			else if (m_state == STATE_IMMORTAL_BAKUBA)
			{
				//var laneSlctd:int;
				
				if (m_summonImmortalTarget.y == 200 )
				{
					CCaptainBakuba(m_currCaptain).summonLane = 0;
				}
				else if (m_summonImmortalTarget.y == 265)
				{
					CCaptainBakuba(m_currCaptain).summonLane = 1;
				}
				else if (m_summonImmortalTarget.y == 325)
				{
					CCaptainBakuba(m_currCaptain).summonLane = 2;
				}
				else if (m_summonImmortalTarget.y ==385)
				{
					CCaptainBakuba(m_currCaptain).summonLane = 3;
				}
				else if (m_summonImmortalTarget.y == 445)
				{
					CCaptainBakuba(m_currCaptain).summonLane = 4;
				}
				
				if ( cursorY > 100 )
				{
					CCaptainBakuba(m_currCaptain).isSummonImmortal = true;
					showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
					m_currCaptain.setCurrentFrame(5);
					m_summonImmortalTarget.visible = false;
					m_state = STATE_DEFAULT;
					//State_GameLoop.getInstance().state = State_GameLoop.getInstance().stateDefault;
					//m_currCaptain.changeAIState(AIState_Captain_Idle.getInstance());
				}
			}
			else 
			{
				var targetLane:Array = [];
				
				var startIndex:int;
				var maxIndex:int;
				
				if (startIndex < 4)
				{
					switch (m_state)
					{
						case STATE_DYNAMITE_JACK:
						startIndex = m_currCaptain.laneIndex;
						maxIndex = startIndex + 1;
						break;
						case STATE_GRENADE2_JACK:
						startIndex = m_currCaptain.laneIndex;						
						maxIndex = startIndex + 2;
						break;
						case STATE_GRENADE1_JACK:
						startIndex = m_currCaptain.laneIndex;						
						maxIndex = (m_laneMax - 1);
						break;
						case STATE_CANNON_BAKUBA:
						startIndex = 0;
						maxIndex = (m_laneMax - 1);
						break;
						case STATE_DROPARMY_BAKUBA:
						startIndex = m_currCaptain.laneIndex;			
						maxIndex = startIndex + 2;
					}
				}
				else
				{
					maxIndex = startIndex;
					
				}
				
				for ( var i:int = startIndex ; i <=  maxIndex ; i++ )
				{
					var nodeY:int = CPlacementNode(m_nodes[i][0]).y;
					
					if ( cursorY > nodeY - 40 && cursorY < nodeY + 20 )
					{
						for ( var j:int = startIndex ; j <= maxIndex ; j ++)
						{
							targetLane.push(j);
						}
					}
				}
				
				if (m_state == STATE_DYNAMITE_JACK)
				{
					showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
					// launch artillery
					if ( targetLane.length > 0 )
					{
						if (cursorX > m_currCaptain.x + 100)
						{
							//bombType = 1;
							m_currCaptain.setCurrentFrame(5);
							CCaptainJack(m_currCaptain).abilityTargetLane = [];
							
							for ( i = 0; i < targetLane.length; i++ )
							{
								var node:CPlacementNode = CPlacementNode(m_nodes[targetLane[i]][0]);
								
								CCaptainJack(m_currCaptain).mTargetX = cursorX;
								CCaptainJack(m_currCaptain).mTargetY.push(node.y);
								CCaptainJack(m_currCaptain).useDynamite = true;
								
								CCaptainJack(m_currCaptain).abilityTargetLane.push(targetLane[i]);
								
								/*MissileManager.getInstance().launch(CMissileDynamite, m_effectLayer, m_currCaptain.x, m_currCaptain.y , 1, 
										FACTION.PLAYER, targetLane[i], 3100, UNITCLASS.NONE, 0, 1, true, null, 
										{targetX:cursorX, targetY:node.y, groundLevel:node.y, delay:launchDelay } );*/
									
							}
								m_dynamiteTarget.visible = false;
								m_state = STATE_DEFAULT;
								//m_currCaptain.changeAIState(AIState_Captain_Idle.getInstance());
						}
					}
				}
				else if (m_state == STATE_GRENADE1_JACK)
				{
					showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
					// launch artillery
					if ( targetLane.length > 0 )
					{
						if (cursorX > m_currCaptain.x + 100)
						{
							//bombType = 2;
							m_currCaptain.setCurrentFrame(6);
							CCaptainJack(m_currCaptain).abilityTargetLane = [];
							
							for ( i = 0; i < targetLane.length; i++ )
							{
								node = CPlacementNode(m_nodes[targetLane[i]][0]);
								//var launchDelay:Number = OpMath.randomNumber(1);
								
								CCaptainJack(m_currCaptain).mTargetX = cursorX;
								CCaptainJack(m_currCaptain).mTargetY.push(node.y);
								CCaptainJack(m_currCaptain).useGrenadeStun = true;
					
								
								CCaptainJack(m_currCaptain).abilityTargetLane.push(targetLane[i]);
								
								/*MissileManager.getInstance().launch(CMissileGrenadeStun, m_effectLayer, m_currCaptain.x, m_currCaptain.y , 1, 
																	FACTION.PLAYER, targetLane[i], 3100, UNITCLASS.NONE, 0, 1, true, null, 
																	{targetX:cursorX, targetY:node.y, groundLevel:node.y,delay:launchDelay} );*/
							}
								m_grenadeStunTarget.visible = false;
								m_state = STATE_DEFAULT;
						}
					}
				}
				else if (m_state == STATE_GRENADE2_JACK)
				{
					showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
					// launch artillery
					if ( targetLane.length > 0 )
					{
						if (cursorX > m_currCaptain.x + 100)
						{
							//bombType = 3;
							m_currCaptain.setCurrentFrame(7);
							CCaptainJack(m_currCaptain).abilityTargetLane = [];
							
							for ( i = 0; i < targetLane.length; i++ )
							{
								node = CPlacementNode(m_nodes[targetLane[i]][0]);
								//var launchDelay:Number = OpMath.randomNumber(1);
								
								CCaptainJack(m_currCaptain).mTargetX = cursorX;
								CCaptainJack(m_currCaptain).mTargetY.push(node.y);
								CCaptainJack(m_currCaptain).useGrenadePoison = true;
								CCaptainJack(m_currCaptain).abilityTargetLane.push(targetLane[i]);
								
								/*MissileManager.getInstance().launch(CMissileGrenadePoison, m_effectLayer, m_currCaptain.x, m_currCaptain.y , 1, 
																	FACTION.PLAYER, targetLane[i], 3100, UNITCLASS.NONE, 0, 1, true, null, 
																	{targetX:cursorX, targetY:node.y, groundLevel:node.y,delay:launchDelay} );*/
							}
								m_grenadePoisonTarget.visible = false;
								m_state = STATE_DEFAULT;
						}
					}
				}
				else if (m_state == STATE_CANNON_BAKUBA)
				{
					showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
					if ( targetLane.length > 0 )
					{
						if (cursorX > m_currCaptain.x + 50)
						{
							CCaptainBakuba(m_currCaptain).abilityTargetLane = [];
							CCaptainBakuba(m_currCaptain).nodeLane = [];
							CCaptainBakuba(m_currCaptain).nodeX = [];
							CCaptainBakuba(m_currCaptain).usedNode = [];
							
							for ( i = 0; i < targetLane.length; i++ )
							{
								
								trace("CURSOR:" , cursorX);
								m_currCaptain.setCurrentFrame(5);
								if (cursorX <= 155)
								{
									node = CPlacementNode(m_nodes[targetLane[i]][0]);
									
									if (!node.obtained)
									{
										m_summonCannonTarget.visible = false;
										hidePlacementNode();
										node.obtained = true;
										CCaptainBakuba(m_currCaptain).isSummonCannon = true;
										CCaptainBakuba(m_currCaptain).abilityTargetLane.push(targetLane[i]);
										CCaptainBakuba(m_currCaptain).nodeLane.push(node.laneId);
										CCaptainBakuba(m_currCaptain).nodeX.push(node.x);
										CCaptainBakuba(m_currCaptain).usedNode.push(node);
										
										m_state = STATE_DEFAULT;
										/*teelos = CPlayerTeelos(NPCManager.getInstance().add( CTeeloSmallCannon, node.laneId, node.x , m_laneLayers[node.laneId])); 
										//trace(teelo);
										teelos.setDestination( node.x );
										teelos.placementNode = node;*/
									}
								}
								else if (cursorX > 180 && cursorX <= 240)
								{
									node = CPlacementNode(m_nodes[targetLane[i]][1]);
									if (!node.obtained)
									{
										m_summonCannonTarget.visible = false;
										hidePlacementNode();
										node.obtained = true;
										CCaptainBakuba(m_currCaptain).isSummonCannon = true;
										CCaptainBakuba(m_currCaptain).abilityTargetLane.push(targetLane[i]);
										CCaptainBakuba(m_currCaptain).nodeLane.push(node.laneId);
										CCaptainBakuba(m_currCaptain).nodeX.push(node.x);
										CCaptainBakuba(m_currCaptain).usedNode.push(node);
										
										m_state = STATE_DEFAULT;
									}
								}
								else if (cursorX > 250 && cursorX <= 290)
								{
									node = CPlacementNode(m_nodes[targetLane[i]][2]);
									if (!node.obtained)
									{
										m_summonCannonTarget.visible = false;
										hidePlacementNode();
										node.obtained = true;
										CCaptainBakuba(m_currCaptain).isSummonCannon = true;
										CCaptainBakuba(m_currCaptain).abilityTargetLane.push(targetLane[i]);
										CCaptainBakuba(m_currCaptain).nodeLane.push(node.laneId);
										CCaptainBakuba(m_currCaptain).nodeX.push(node.x);
										CCaptainBakuba(m_currCaptain).usedNode.push(node);
										
										m_state = STATE_DEFAULT;
									}
								}
								else if (cursorX > 295 && cursorX <= 370)
								{
									node = CPlacementNode(m_nodes[targetLane[i]][3]);
									if (!node.obtained)
									{
										m_summonCannonTarget.visible = false;
										hidePlacementNode();
										node.obtained = true;
										CCaptainBakuba(m_currCaptain).isSummonCannon = true;
										CCaptainBakuba(m_currCaptain).abilityTargetLane.push(targetLane[i]);
										CCaptainBakuba(m_currCaptain).nodeLane.push(node.laneId);
										CCaptainBakuba(m_currCaptain).nodeX.push(node.x);
										CCaptainBakuba(m_currCaptain).usedNode.push(node);
										
										m_state = STATE_DEFAULT;
									}
								}
							}
						}
					}
				}
				else if (m_state == STATE_DROPARMY_BAKUBA)
				{
					showCooldown(m_selectedBar, m_selectedCooldown, m_selectedButton);
					// launch artillery
					if ( targetLane.length > 0 )
					{
						if (cursorX > m_currCaptain.x + 100)
						{
							CCaptainBakuba(m_currCaptain).abilityTargetLane = [];
							m_dropTarget = cursorX;
							m_currCaptain.setCurrentFrame(5);
							for ( i = 0; i < targetLane.length; i++ )
							{
								node = CPlacementNode(m_nodes[targetLane[i]][0]);
								CCaptainBakuba(m_currCaptain).abilityTargetLane.push(targetLane[i]);
								CCaptainBakuba(m_currCaptain).isSummonInfantro = true;
								//var launchDelay:Number = OpMath.randomNumber(1);
								
							}
							m_dropArmyTarget.visible = false;
							m_state = STATE_DEFAULT;
						}
					}
				}	
			}
		}
		
		public function get droptarget():int
		{
			return m_dropTarget;
		}
		public function get gameContainer():MovieClip
		{
			return m_gameContainer;
		}
		public function get laneLayers():Array
		{
			return m_laneLayers;
		}
		
		public function tacticGlowOff():void
		{
			if ( m_lastTacticHover )
			{
				TweenMax.killTweensOf(m_lastTacticHover.getSprite(), true);
				TweenMax.to(m_lastTacticHover.getSprite(), 0.5, { glowFilter: { color:0x91e600, alpha:0, blurX:0, blurY:0 }	} );
				m_lastTacticHover = null;
			}
		}
		
		public function onKeyUp(event:KeyboardEvent):void
		{
			if ( event.keyCode == Keyboard.ESCAPE && m_state != STATE_PAUSE )
			{
				m_state = STATE_DEFAULT;
				m_dummyCursor.visible = false;
				m_dummyCursor.x = m_mouseX;
				m_dummyCursor.y = m_mouseY;
				toggleNodeMouseEnable(false);
				toggleBottomBarEnable(true);
				//m_barrageTarget.visible = false;
				
				
				if (!m_barrageUsed)
				{
					m_interface.topBar.barrageButton.gotoAndStop(1);
				}
				hidePlacementNode();
				
				if ( GlobalVars.CUSTOM_CURSOR )
				{
					m_customCursor.gotoAndStop(3);
				}
				else
				{
					m_customCursor.visible = false;
					Mouse.show();
				}
			}
		}
		
		public function shakeCamera(value:int, cap:int):void
		{
			m_camera.shake(value, cap);
		}
		
		public function onBottomBarMouseDown(event:MouseEvent):void
		{
			var button:MovieClip = MovieClip(event.currentTarget);
			
			if (m_currentWaveState != WAVE_COMPLETE)
			{
				button.gotoAndStop(2);
			}
		}
		
		public function onBottomBarMouseLeave(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			mc.gotoAndStop(1);
		}
		
		public function onBottomBarMouseUp(event:MouseEvent):void
		{
			var button:MovieClip = MovieClip(event.currentTarget);
			
			button.gotoAndStop(1);
			
			SoundManager.getInstance().playSFX("SN01");
			if (m_currentWaveState != WAVE_COMPLETE)
			{
				switch(button)
				{
					case m_interface.bottomBar.buttonMenu:
						if( m_state == STATE_DEFAULT )
						{
							m_screenOption = new mc_OptionInGame();
							m_bgOption = new mc_optionBG();
							m_owner.addChild(m_bgOption);
							m_owner.addChild(m_screenOption);
							m_screenOption.x = 137.5;
							m_screenOption.y = -300;
							m_bgOption.alpha = 0;
							m_bgOption.x = m_bgOption.y = 0;
							
							m_screenOption.sfx_YES.visible = true;
							m_screenOption.sfx_NO.visible = false;
							m_screenOption.kursor_NO.visible = !GlobalVars.CUSTOM_CURSOR;
							m_screenOption.kursor_YES.visible = GlobalVars.CUSTOM_CURSOR;
							
							m_screenOption.volume_bar.slider_music.x = SoundManager.getInstance().musicVolume * 200;
							m_screenOption.slider.x = m_screenOption[stage.quality + "_quality"].x
							
							m_screenOption.volume_bar.slider_music.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
							m_screenOption.volume_bar.slider_music.addEventListener(MouseEvent.MOUSE_UP, doneSetVol);
							m_screenOption.volume_bar.slider_music.addEventListener(MouseEvent.ROLL_OUT, doneSetVol);
							m_screenOption.LOW_quality.addEventListener(MouseEvent.CLICK, setQualityLOW);
							m_screenOption.MEDIUM_quality.addEventListener(MouseEvent.CLICK, setQualityMED);
							m_screenOption.HIGH_quality.addEventListener(MouseEvent.CLICK, setQualityHIGH);
							m_screenOption.NO_button_sfx.addEventListener(MouseEvent.CLICK, setSFX_off);
							m_screenOption.YES_button_sfx.addEventListener(MouseEvent.CLICK, setSFX_on);
							m_screenOption.NO_button_cursor.addEventListener(MouseEvent.CLICK, removeCustomCursor);
							m_screenOption.YES_button_cursor.addEventListener(MouseEvent.CLICK, setCustomCursor);	
							
							TweenMax.to(m_bgOption, 0.3, { 	alpha:1, 
															onComplete:function():void 
															{
																m_screenOption.close_menu.buttonMode = m_screenOption.close_menu.useHandCursor = true;
																m_screenOption.close_menu.addEventListener(MouseEvent.CLICK, closeMenuOption); 
															
															}
														} );
							TweenMax.to(m_screenOption, 0.55, {  x:137.5, y:128, ease:Back.easeInOut, 
																onComplete:function():void 
																{ 
																	TweenMax.pauseAll();
																} 
															 });
														
							m_state = STATE_PAUSE;
						}
						break;
					case m_interface.bottomBar.buttonExit:
						if( m_state == STATE_DEFAULT )
						{
							m_exitPrompt = new exit_prompt();
							m_bgOption = new mc_optionBG();
							m_owner.addChild(m_bgOption);
							m_owner.addChild(m_exitPrompt);
							
							m_exitPrompt.x = 400;
							m_exitPrompt.y = 250;
							m_exitPrompt.scaleX = m_exitPrompt.scaleY = 0;
							m_bgOption.alpha = 0;
							m_bgOption.x = m_bgOption.y = 0;
							
							TweenMax.to(m_bgOption, 0.3, { alpha:1 } );
							TweenMax.to(m_exitPrompt, 0.25, { scaleX:1, scaleY:1, ease:Quint.easeIn , onComplete:function():void {
								TweenMax.pauseAll();
								m_exitPrompt.yes.alpha = 0;
								m_exitPrompt.no.alpha = 0;
								m_exitPrompt.yes.buttonMode = m_exitPrompt.yes.useHandCursor = true;
								m_exitPrompt.no.buttonMode = m_exitPrompt.no.useHandCursor = true;
								m_exitPrompt.yes.addEventListener(MouseEvent.MOUSE_UP, exitGame);
								m_exitPrompt.no.addEventListener(MouseEvent.MOUSE_UP, backToGame);
								}});
							
							m_state = STATE_PAUSE
						}
						break;
				}
			}
			
			invalidateCursor();
		}
		
		private function invalidateCursor():void
		{
			if ( GlobalVars.CUSTOM_CURSOR )
			{
				stage.setChildIndex(m_customCursor, stage.numChildren - 1);
			}
		}
		
		private function exitGame(e:MouseEvent):void
		{
			m_state = STATE_DEFAULT;
			m_owner.removeChild(m_bgOption);
			m_owner.removeChild(m_exitPrompt);
			m_forfeit = true;
			GameStateManager.getInstance().setState(State_MainMenu.getInstance());
		}
		
		private function backToGame(e:MouseEvent):void
		{	
			TweenMax.to(m_exitPrompt, 0.25, { scaleX:1, scaleY:1, ease:Back.easeIn , onComplete:function():void {
							
							TweenMax.resumeAll();
							m_state = STATE_DEFAULT;
							m_exitPrompt.yes.removeEventListener(MouseEvent.MOUSE_UP, exitGame);
							m_exitPrompt.no.removeEventListener(MouseEvent.MOUSE_UP, backToGame);
							m_owner.removeChild(m_exitPrompt);
							}});
			TweenMax.to(m_bgOption, 0.3, { alpha:0 , onComplete:function():void {
							m_owner.removeChild(m_bgOption);
							}} );
		}
		
		private function startDragging(e:MouseEvent):void
		{
			var rect:Rectangle = new Rectangle(0, 0, 200, 0);
			e.currentTarget.startDrag(false, rect)
			
		}
		
		private function setVolume():void
		{
			if (m_screenOption != null)
			{
				//var vol:Number = Screen_Options.volume_bar.slider_music.x / 100;
				var vol:Number = m_screenOption.volume_bar.slider_music.x / (m_screenOption.volume_bar.bar_music.width - m_screenOption.volume_bar.bar_music.x);
	
				SoundManager.getInstance().musicVolume = vol;
			}
		}
		
		private function doneSetVol(e:MouseEvent):void
		{
			e.currentTarget.stopDrag();
		}
		
		private function setCustomCursor(e:MouseEvent):void
		{
			m_screenOption.kursor_YES.visible = true;
			m_screenOption.kursor_NO.visible = false;
			
			GlobalVars.CUSTOM_CURSOR = true;
			toggleCustomCursor();
		}
		
		private function toggleCustomCursor():void
		{
			if ( GlobalVars.CUSTOM_CURSOR )
			{
				m_customCursor.visible = true;
				Mouse.hide();
			
				if ( m_state != STATE_SWAP_PHASE_01 && m_state != STATE_SWAP_PHASE_02 && m_state != STATE_RETREAT )
				{
					m_customCursor.gotoAndStop(3);
					m_customCursor.x = m_mouseX;
					m_customCursor.y = m_mouseY;
					stage.setChildIndex(m_customCursor, stage.numChildren - 1);
				}	
			}
			else
			{
				if ( m_state != STATE_SWAP_PHASE_01 && m_state != STATE_SWAP_PHASE_02 && m_state != STATE_RETREAT )
				{
					m_customCursor.visible = false;
					Mouse.show();
				}
			}
		}
		
		
		private function removeCustomCursor(e:MouseEvent):void
		{
			m_screenOption.kursor_YES.visible = false;
			m_screenOption.kursor_NO.visible = true;		
			
			GlobalVars.CUSTOM_CURSOR = false;
			toggleCustomCursor();
		}
		
		private function setSFX_off(e:MouseEvent):void
		{
			m_screenOption.sfx_NO.visible = true;
			m_screenOption.sfx_YES.visible = false;
			SoundManager.getInstance().sfxEnable = false;
		}
		private function setSFX_on(e:MouseEvent):void
		{
			m_screenOption.sfx_NO.visible = false;
			m_screenOption.sfx_YES.visible = true;
			SoundManager.getInstance().sfxEnable = true;			
		}
		
		private function setQualityLOW(e:MouseEvent):void
		{
			stage.quality = StageQuality.LOW;
			m_screenOption.slider.x = m_screenOption.LOW_quality.x;
			
		}
		private function setQualityMED(e:MouseEvent):void
		{
			stage.quality = StageQuality.MEDIUM;
			m_screenOption.slider.x = m_screenOption.MEDIUM_quality.x;
		}
		private function setQualityHIGH(e:MouseEvent):void
		{
			stage.quality = StageQuality.HIGH;
			m_screenOption.slider.x = m_screenOption.HIGH_quality.x;
		}
		
		private function closeMenuOption(event:MouseEvent):void
		{
			
			TweenMax.to(m_bgOption, 0.25, { alpha:0 , 
											onComplete:function():void 
											{
												m_screenOption.close_menu.removeEventListener(MouseEvent.CLICK, closeMenuOption);
												m_owner.removeChild(m_bgOption);
												m_bgOption = null;
											} 
										} );
										
			TweenMax.to(m_screenOption, 0.75, { 	x:137.5, y: -300, ease:Back.easeInOut, 
												onComplete:function():void 
												{
													m_owner.removeChild(m_screenOption);
													m_screenOption = null;
													TweenMax.resumeAll();
													m_state = STATE_DEFAULT;
												}
											 } );
		}
		
		public function onTacticButtonMouseUp(event:MouseEvent):void
		{
			var button:MovieClip = MovieClip(event.currentTarget);
			
			SoundManager.getInstance().playSFX("SN01");
			
			if ( m_state == STATE_DEFAULT )
			{
				
				if ( button == m_interface.topBar.retreatDummy )
				{
					m_state = STATE_RETREAT;
					m_customCursor.x = m_mouseX;
					m_customCursor.y = m_mouseY;
					m_customCursor.visible = true;
					m_customCursor.gotoAndStop(1);
					Mouse.hide();
				}
				else if ( button == m_interface.topBar.swapDummy )
				{
					m_state = STATE_SWAP_PHASE_01;
					m_customCursor.x = m_mouseX;
					m_customCursor.y = m_mouseY;
					m_customCursor.visible = true;
					m_customCursor.gotoAndStop(2);
					Mouse.hide();
				}
			}
			else
			{
				if ( (button == m_interface.topBar.retreatDummy && m_state == STATE_RETREAT) || 
					 (button == m_interface.topBar.swapDummy && m_state == STATE_SWAP_PHASE_01) ||
					 (button == m_interface.topBar.swapDummy && m_state == STATE_SWAP_PHASE_02) )
				{
					m_state = STATE_DEFAULT;
					m_customCursor.gotoAndStop(3);
					toggleCustomCursor();
				}
			}
		}
		public function playCheatMode(event:MouseEvent):void
		{
			navigateTo("http://www.prehackshub.com/arcade/3323/Teelonians---The-Clan-Wars.html?utm_medium=brandedgames_external&utm_campaign=teelonians&utm_source=ingame&utm_content=ingame");
		}
		
		public function onBarrageButtonMouseUp(event:MouseEvent):void
		{
			if( !m_barrageUsed && m_state == STATE_DEFAULT )
			{
				m_state = STATE_BARRAGE_TARGET;
				m_interface.topBar.barrageButton.gotoAndStop(2);
				m_barrageTarget.visible = true;
			}
			else if ( !m_barrageUsed && m_state == STATE_BARRAGE_TARGET )
			{
				m_state = STATE_DEFAULT;
				m_interface.topBar.barrageButton.gotoAndStop(1);
				m_barrageTarget.visible = false;
			}
		}
		
		public function displayLostScreen():void
		{
			GlobalVars.IS_VICTORY = false;
			
			//GlobalVars.TOTAL_COIN += NPCManager.getInstance().returnTrainCost();
			GlobalVars.TOTAL_COIN = GlobalVars.LAST_GOLD_STATE + GlobalVars.LAST_ASSET_STATE;
			
			GlobalVars.UNLOCKED_MG = GlobalVars.LAST_STATE_LEEGOS;
			GlobalVars.UNLOCKED_MED_CANNON = GlobalVars.LAST_STATE_SEELDY;
			GlobalVars.UNLOCKED_THROWER = GlobalVars.LAST_STATE_AGEESUM;
			GlobalVars.UNLOCKED_MORTAR = GlobalVars.LAST_STATE_FEELA;
			GlobalVars.UNLOCKED_ROCKET = GlobalVars.LAST_STATE_ELONEE;
			GlobalVars.UNLOCKED_BEAR_TRAP = GlobalVars.LAST_STATE_ENDROGEE;
			GlobalVars.UNLOCKED_GLUE_TRAP = GlobalVars.LAST_STATE_UGEE;
			GlobalVars.UNLOCKED_HOLE_TRAP = GlobalVars.LAST_STATE_BARRICADE;
			GlobalVars.UNLOCKED_STONE_TRAP = GlobalVars.LAST_STATE_TREASURY;
			GlobalVars.UNLOCKED_TIMER_BOMB = GlobalVars.LAST_STATE_TRAP;
			GlobalVars.UNLOCKED_TNT = GlobalVars.LAST_STATE_BALLISTA;
			
			GlobalVars.RESEARCH_POINT = GlobalVars.LAST_RESEARCH_POINT;
			
			
			NPCManager.getInstance().clear(true, true);
			GameStateManager.getInstance().setState( State_LoseScreen.getInstance() );
		}
		
		private function onButtonReadyDown(event:MouseEvent):void
		{
			
		}
		
		private function onButtonReadyUp(event:MouseEvent):void
		{
			m_idleTimer.stop();
			var mc:MovieClip = m_interface.bottomBar.progressLevel.bar;
			TweenMax.killTweensOf(mc);
			TweenMax.to(mc, 0.1,{colorMatrixFilter:{colorize:0xCC0000, amount:1}});
			onIdleComplete();
		}
		
		private function onButtonReadyOut(event:MouseEvent):void
		{
		}
		
		public function showPlacementNode():void
		{
			var d:Number = 0;
			
			if ( !m_placementNodeShown )
			{
				for( var y:int = 0; y < m_laneMax; y++ )
				{
					for(var x:int = 0; x < MAX_HORIZONTAL_NODE; x++ )
					{
						var node:CPlacementNode = m_nodes[y][x];
						var dummy:PlacementDummy = m_nodeView[y][x];
						
						if ( !node.obtained )
						{
							dummy.visible = true;
							dummy.scaleX = dummy.scaleY = 0;
							TweenMax.killTweensOf(dummy);
							TweenMax.to(dummy, 0.25, { delay:d, alpha:0.3, scaleX:1, scaleY:1 } );
							d += 0.05;
							
						}
					}
					d = 0;
				}
				
				m_placementNodeShown = true;
			}
		}
		
		public function hidePlacementNode():void
		{
			var d:Number = 0;
			
			if ( m_placementNodeShown )
			{
				for( var y:int; y < m_laneMax; y++ )
				{
					for( var x:int = 0; x < MAX_HORIZONTAL_NODE; x++ )
					{
						var dummy:PlacementDummy = m_nodeView[y][x];
						TweenMax.killTweensOf(dummy, true);
						TweenMax.to(dummy, 0.25, { delay:d, alpha:0, scaleX:0, scaleY:0, onComplete:function():void
													{
														dummy.visible = false;
													}
												});
						d += 0.05;						
					}
					d = 0;
				}
				
				m_placementNodeShown = false;
			}
		}
		
		public function getLaneYPos(index:int):int
		{
			return CPlacementNode(m_nodes[index][0]).y;
		}
		
		public function getLaneLayer(index:int):MovieClip
		{
			return m_laneLayers[index];
		}
		
		public function showBuildCursor(value:Boolean):void
		{
			switch(value)
			{
				case true:
					m_customCursor.gotoAndStop(4);
					if ( !GlobalVars.CUSTOM_CURSOR )
					{
						m_customCursor.visible = true;
						Mouse.hide();
						
						m_customCursor.x = m_mouseX;
						m_customCursor.y = m_mouseY;
					}
					break;
				case false:
					m_customCursor.gotoAndStop(3);
					if ( !GlobalVars.CUSTOM_CURSOR )
					{
						m_customCursor.visible = false;
						Mouse.show();
					}
					break;
			}
		}
		
		private function _checkMouseEventTrail($e:MouseEvent):void
		{
			trace("==================");
			var p:* = $e.target;
			
			while (p)
			{
				trace(">>", p.name,": ",p);
				p = p.parent;
			}
		};
		
		private function logoRollOver(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			mc.nextplay_symbol.gotoAndStop(2);
		}
		
		private function logoRollOut(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			mc.nextplay_symbol.gotoAndStop(1);
			
		}
		
		private function linkClicked(event:MouseEvent):void
		{
			navigateTo("http://www.nextplay.com/?utm_medium=brandedgames_external&utm_campaign=teelonians&utm_source=ingame&utm_content=ingame");
		}
		
		private function navigateTo(url:String):void
		{
			var request:URLRequest = new URLRequest(url);
			navigateToURL(request);
		}
		
		static public function getInstance(): State_GameLoop
		{
			if( m_instance == null ){
				m_instance = new State_GameLoop( new SingletonLock() );
			}
			return m_instance;
		}
	}
}

class SingletonLock{}