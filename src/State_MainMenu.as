package  
{
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.display.StageQuality;
	
	public class State_MainMenu extends CGameState
	{
		static private var m_instance:State_MainMenu;
		private var m_ScreenMainMenu:mcMainMenu;
		private var m_delay:Timer;
		private var m_dragTarget:MovieClip;
		private var m_volumeSliderRect:Rectangle;
		private var m_dragging:Boolean;
		
		public function State_MainMenu(lock:SingletonLock)
		{
			
		}
		
		override public function initialize(owner:DisplayObjectContainer):void 
		{
			super.initialize(owner);
			
			//create new object
			m_ScreenMainMenu = new mcMainMenu();
			m_ScreenMainMenu.mcOptionPlate.sfx_NO.visible = false;
			m_ScreenMainMenu.mcOptionPlate.kursor_NO.visible = false;
			
			m_ScreenMainMenu.mcOptionPlate.YES_button_sfx.visible = false;
			m_ScreenMainMenu.mcOptionPlate.YES_button_cursor.visible = false;
			
			var rect:Rectangle = new Rectangle( 0, 0, 217, 31 );
			m_volumeSliderRect = new Rectangle(	rect.x, 
												m_ScreenMainMenu.mcOptionPlate.volume_bar.slider_music.y,
												rect.width - 20, 0 );
												
			m_delay = new Timer(1000);
			
		}
		
		override public function enter():void 
		{
			super.enter();
		
			m_owner.addChild(m_ScreenMainMenu);
			
			TweenMax.to(m_ScreenMainMenu, 0.5, { removeTint:true } );
			
			//m_ScreenMainMenu.mcContinue.visible = Serializer.getInstance().dataExists();
			
			m_ScreenMainMenu.mcTitle.scaleX = m_ScreenMainMenu.mcTitle.scaleY = 
			m_ScreenMainMenu.mcContinue.scaleX = m_ScreenMainMenu.mcContinue.scaleY = 
			m_ScreenMainMenu.mcNewGame.scaleX = m_ScreenMainMenu.mcNewGame.scaleY = 
			m_ScreenMainMenu.mcCredits.scaleX = m_ScreenMainMenu.mcCredits.scaleY = 
			m_ScreenMainMenu.mcOptions.scaleX = m_ScreenMainMenu.mcOptions.scaleY = 
			m_ScreenMainMenu.mcMoreGames.scaleX = m_ScreenMainMenu.mcMoreGames.scaleY = 3;
			
			m_ScreenMainMenu.mcTitle.alpha = 
			m_ScreenMainMenu.mcContinue.alpha = 
			m_ScreenMainMenu.mcNewGame.alpha = 
			m_ScreenMainMenu.mcCredits.alpha = 
			m_ScreenMainMenu.mcOptions.alpha = 
			m_ScreenMainMenu.mcMoreGames.alpha = 0;
			
			m_ScreenMainMenu.mcOptionPlate.y = -311.85;
			m_ScreenMainMenu.mcCreditScreen.visible = false;
			
			m_delay.reset();
			m_delay.addEventListener(TimerEvent.TIMER, onDelayEnd);
			m_delay.start();
		}
		
		private function onDelayEnd(event:TimerEvent):void
		{
			m_delay.removeEventListener(TimerEvent.TIMER, onDelayEnd);
			
			TweenMax.to(m_ScreenMainMenu.mcTitle, 0.25, { scaleX:1, scaleY:1, alpha:1 } );
			
			//if(Serializer.getInstance().dataExists() )
			//{
				TweenMax.to(m_ScreenMainMenu.mcContinue, 0.5, { scaleX:1, scaleY:1, delay:0.2, alpha:1 } );
			//}
			
			TweenMax.to(m_ScreenMainMenu.mcNewGame, 0.25, { scaleX:1, scaleY:1, delay:0.4, alpha:1 } );
			TweenMax.to(m_ScreenMainMenu.mcCredits, 0.25, { scaleX:1, scaleY:1, delay:0.6, alpha:1 } );
			TweenMax.to(m_ScreenMainMenu.mcOptions, 0.25, { scaleX:1, scaleY:1, delay:0.8, alpha:1 } );
			TweenMax.to(m_ScreenMainMenu.mcMoreGames, 0.25, { scaleX:1, scaleY:1, delay:1, alpha:1, onComplete:function():void { registerEvents(); }  } );
		}
		
		private function flyOut():void
		{
			TweenMax.to(m_ScreenMainMenu.mcTitle, 0.25, { scaleX:3, scaleY:3, alpha:0 } );
			
			//if(Serializer.getInstance().dataExists() )
			//{
				TweenMax.to(m_ScreenMainMenu.mcContinue, 0.5, { scaleX:3, scaleY:3, delay:0.2, alpha:0 } );
			//}
			
			TweenMax.to(m_ScreenMainMenu.mcNewGame, 0.25, { scaleX:3, scaleY:3, delay:0.4, alpha:0 } );
			TweenMax.to(m_ScreenMainMenu.mcCredits, 0.25, { scaleX:3, scaleY:3, delay:0.6, alpha:0 } );
			TweenMax.to(m_ScreenMainMenu.mcOptions, 0.25, { scaleX:3, scaleY:3, delay:0.8, alpha:0 } );
			TweenMax.to(m_ScreenMainMenu.mcMoreGames, 0.25, { scaleX:3, scaleY:3, delay:1, alpha:0 } );
		}
		
		private function toggleOptions(visible:Boolean):void
		{
			if (visible)
			{
				TweenMax.to(m_ScreenMainMenu.mcOptionPlate, 0.5, { y:94.25, ease:Back.easeOut } );
			}
			else
			{
				TweenMax.to(m_ScreenMainMenu.mcOptionPlate, 0.5, { y:-311.85, ease:Back.easeIn } );
			}
		}
		
		private function registerEvents():void
		{
			registerButton( m_ScreenMainMenu.mcContinue );
			registerButton( m_ScreenMainMenu.mcNewGame );
			registerButton( m_ScreenMainMenu.mcCredits );
			registerButton( m_ScreenMainMenu.mcOptions );
			registerButton( m_ScreenMainMenu.mcMoreGames );
			
			registerButton( m_ScreenMainMenu.mcOptionPlate.YES_button_sfx );
			registerButton( m_ScreenMainMenu.mcOptionPlate.NO_button_sfx );
			
			registerButton( m_ScreenMainMenu.mcOptionPlate.YES_button_cursor );
			registerButton( m_ScreenMainMenu.mcOptionPlate.NO_button_cursor );
			
			registerButton( m_ScreenMainMenu.mcOptionPlate.mcBack );
			registerButton( m_ScreenMainMenu.mcCreditScreen.mcBackToMenu );
			
			registerButton( m_ScreenMainMenu.mcOptionPlate.volume_bar.slider_music );
			stage.addEventListener(MouseEvent.MOUSE_UP, volumeOptionsMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, volumeOptionsMouseMove);
			
			registerButton( m_ScreenMainMenu.mcOptionPlate.LOW_quality );
			registerButton( m_ScreenMainMenu.mcOptionPlate.MEDIUM_quality );
			registerButton( m_ScreenMainMenu.mcOptionPlate.HIGH_quality );
		}
		
		private function unregisterEvents():void
		{
			unregisterButton( m_ScreenMainMenu.mcContinue );
			unregisterButton( m_ScreenMainMenu.mcNewGame ); 
			unregisterButton( m_ScreenMainMenu.mcCredits );
			unregisterButton( m_ScreenMainMenu.mcOptions );
			unregisterButton( m_ScreenMainMenu.mcMoreGames );
			
			unregisterButton( m_ScreenMainMenu.mcOptionPlate.mcBack );
			unregisterButton( m_ScreenMainMenu.mcCreditScreen.mcBackToMenu );
			
			unregisterButton( m_ScreenMainMenu.mcOptionPlate.YES_button_sfx );
			unregisterButton( m_ScreenMainMenu.mcOptionPlate.NO_button_sfx );
			
			unregisterButton( m_ScreenMainMenu.mcOptionPlate.YES_button_cursor );
			unregisterButton( m_ScreenMainMenu.mcOptionPlate.NO_button_cursor );
			
			unregisterButton( m_ScreenMainMenu.mcOptionPlate.volume_bar.slider_music );
			stage.removeEventListener(MouseEvent.MOUSE_UP, volumeOptionsMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, volumeOptionsMouseMove);
			
			unregisterButton( m_ScreenMainMenu.mcOptionPlate.LOW_quality );
			unregisterButton( m_ScreenMainMenu.mcOptionPlate.MEDIUM_quality );
			unregisterButton( m_ScreenMainMenu.mcOptionPlate.HIGH_quality );
		}
		
		override public function exit():void 
		{
			m_owner.removeChild(m_ScreenMainMenu);
			super.exit();
		}
			
		private function registerButton(mc:MovieClip):void
		{
			mc.buttonMode = true;
			mc.useHandCursor = true;
         
			mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			mc.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mc.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			mc.addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
		}
		private function unregisterButton(mc:MovieClip):void
		{
			mc.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			mc.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
			mc.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			mc.removeEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
		}
      
		private function onMouseOver(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			
			if( mc != m_ScreenMainMenu.mcOptionPlate.mcBack )
				TweenMax.to( mc, 0.5, { scaleX:1.2, scaleY:1.2, ease:Bounce.easeOut } );
		}
               
		private function onMouseLeave(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			
			if( mc != m_ScreenMainMenu.mcOptionPlate.mcBack )
				TweenMax.to( mc, 0.5, { scaleX:1, scaleY:1, ease:Bounce.easeOut } );
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			
			if ( mc != m_ScreenMainMenu.mcOptionPlate.volume_bar.slider_music )
			{
				mc.scaleX = mc.scaleY = 1;
			}
			
			if ( mc == m_ScreenMainMenu.mcOptionPlate.volume_bar.slider_music )
			{
				mc.startDrag(false,m_volumeSliderRect);
				m_dragTarget = mc;
				m_dragging = true;
			}
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			
			if ( mc == m_ScreenMainMenu.mcNewGame )
			{
				unregisterEvents();
				toggleOptions(false);
				flyOut();
				TweenMax.to(m_ScreenMainMenu, 1.0, { tint:0x000000, delay:1, onComplete:function():void 
													 { 
														GameStateManager.getInstance().setState( State_GameLoop.getInstance() );
													 } 
												   } );
			}
			else if ( mc == m_ScreenMainMenu.mcOptions )
			{
				toggleOptions(true);
			}
			else if ( mc == m_ScreenMainMenu.mcCredits )
			{
				m_ScreenMainMenu.mcCreditScreen.alpha = 0;
				m_ScreenMainMenu.mcCreditScreen.visible = true;
				m_ScreenMainMenu.mcCreditScreen.mcNameList.y = 510.45;
				
				TweenMax.to(m_ScreenMainMenu.mcCreditScreen, 1.0, { alpha:1 } );
			}
			else if ( mc == m_ScreenMainMenu.mcCreditScreen.mcBackToMenu )
			{
				TweenMax.to(m_ScreenMainMenu.mcCreditScreen, 1.0, { alpha:0, onComplete:function():void
																	{
																		m_ScreenMainMenu.mcCreditScreen.visible = false;
																		TweenMax.to(m_ScreenMainMenu, 0.2, { removeTint:true } );
																	}
																  } );
			}
			else if ( mc == m_ScreenMainMenu.mcOptionPlate.mcBack )
			{
				toggleOptions(false);
			}
			
			// options
			else if ( mc == m_ScreenMainMenu.mcOptionPlate.YES_button_sfx )
			{
				m_ScreenMainMenu.mcOptionPlate.sfx_YES.visible = true;
				m_ScreenMainMenu.mcOptionPlate.sfx_NO.visible = false;
				m_ScreenMainMenu.mcOptionPlate.YES_button_sfx.visible = false;
				m_ScreenMainMenu.mcOptionPlate.NO_button_sfx.visible = true;
				 
				SoundManager.getInstance().sfxEnable = true;
			}
			else if ( mc == m_ScreenMainMenu.mcOptionPlate.NO_button_sfx )
			{
				m_ScreenMainMenu.mcOptionPlate.sfx_YES.visible = false;
				m_ScreenMainMenu.mcOptionPlate.sfx_NO.visible = true;
				m_ScreenMainMenu.mcOptionPlate.YES_button_sfx.visible = true;
				m_ScreenMainMenu.mcOptionPlate.NO_button_sfx.visible = false;
				 
				SoundManager.getInstance().sfxEnable = false;
			}
			
			
			else if ( mc == m_ScreenMainMenu.mcOptionPlate.YES_button_cursor )
			{
				m_ScreenMainMenu.mcOptionPlate.kursor_YES.visible = true;
				m_ScreenMainMenu.mcOptionPlate.kursor_NO.visible = false;
				m_ScreenMainMenu.mcOptionPlate.YES_button_cursor.visible = false;
				m_ScreenMainMenu.mcOptionPlate.NO_button_cursor.visible = true;
			}
			else if ( mc == m_ScreenMainMenu.mcOptionPlate.NO_button_cursor )
			{
				m_ScreenMainMenu.mcOptionPlate.kursor_YES.visible = false;
				m_ScreenMainMenu.mcOptionPlate.kursor_NO.visible = true;
				m_ScreenMainMenu.mcOptionPlate.YES_button_cursor.visible = true;
				m_ScreenMainMenu.mcOptionPlate.NO_button_cursor.visible = false;
			}
			
			
			else if ( mc == m_ScreenMainMenu.mcOptionPlate.LOW_quality )
			{
				m_ScreenMainMenu.mcOptionPlate.slider.x = 238.7;
				
				stage.quality = StageQuality.LOW;
				
				m_ScreenMainMenu.mcOptionPlate.LOW_quality.visible = false;
				m_ScreenMainMenu.mcOptionPlate.MEDIUM_quality.visible = true;
				m_ScreenMainMenu.mcOptionPlate.HIGH_quality.visible = true;
			}
			else if ( mc == m_ScreenMainMenu.mcOptionPlate.MEDIUM_quality )
			{
				m_ScreenMainMenu.mcOptionPlate.slider.x = 357.05;
				
				stage.quality = StageQuality.MEDIUM;
				
				m_ScreenMainMenu.mcOptionPlate.LOW_quality.visible = true;
				m_ScreenMainMenu.mcOptionPlate.MEDIUM_quality.visible = false;
				m_ScreenMainMenu.mcOptionPlate.HIGH_quality.visible = true;
			}
			else if ( mc == m_ScreenMainMenu.mcOptionPlate.HIGH_quality )
			{
				m_ScreenMainMenu.mcOptionPlate.slider.x = 475.05;
				
				stage.quality = StageQuality.BEST;
				
				m_ScreenMainMenu.mcOptionPlate.LOW_quality.visible = true;
				m_ScreenMainMenu.mcOptionPlate.MEDIUM_quality.visible = true;
				m_ScreenMainMenu.mcOptionPlate.HIGH_quality.visible = false;
			}
		}
		
		private function volumeOptionsMouseUp(event:MouseEvent):void
		{
			if ( m_dragging )
			{
				m_ScreenMainMenu.mcOptionPlate.volume_bar.slider_music.stopDrag();
				m_dragging = false;
			}
		}
		
		private function volumeOptionsMouseMove(event:MouseEvent):void
		{
			if( m_dragging )
			{
				// calculate percentage 
				var max:Number = Math.round(m_volumeSliderRect.width);
				var value:Number = Math.max(m_dragTarget.x - Math.round(m_volumeSliderRect.x), 0);
				value = Math.min(value, max);
				var percent:Number = percentage(value, max);
				
				SoundManager.getInstance().musicVolume = percent;
			}
		}
		
		private function percentage(value:Number, max:Number):Number
		{
			return (value / max);
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			if ( m_ScreenMainMenu.mcCreditScreen.visible )
			{
				m_ScreenMainMenu.mcCreditScreen.mcNameList.y -= elapsedTime * 0.03;
				if ( m_ScreenMainMenu.mcCreditScreen.mcNameList.y + m_ScreenMainMenu.mcCreditScreen.mcNameList.height < 0 )
				{
					m_ScreenMainMenu.mcCreditScreen.mcNameList.y = 510.45;
				}
			}
		}
		
		/* ============================
		 * 			SINGLETON
		 * ============================
		*/
		
		static public function getInstance(): State_MainMenu
		{
			if ( m_instance == null )
			{
				m_instance = new State_MainMenu( new SingletonLock() );
			}
			return m_instance;
		}
	}

}
class SingletonLock{}