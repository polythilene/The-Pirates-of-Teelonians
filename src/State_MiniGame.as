package  
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	import com.game.physics.CBasePhysicBullet;
	import com.game.physics.CBasePhysicEnemy;
	import com.game.physics.CBouncingBullet;
	import com.game.physics.CCannonBullet;
	import com.game.physics.CEnemyPhysicBalonBotak;
	import com.game.physics.CEnemyPhysicBalonJenggot;
	import com.game.physics.CEnemyPhysicJenggot;
	import com.game.physics.CEnemyPhysicKumis;
	import com.game.physics.CEnemyPhysicPreman;
	import com.game.physics.CustomContactListener;
	import com.game.physics.SVG;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import gs.TweenMax;
	import math.OpMath;

	
	/**
	 * ...
	 * @author Wiwit
	 */
	public class State_MiniGame extends CGameState 
	{
		static private var m_instance:State_MiniGame;
		
		private const RATIO:int = 30;					// scale factor for b2dworld pixel to meter unit scale -> 1 meter = 30 pixel
		private const TIME_STEP:Number = 1 / 30;		// world time step, 1 / STAGE FPS
		private const WORLD_LENGTH:Number = 1600;
		private const WORLD_HEIGHT:Number = 1000;
		private const COOLDOWN_TIME:Number = 0.75;
		
		private var m_background:mcMiniGameScreen;
		private var m_interface:mcMinigameUI;
		private var m_world:b2World;
		private var m_debugSprite:Sprite;
		private var m_container:MovieClip;
				
		private var m_powerUp:Boolean;
		private var m_bulletSD:b2CircleDef;
		private var m_bulletBD:b2BodyDef;
		private var m_camera:CVirtualCamera;
		private var m_cursorX:int;
		private var m_cursorY:int;
		
		private var m_defaultScaleX:Number;
		private var m_defaultScaleY:Number;
		
		private var m_cameraHalfWidth:Number = 400;
		private var m_cameraHalfHeight:Number = 250;
		
		private var m_bulletBucket:Vector.<CBasePhysicBullet>;		// list of active bullets
		private var m_bulletGC:Vector.<CBasePhysicBullet>;			// garbage collector for bullets
		
		//private var m_enemy:CBasePhysicEnemy;
		private var m_enemyBucket:Vector.<CBasePhysicEnemy>;		// list of enemies
		private var m_enemyGC:Vector.<CBasePhysicEnemy>;			// list of enemies
		private var m_enemySpawnDelay:int;
		
		private var m_leftArrowPressed:Boolean;
		private var m_rightArrowPressed:Boolean;
			
		public function State_MiniGame(lock:SingletonLock) 
		{
		}
		
		static public function getInstance(): State_MiniGame
		{
			if ( m_instance == null )
			{
				m_instance = new State_MiniGame( new SingletonLock() );
			}
			return m_instance;
		}
		
		override public function initialize(owner:DisplayObjectContainer):void 
		{
			super.initialize(owner);
			
			m_container = new MovieClip();
			m_interface = new mcMinigameUI();
			m_background = new mcMiniGameScreen();
			m_container.addChild(m_background);
			
			m_leftArrowPressed = false;
			m_rightArrowPressed = false;
		}
		
		override public function enter():void 
		{
			super.enter();
			
			setupWorld();
			createWallsAndFloors();
			setupGameObjects();
			//setDebugDraw();		// <== enable / disable debug draw
			createCamera();
			createInterface();
			registerEvents();
		}
		
		private function createInterface():void 
		{
			ParticleManager.getInstance().attach(m_container);
			m_owner.addChild(m_interface);
			
		}
		
		private function createCamera():void 
		{
			m_camera = new CVirtualCamera();
			m_camera.width = 800;
			m_camera.height = 500;
			//m_camera.x = m_cameraHalfWidth;
			//m_camera.y = m_cameraHalfHeight;
			m_camera.setCameraTarget( m_cameraHalfWidth, m_cameraHalfHeight );
			m_defaultScaleX = m_camera.scaleX;	// save default scale value for zoom pupose
			m_defaultScaleY = m_camera.scaleY;
			
			updateCameraInfo();
			clipCamera();
			
			m_container.addChild(m_camera);
		}
		
		private function setDebugDraw():void 
		{
			// create debug canvas to draw sprite into
			m_debugSprite = new Sprite();
			m_container.addChild( m_debugSprite );
			
			var dbgDraw:b2DebugDraw = new b2DebugDraw();
			dbgDraw.m_sprite = m_debugSprite;
			dbgDraw.m_drawScale = RATIO;
			dbgDraw.m_fillAlpha = 0.3;
			dbgDraw.m_lineThickness = 1.0;
			dbgDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			m_world.SetDebugDraw(dbgDraw);
		}
		
		private function registerEvents():void 
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUP);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function unregisterEvents():void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUP);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			if ( e.keyCode == Keyboard.LEFT )
			{
				m_leftArrowPressed = false;
			}
			else if ( e.keyCode == Keyboard.RIGHT )
			{
				m_rightArrowPressed = false;
			}
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if ( e.keyCode == Keyboard.LEFT )
			{
				m_leftArrowPressed = true;
			}
			else if ( e.keyCode == Keyboard.RIGHT )
			{
				m_rightArrowPressed = true;
			}
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			m_cursorX = e.stageX;
			m_cursorY = e.stageY;
			
			var cannonX:int = m_background.mcCannon.x;
			var cannonY:int = m_background.mcCannon.y;
			
			var wx:int = m_camera.x - m_cameraHalfWidth + m_cursorX;	// world x
			var angle:Number = (Math.atan2(m_cursorY - cannonY, wx - cannonX)) * (180 / Math.PI);
			
			angle = Math.max(angle, -70);
			angle = Math.min(angle, 13);

			m_background.mcCannon.rotation = angle;
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			if ( m_interface.mcShootPower.bar.scaleX == 0 )
			{
				m_powerUp = true;
				TweenMax.killTweensOf( m_interface.mcShootPower.bar );
			}
		}
		
		private function onMouseUP(e:MouseEvent):void 
		{
			if ( m_powerUp )
			{
				m_powerUp = false;
				TweenMax.to( m_interface.mcShootPower.bar, COOLDOWN_TIME, { scaleX:0 } );
				shootBullet( m_background.mcCannon.rotation,  m_interface.mcShootPower.bar.scaleX);
			}
		}
		
		private function onMouseWheel(e:MouseEvent):void 
		{
			// handle zoom
			var bx:Number;
			var by:Number;
			
			var sx:Number;
			var sy:Number
			
			bx = m_camera.scaleX;
			by = m_camera.scaleY;
			
			sx = m_camera.scaleX - (e.delta / 10);
			if ( sx < 2.5 )
			{
				sy = m_camera.scaleY - (e.delta / 10);
			}
			else
			{
				// revert
				sx = bx;
				sy = by;
			}
			
			if (sx < 1 || sy < 1)
			{
				sx = m_defaultScaleX;
				sy = m_defaultScaleY;
			}
			
			TweenMax.killTweensOf( m_camera );
			TweenMax.to( m_camera, 1, { scaleX:sx, scaleY:sy, 
										onUpdate:function():void
										{
											updateCameraInfo();
											clipCamera();
										}
									  } );
		}
		
		private function updateCameraInfo():void 
		{
			m_cameraHalfWidth = m_camera.width / 2;
			m_cameraHalfHeight = m_camera.height / 2;
		}
		
		private function setupWorld():void 
		{
			// reinitialize stage
			m_powerUp = false;
			m_cameraHalfWidth = 400;
			m_cameraHalfHeight = 250;
			m_interface.mcShootPower.bar.scaleX = 0;
			m_owner.addChild(m_container);
			
			// create world
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-3000.0, -3000.0);
			worldAABB.upperBound.Set(3000.0, 3000.0);
			
			var gravity:b2Vec2 = new b2Vec2(0, 9.8);
			var ignoreSleeping:Boolean = true;
			
			m_world = new b2World(worldAABB, gravity, ignoreSleeping);
			m_world.SetWarmStarting(true);
			m_world.GetGroundBody().SetUserData("ground");
			m_world.SetContactListener( new CustomContactListener() );
			
			
			// reset state
			m_bulletBucket = new Vector.<CBasePhysicBullet>;
			m_bulletGC = new Vector.<CBasePhysicBullet>;
		}
		
		private function createWallsAndFloors():void 
		{
			var bodyDef:b2BodyDef = new b2BodyDef();
			var shapeDef:b2PolygonDef = new b2PolygonDef();
			
			createTerrain();
			
			// create shooting platform
			shapeDef.SetAsBox(87 / RATIO, 42 / RATIO);
			bodyDef.position.Set(87 / RATIO, (310 + 42) / RATIO);
			
			var platformBody:b2Body = m_world.CreateBody(bodyDef);
		}
		
		private function createTerrain():void 
		{
			// this data is exported from Adobe Illustrator :p, strip unecessary data!! 
			// we need -> "<svg>, <g>, <polyline>"
			
			var svg:XML = 
						<svg>
							<g id="Minigame_Terrain">
								<polyline points="-26.167,455.929 -18.167,401.929 517.5,395.634 517.5,444.74"/>
								<polyline points="525.832,444.5 517.5,395.634 586.5,371.954 597.822,409.246"/>
								<polyline points="605,408.227 586.5,371.954 723.833,319.167 723.833,371.954"/>
								<polyline points="734.499,371.954 723.833,319.167 793.833,296.836 800,357.167"/>
								<polyline points="807.833,360.5 793.833,296.836 854.499,291.167 850.944,360.5"/>
								<polyline points="854.499,363.167 854.499,291.167 917.362,286.788 913.166,357.167"/>
								<polyline points="917.362,355.167 917.362,286.788 998.751,297.103 981.832,366.5"/>
								<polyline points="992,366.5 998.751,297.103 1068.5,326.645 1057.166,375.167"/>
								<polyline points="1068.5,371.954 1071,329 1127.833,345 1103.833,390.166"/>
								<polyline points="1123,394.5 1125.673,344.828 1231.674,353.245 1226,401.833"/>
								<polyline points="1239.5,401.833 1231.674,353.245 1316.5,345 1313.166,383.833"/>
								<polyline points="1322.499,383.833 1316.5,345 1389.833,342.5 1377.166,383.833"/>
								<polyline points="1395.166,383.833 1389.833,342.5 1439,353.416 1425.5,394.5"/>
								<polyline points="1439,394.5 1439,353.416 1482,372 1473.102,411.833"/>
								<polyline points="1490.802,425.874 1482,372 1809.166,374 1804.499,433.833"/>
							</g>
						</svg>	
							
			SVG.getInstance().data = svg;
			SVG.getInstance().ratio = RATIO;
			SVG.getInstance().world = m_world;
			SVG.getInstance().buildBody("Minigame_Terrain");		// get data by svg layer id
		}
		
		private function setupGameObjects():void 
		{
			// bullet definition
			m_bulletSD = new b2CircleDef();
				
			m_bulletSD.radius = 13 / RATIO;
			m_bulletSD.density = 1;
			m_bulletSD.friction = 0.5;
			m_bulletSD.restitution = 0.4;
			
			m_bulletBD = new b2BodyDef();
			
			// enemy objects
			m_enemyBucket = new Vector.<CBasePhysicEnemy>();
			m_enemyGC = new Vector.<CBasePhysicEnemy>();
			m_enemySpawnDelay = 5000;
			
			GlobalVars.MINIGAME_SCORE = 0;
		}
		
		override public function exit():void 
		{
			unregisterEvents();
			
			m_owner.removeChild(m_interface);
			ParticleManager.getInstance().detach();
			m_container.removeChild( m_camera );
			m_container.removeChild( m_debugSprite );	// remove debug sprite
			m_owner.removeChild( m_container );			// remove background
			
			super.exit();
		}
		
		private function shootBullet(angle:Number, power:Number):void
		{
			var bullet:CBasePhysicBullet = new CBouncingBullet(m_background.mcCannon.x, m_background.mcCannon.y, angle, power, RATIO, m_bulletBD, m_bulletSD, m_world, m_container);
			m_bulletBucket.push(bullet);
		}
		
		private function degreeToRadian(angle:Number):Number
		{
			return angle * Math.PI / 180;
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			if ( m_powerUp )
			{
				var scale:Number = Math.min( m_interface.mcShootPower.bar.scaleX + (elapsedTime * 0.00075), 1 );
				m_interface.mcShootPower.bar.scaleX = scale;
			}
			
			var cameraPan:int;
			if ( (m_cursorX < 40 || m_leftArrowPressed) && m_camera.x > m_cameraHalfWidth )
			{
				cameraPan = Math.max(m_cameraHalfWidth, m_camera.x - elapsedTime * 0.25);
				m_camera.x = cameraPan;
			}
			else if ( (m_cursorX > 800 - 40 || m_rightArrowPressed) && m_camera.x < WORLD_LENGTH - m_cameraHalfWidth )
			{
				cameraPan = Math.min(WORLD_LENGTH - m_cameraHalfWidth, m_camera.x + elapsedTime * 0.25);
				m_camera.x = cameraPan;
			}
			
			updateEnemies(elapsedTime);
			
			m_world.Step(TIME_STEP, 10);
			updateBullets(elapsedTime);
			ParticleManager.getInstance().update(elapsedTime);
			updateBulletGC();
			
			// update score
			m_interface.score.text = GlobalVars.MINIGAME_SCORE.toString();
		}
		
		private function updateEnemies(elapsedTime:int):void 
		{
			// update time and spawn if it reaches zero
			m_enemySpawnDelay -= elapsedTime;
			if ( m_enemySpawnDelay < 0 )
			{
				spawnEnemy();
				m_enemySpawnDelay = 4000 + OpMath.randomRange(1000, 3000);
			}
			
			// update all enemies
			if ( m_enemyBucket.length > 0 )
			{
				for ( var i:int = 0; i < m_enemyBucket.length; i++ )
				{
					var enemy:CBasePhysicEnemy = CBasePhysicEnemy(m_enemyBucket[i]);
					
					if ( enemy.active )
					{
						enemy.update(elapsedTime);
					}
					else
					{
						m_enemyGC.push(enemy);
					}
				}
			}
			
			// update garbage collector
			updateEnemyGC();
		}
		
		private function updateEnemyGC():void 
		{
			while( m_enemyGC.length > 0 )
			{
				var enemy:CBasePhysicEnemy = CBasePhysicEnemy(m_enemyGC.shift());
				var index:int = m_enemyBucket.indexOf(enemy);
				if ( index != -1 )
				{
					m_enemyBucket.splice(index, 1);
				}
				enemy.remove();
				enemy = null;
			}
		}
		
		private function spawnEnemy():void 
		{
			var enemy:CBasePhysicEnemy;
			var dice:int = Math.floor( OpMath.randomNumber(100) );
			
			
			if( dice > 95 )
			{
				enemy = new CEnemyPhysicPreman(RATIO, m_world, m_container);
			}
			else if ( dice > 85 )
			{
				enemy = new CEnemyPhysicBalonJenggot(RATIO, m_world, m_container);
			}
			else if ( dice > 80 )
			{
				enemy = new CEnemyPhysicBalonBotak(RATIO, m_world, m_container);
			}
			else if (dice > 50 )
			{
				enemy = new CEnemyPhysicJenggot(RATIO, m_world, m_container);
			}
			else
			{
				enemy = new CEnemyPhysicKumis(RATIO, m_world, m_container);
			}
			
			
			m_enemyBucket.push(enemy);
		}
		
		private function updateBullets(elapsedTime:int):void 
		{
			if( m_bulletBucket.length > 0 )
			{
				for ( var i:int = 0; i < m_bulletBucket.length; i++ )
				{
					var bullet:CBasePhysicBullet = m_bulletBucket[i];
					
					if( bullet.active )
						bullet.update(elapsedTime);
					else
					{
						m_bulletGC.push(bullet);
					}
				}
			}
		}
		
		private function updateBulletGC():void 
		{
			while( m_bulletGC.length > 0 )
			{
				var bullet:CBasePhysicBullet = CBasePhysicBullet(m_bulletGC.shift());
				var index:int = m_bulletBucket.indexOf(bullet);
				if ( index != -1 )
				{
					m_bulletBucket.splice(index, 1);
				}
				bullet.remove();
				bullet = null;
			}
		}
		
		private function clipCamera():void 
		{
			// HORIZONTAL CLIPPING
			if( m_camera.x < m_cameraHalfWidth )
			{
				m_camera.x = m_cameraHalfWidth;
			}
			else if( m_camera.x > WORLD_LENGTH - m_cameraHalfWidth )
			{
				m_camera.x = WORLD_LENGTH - m_cameraHalfWidth;
			}
			
			// VERTICAL ALIGN
			m_camera.y = 500 - m_cameraHalfHeight;
		}
		
		public function get world():b2World 
		{
			return m_world;
		}
		
		public function get camera():CVirtualCamera
		{
			return m_camera;
		}
	}
}

class SingletonLock{}