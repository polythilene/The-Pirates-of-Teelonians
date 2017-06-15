package  
{

	/**
	 * ...
	 * @author Matthius Andy
	 */
	//import BalloonTown.CUnemployed;
	
	//import FramerateTracker;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.StageQuality;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import math.OpMath;
	
	
	
	public class State_WinScreen extends CGameState
	{
		static private var m_instance:State_WinScreen;
		
		private var m_ScreenWin:mc_WinScreen;
		
		private var total_score:int;
		private var unit_bonus:int;
		private var kill_bonus:int;
		private var total_gold:int;
		
		private var counterUnit_done:Boolean;
		private var counterKill_done:Boolean;
		private var counterTotal_done:Boolean;
		private var counterTotalGold_done:Boolean;
		
		private var curr_unit_score:int		= 0;
		private var curr_kill_score:int		= 0;
		private var curr_total_score:int 	= 0;
		private var curr_total_gold:int		= 0;
		private var calculating:Boolean;
		private var random_tips:Array = new Array();
		
		
		static private const INCREMENT:int	= 30;
			
		//mouse flag
		private var isMouseClick:Boolean;
		
		private var m_mouseX:int;
		private var m_mouseY:int;
		
		private var m_bgm:CSoundObject;
		
		private var m_customCursor:mcCustomCursor;
		
		public function State_WinScreen(lock:SingletonLock)
		{
			
		}
		
		override public function initialize(owner:DisplayObjectContainer):void 
		{
			super.initialize(owner);
			
			//adding new object
			m_ScreenWin = new mc_WinScreen();
			//SoundManager.getInstance().addSFX("SN02", new SN02());
			//SoundManager.getInstance().addSFX("SN01", new SN01());
			m_customCursor = new mcCustomCursor();
			m_customCursor.mouseEnabled = m_customCursor.mouseChildren = false;			
			
			random_tips = ["Your troops will regain their health back when leveled up", "You can cancel your action by pressing 'ESC' key",
						   "Market is not always useful at the end..","Ageesum RAWKS ! LOLZ","Teemy is cheap and effective against enemy Rammer","All hail Rogus Flamanos !"];
			
		}
		override public function enter():void 
		{
			super.enter();
			
			Serializer.getInstance().saveData();
			
			counterKill_done = false;
			counterTotal_done = false;
			counterUnit_done = false;
			counterTotalGold_done = false;
			
			m_bgm = SoundManager.getInstance().playMusic("BM06", 1);
			
			m_owner.addChild(m_ScreenWin);
			
			m_ScreenWin.panel.randomtips_text.text = random_tips[Math.floor(OpMath.randomNumber(random_tips.length))];
			m_ScreenWin.panel.scaleX = m_ScreenWin.panel.scaleY = 0;
			m_ScreenWin.panel.ok_btn.gotoAndStop(1);
			m_ScreenWin.panel.cheatBtn.gotoAndStop(1);
			m_ScreenWin.panel.moregamesBtn.gotoAndStop(1);
			
			if (!GlobalVars.HACK)
			{
				//TweenMax.to(m_ScreenWin.cheatBtn , 0.25, {delay:0.3, x:m_ScreenWin.cheatBtn.x, y:-40, ease:Quint.easeOut } );
				m_ScreenWin.panel.cheatBtn.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				m_ScreenWin.panel.cheatBtn.addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
				m_ScreenWin.panel.cheatBtn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);				
				m_ScreenWin.panel.cheatBtn.addEventListener(MouseEvent.MOUSE_UP, playCheatMode);
			}
			
			//TweenMax.to(m_ScreenWin.moregamesBtn , 0.25, {delay:0.3, x: m_ScreenWin.moregamesBtn.x, y:-40, ease:Quint.easeOut } );
			m_ScreenWin.panel.moregamesBtn.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			m_ScreenWin.panel.moregamesBtn.addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			m_ScreenWin.panel.moregamesBtn.addEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);
			m_ScreenWin.panel.moregamesBtn.addEventListener(MouseEvent.MOUSE_UP, playMoreGames);
			
			TweenMax.to(m_ScreenWin.podium_grass , 0.25, { x:-28, y:418, ease:Quint.easeOut , onComplete:function():void {
				TweenMax.to(m_ScreenWin.podium , 0.25, { x:0, y:m_ScreenWin.podium.y, ease:Quint.easeOut , onComplete:function():void {
					TweenMax.to(m_ScreenWin.panel , 0.25, { scaleX:1, scaleY:1 , ease:Quint.easeOut , onComplete:function():void {
						calculating = true;
						} } );
					}});
			}})
			
			//Screen_Win.panel.unitbonus_txt.scaleX = 0.7;
			//Screen_Win.panel.unitbonus_txt.scaleY = 0.7;
			
			//passing score variables
			unit_bonus = GlobalVars.UNIT_BONUS;
			kill_bonus = GlobalVars.KILL_SCORE;
			total_score = unit_bonus + kill_bonus;
			total_gold = GlobalVars.TOTAL_COIN;
			
			//current score init
			curr_unit_score = 0;
			curr_kill_score = 0;
			curr_total_score = 0;
			
			m_ScreenWin.panel.mc_respoint.scaleX = m_ScreenWin.panel.mc_respoint.scaleY = 4;
			m_ScreenWin.panel.mc_respoint.alpha = 0;
			m_ScreenWin.panel.mc_respoint.respoint_txt.text = String(GlobalVars.RES_POINT_GAIN);
			
			m_ScreenWin.panel.mc_unitbonus.scaleX = m_ScreenWin.panel.mc_unitbonus.scaleY = 8;
			m_ScreenWin.panel.mc_unitbonus.alpha = 0;
			m_ScreenWin.panel.mc_unitbonus.unitbonus_txt.text = String(curr_unit_score);
			
			m_ScreenWin.panel.mc_killscore.scaleX = m_ScreenWin.panel.mc_killscore.scaleY = 8;
			m_ScreenWin.panel.mc_killscore.alpha = 0;
			m_ScreenWin.panel.mc_killscore.killscore_txt.text = String(curr_kill_score);
			
			m_ScreenWin.panel.mc_totalscore.scaleX = m_ScreenWin.panel.mc_totalscore.scaleY = 8;
			m_ScreenWin.panel.mc_totalscore.alpha = 0;
			m_ScreenWin.panel.mc_totalscore.totalscore_txt.text = String(curr_total_score);
			
			m_ScreenWin.panel.mc_totalcoin.scaleX = m_ScreenWin.panel.mc_totalcoin.scaleY = 8;
			m_ScreenWin.panel.mc_totalcoin.alpha = 0;			
			m_ScreenWin.panel.mc_totalcoin.totalcoin_txt.text = String(curr_total_gold);
			
			
			//register button
			registerButton(m_ScreenWin.panel.ok_btn);
			registerButton(m_ScreenWin);
			
			stage.addChild(m_customCursor);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			
			toggleCustomCursor();
		
			
		}
		
		private function onStageMouseMove(event:MouseEvent):void
		{
			m_mouseX = event.stageX;
			m_mouseY = event.stageY;
		
			m_customCursor.x = m_mouseX;
			m_customCursor.y = m_mouseY;
		}
		
		private function toggleCustomCursor():void
		{
			if ( GlobalVars.CUSTOM_CURSOR )
			{
				m_customCursor.visible = true;
				Mouse.hide();
				m_customCursor.gotoAndStop(3);
				m_customCursor.x = stage.mouseX;
				m_customCursor.y = stage.mouseY;
				stage.setChildIndex(m_customCursor, stage.numChildren - 1);
				/*if ( m_state != STATE_SWAP_PHASE_01 && m_state != STATE_SWAP_PHASE_02 && m_state != STATE_RETREAT )
				{
					m_customCursor.gotoAndStop(3);
					m_customCursor.x = m_mouseX;
					m_customCursor.y = m_mouseY;
					stage.setChildIndex(m_customCursor, stage.numChildren - 1);
				}	*/
			}
			else
			{
				m_customCursor.visible = false;
				Mouse.show();
				/*if ( m_state != STATE_SWAP_PHASE_01 && m_state != STATE_SWAP_PHASE_02 && m_state != STATE_RETREAT )
				{
					m_customCursor.visible = false;
					Mouse.show();
				}*/
			}
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			scoring();
		}
		
		private function scoring():void
		{
			if (calculating)
			{
				TweenMax.killTweensOf(m_ScreenWin.panel.mc_respoint);
				TweenMax.to(m_ScreenWin.panel.mc_respoint, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut} );
				if (curr_unit_score < unit_bonus)
				{	
					TweenMax.killTweensOf(m_ScreenWin.panel.mc_unitbonus);
					TweenMax.to(m_ScreenWin.panel.mc_unitbonus, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut} );
					SoundManager.getInstance().playSFX("scorefx");
					curr_unit_score += (Math.ceil(String(unit_bonus).length / 2));
					m_ScreenWin.panel.mc_unitbonus.unitbonus_txt.text = String(curr_unit_score);
				}
				else
				{
					/////
					/**/
					TweenMax.killTweensOf(m_ScreenWin.panel.mc_unitbonus);
					TweenMax.to(m_ScreenWin.panel.mc_unitbonus, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut} );
					if (!counterUnit_done)
					{
						SoundManager.getInstance().playSFX("scoredone");
						counterUnit_done = true;
						curr_unit_score = unit_bonus;
						m_ScreenWin.panel.mc_unitbonus.unitbonus_txt.text = String(curr_unit_score);
					}
					/////
					if (curr_kill_score < kill_bonus)
					{
						TweenMax.killTweensOf(m_ScreenWin.panel.mc_killscore);
						TweenMax.to(m_ScreenWin.panel.mc_killscore, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut} );
						SoundManager.getInstance().playSFX("scorefx");
						curr_kill_score += (INCREMENT * (Math.ceil(String(kill_bonus).length / 2)));
						m_ScreenWin.panel.mc_killscore.killscore_txt.text = String(curr_kill_score);
					}
					else
					{
						TweenMax.killTweensOf(m_ScreenWin.panel.mc_killscore);
						TweenMax.to(m_ScreenWin.panel.mc_killscore, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut} );
						if (!counterKill_done)
						{
							SoundManager.getInstance().playSFX("scoredone");
							counterKill_done = true;
							curr_kill_score = kill_bonus;
							m_ScreenWin.panel.mc_killscore.killscore_txt.text = String(curr_kill_score);
						}
						
						if (curr_total_score < total_score)
						{
							TweenMax.killTweensOf(m_ScreenWin.panel.mc_totalscore);
							TweenMax.to(m_ScreenWin.panel.mc_totalscore, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut} );
							SoundManager.getInstance().playSFX("scorefx");
							curr_total_score += (INCREMENT * (Math.ceil(String(total_score).length / 2)));
							m_ScreenWin.panel.mc_totalscore.totalscore_txt.text = String(curr_total_score);
						}
						else
						{
							TweenMax.killTweensOf(m_ScreenWin.panel.mc_totalscore);
							TweenMax.to(m_ScreenWin.panel.mc_totalscore, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut} );
							if (!counterTotal_done)
							{
								SoundManager.getInstance().playSFX("scoredone");
								counterTotal_done = true;
								curr_total_score = total_score;
								m_ScreenWin.panel.mc_totalscore.totalscore_txt.text = String(curr_total_score);
							}
							
							if (curr_total_gold < total_gold)
							{
								TweenMax.killTweensOf(m_ScreenWin.panel.mc_totalcoin);
								TweenMax.to(m_ScreenWin.panel.mc_totalcoin, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut} );
								SoundManager.getInstance().playSFX("scorefx");
								curr_total_gold += (INCREMENT * (Math.ceil(String(total_gold).length / 2)));
								m_ScreenWin.panel.mc_totalcoin.totalcoin_txt.text = String(curr_total_gold);
							}
							else
							{
								TweenMax.killTweensOf(m_ScreenWin.panel.mc_totalcoin);
								TweenMax.to(m_ScreenWin.panel.mc_totalcoin, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut} );
								if (!counterTotalGold_done)
								{
									SoundManager.getInstance().playSFX("scoredone");
									counterTotalGold_done = true;
									curr_total_gold = total_gold;
									m_ScreenWin.panel.mc_totalcoin.totalcoin_txt.text = String(curr_total_gold);
								}
								
								calculating = false;
							}
						}
					}
				}
			}
		}
		
		override public function exit():void 
		{
			m_bgm.stop();
			m_owner.removeChild(m_ScreenWin);
			super.exit();
		}
		
		private function navigateTo(url:String):void
		{
			var request:URLRequest = new URLRequest(url);
			navigateToURL(request);
		}
		
		private function onMouseClick(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			
			SoundManager.getInstance().playSFX("SN01");

			switch(mc)
			{
				case m_ScreenWin.panel.ok_btn:
				mc.gotoAndStop(2);
				isMouseClick = true;
				break;
				case m_ScreenWin.panel.moregamesBtn:
				mc.gotoAndStop(2);
				break;
				case m_ScreenWin.panel.cheatBtn:
				mc.gotoAndStop(2);
				break;
			}
		}
		
		
		private function registerButton(mc:MovieClip):void
		{
			mc.buttonMode = true;
			mc.useHandCursor = true;
            
			mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);
			mc.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mc.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			mc.addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
		}
		private function unregisterButton(mc:MovieClip):void
		{
			mc.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);
			mc.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
			mc.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			mc.removeEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
		}
      
		
		private function onMouseOver(event:MouseEvent):void
		{
			/*var mc:MovieClip = MovieClip(event.currentTarget);
			
			mc.gotoAndStop(2);
			
			SoundManager.getInstance().sfxVolume = 3;
			m_sfx = SoundManager.getInstance().playSFX("SFX_BtnRollover");*/
			//trace("rollover");
			var mc:MovieClip = MovieClip(event.currentTarget);
			SoundManager.getInstance().playSFX("SN02");
			switch(mc)
			{
				case m_ScreenWin.panel.ok_btn:
				TweenMax.to(mc, 0.15, {glowFilter:{color:0x996600, alpha:1, blurX:10, blurY:10,strength:1.5, quality:3}});
				break;
				case m_ScreenWin.panel.moregamesBtn:
				TweenMax.to(mc, 0.15, {glowFilter:{color:0x996600, alpha:1, blurX:10, blurY:10,strength:1.5, quality:3}});
				break;
				case m_ScreenWin.panel.cheatBtn:
				TweenMax.to(mc, 0.15, {glowFilter:{color:0x996600, alpha:1, blurX:10, blurY:10,strength:1.5, quality:3}});
				break;
			}
		}
               
		private function onMouseLeave(event:MouseEvent):void
		{
			//trace("rollout");

			var mc:MovieClip = MovieClip(event.currentTarget);
			switch(mc)
			{
				case m_ScreenWin.panel.ok_btn:
				TweenMax.to(mc, 0.15, {glowFilter:{color:0x996600, alpha:0, blurX:10, blurY:10,strength:1.5, quality:3}});
				break;
				case m_ScreenWin.panel.moregamesBtn:
				TweenMax.to(mc, 0.15, {glowFilter:{color:0x996600, alpha:0, blurX:10, blurY:10,strength:2, quality:3}});
				break;
				case m_ScreenWin.panel.cheatBtn:
				TweenMax.to(mc, 0.15, {glowFilter:{color:0x996600, alpha:0, blurX:10, blurY:10,strength:2, quality:3}});
				break;
			}
		}
		private function playMoreGames(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			mc.gotoAndStop(1);
			
			navigateTo("http://www.nextplay.com/?utm_medium=brandedgames_external&utm_campaign=teelonians&utm_source=ingame&utm_content=ingame");
		}
		private function playCheatMode(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			mc.gotoAndStop(1);
			
			navigateTo("http://www.prehackshub.com/arcade/3323/Teelonians---The-Clan-Wars.html?utm_medium=brandedgames_external&utm_campaign=teelonians&utm_source=ingame&utm_content=ingame");
		}
		private function onMouseUp(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			
			mc.gotoAndStop(1);
			switch(mc)
			{
				case m_ScreenWin.panel.ok_btn:
				if (!calculating)
				{
					if (!GlobalVars.HACK)
					{
						//TweenMax.to(m_ScreenWin.cheatBtn , 0.25, {delay:0.1, x:m_ScreenWin.cheatBtn.x, y:-100, ease:Quint.easeOut } );
						m_ScreenWin.panel.cheatBtn.removeEventListener(MouseEvent.MOUSE_UP, playCheatMode);
					}
				
					//TweenMax.to(m_ScreenWin.moregamesBtn , 0.25, {delay:0.1 , x: m_ScreenWin.moregamesBtn.x, y:-100, ease:Quint.easeOut } );
					m_ScreenWin.panel.moregamesBtn.removeEventListener(MouseEvent.MOUSE_UP, playMoreGames);
					
					TweenMax.to(m_ScreenWin.panel , 0.25, { scaleX:0, scaleY:0 , ease:Quint.easeOut, onComplete:function():void {
					TweenMax.to(m_ScreenWin.podium , 0.25, { x:-300, y:0, ease:Quint.easeOut , onComplete:function():void {
						TweenMax.to(m_ScreenWin.podium_grass , 0.25, { x:-28, y:500, ease:Quint.easeOut , onComplete:function():void {
							GameStateManager.getInstance().setState(State_ScoutScreen.getInstance());
							}} );
						}});
					}})
					
				}
				break;
				case m_ScreenWin:
				if (calculating)
				{
					calculating = false;
					TweenMax.killTweensOf(m_ScreenWin.panel.mc_unitbonus);
					TweenMax.to(m_ScreenWin.panel.mc_unitbonus, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut } );
					
					TweenMax.killTweensOf(m_ScreenWin.panel.mc_killscore);
					TweenMax.to(m_ScreenWin.panel.mc_killscore, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut } );
					
					TweenMax.killTweensOf(m_ScreenWin.panel.mc_totalscore);
					TweenMax.to(m_ScreenWin.panel.mc_totalscore, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut } );
					
					TweenMax.killTweensOf(m_ScreenWin.panel.mc_totalcoin);
					TweenMax.to(m_ScreenWin.panel.mc_totalcoin, 0.5, { scaleX:1, scaleY:1, alpha:1, ease:Back.easeOut } );
					
					m_ScreenWin.panel.mc_unitbonus.unitbonus_txt.text 	= String(unit_bonus);
					m_ScreenWin.panel.mc_killscore.killscore_txt.text 	= String(kill_bonus);
					m_ScreenWin.panel.mc_totalscore.totalscore_txt.text 	= String(total_score);
					m_ScreenWin.panel.mc_totalcoin.totalcoin_txt.text 	= String(total_gold);
				}
				break;
			}
			/*if (!calculating)
			{
				TweenMax.to(Screen_Win.panel , 0.25, { scaleX:0, scaleY:0 , ease:Quint.easeOut, onComplete:function():void {
				TweenMax.to(Screen_Win.podium , 0.25, { x:-300, y:0, ease:Quint.easeOut , onComplete:function():void {
					TweenMax.to(Screen_Win.podium_grass , 0.25, { x:-28, y:500, ease:Quint.easeOut , onComplete:function():void {
						GameStateManager.getInstance().setState(State_ScoutScreen.getInstance());
						}} );
					}});
				}})
				
			}
			else
			{
				calculating = false;
				Screen_Win.panel.unitbonus_txt.text 	= String(unit_bonus);
				Screen_Win.panel.killscore_txt.text 	= String(kill_bonus);
				Screen_Win.panel.totalscore_txt.text 	= String(total_score);
			}*/
			
		}
		
		private function startDragging(e:MouseEvent):void
		{
			var rect:Rectangle = new Rectangle(0, 0, 100, 0);
			e.currentTarget.startDrag(false, rect)
		}
		private function setVolume():void
		{
			/*var vol:Number = mc_ScreenOptions.volume_bar.slider_music.x / 100;
			
			SoundManager.getInstance().musicVolume = vol;*/
		}
		
		private function doneSetVol(e:MouseEvent):void
		{
			//e.currentTarget.stopDrag();
		}
		private function setCustomCursor(e:MouseEvent):void
		{
			/*useCursor = true;
			mc_ScreenOptions.select_NO.visible = false;
			mc_ScreenOptions.select_YES.visible = true;
			Mouse.hide();
			customCursor = new cursor();
			stage.addChild(customCursor);*/
		}
		private function removeCustomCursor(e:MouseEvent):void
		{
			/*useCursor = false;
			mc_ScreenOptions.select_NO.visible = true;
			mc_ScreenOptions.select_YES.visible = false;
			stage.removeChild(customCursor);
			customCursor = null;
			Mouse.show();*/
			
		}
		private function setQualityLOW(e:MouseEvent):void
		{
			stage.quality = StageQuality.LOW;
			//mc_ScreenOptions.slider.x = mc_ScreenOptions.LOW_quality.x;
			
		}
		private function setQualityMED(e:MouseEvent):void
		{
			stage.quality = StageQuality.MEDIUM;
			//mc_ScreenOptions.slider.x = mc_ScreenOptions.MED_quality.x;
		}
		private function setQualityHIGH(e:MouseEvent):void
		{
			stage.quality = StageQuality.HIGH;
			//mc_ScreenOptions.slider.x = mc_ScreenOptions.HIGH_quality.x;
		}
		
		
		
		/* ============================
		 * 			SINGLETON
		 * ============================
		*/
		
		static public function getInstance(): State_WinScreen
		{
			if ( m_instance == null )
			{
				m_instance = new State_WinScreen( new SingletonLock() );
			}
			return m_instance;
		}
	}

}
class SingletonLock{}