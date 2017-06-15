package  
{

	/**
	 * ...
	 * @author Matthius Andy
	 */
	//import BalloonTown.CUnemployed;
	
	//import FramerateTracker;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.ui.Keyboard;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MorphShape;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.net.SharedObject;
	import flash.geom.Rectangle;
	import flash.display.StageQuality;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	import flash.system.Capabilities;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	
	public class State_TutorialScreen extends CGameState
	{
		static private var m_instance:State_TutorialScreen;
		
		private var m_mouseX:int;
		private var m_mouseY:int;
		private var m_customCursor:mcCustomCursor;
		
		private var m_bgm:CSoundObject;
		
		private var m_screenTutorial:mc_tutorialScreen;
		
		private var m_SkipTutorial:Boolean;
		
		public function State_TutorialScreen(lock:SingletonLock)
		{
			
		}
		
		override public function initialize(owner:DisplayObjectContainer):void 
		{
			super.initialize(owner);
			
			
			m_customCursor = new mcCustomCursor();
			m_customCursor.mouseEnabled = m_customCursor.mouseChildren = false;
		}
		override public function enter():void 
		{
			super.enter();
			
			m_SkipTutorial = false;
			
			m_bgm = SoundManager.getInstance().playMusic("BM05");
			m_screenTutorial = new mc_tutorialScreen();
			m_owner.addChild(m_screenTutorial);
			m_screenTutorial.x = 267;
			m_screenTutorial.y = 250;
			
			//m_screenTutorial.scene1.next_btn.alpha = 0;
			//registerButton(m_screenTutorial.scene1.next_btn);
			stage.addChild(m_customCursor);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			
			toggleCustomCursor();
		}
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			stage.setChildIndex(m_customCursor, stage.numChildren - 1);
			
			if (!m_SkipTutorial)
			{
				switch (m_screenTutorial.currentFrameLabel)
				{
					case "tutor_confirm":
					registerButton(m_screenTutorial.scene_confirm.yes_btn);
					registerButton(m_screenTutorial.scene_confirm.no_btn);				
					break;
					case "tutor1":
					//m_screenTutorial.scene1.next_btn.alpha = 0;
					registerButton(m_screenTutorial.scene1.next_btn);
					break;
					case "tutor2":
					//m_screenTutorial.scene2.next_btn.alpha = 0;
					registerButton(m_screenTutorial.scene2.next_btn);
					break;
					case "tutor3":
					if (m_screenTutorial.scene3.currentFrame < 2)
					{
						//m_screenTutorial.scene3.next_btn.alpha = 0;
						registerButton(m_screenTutorial.scene3.next_btn);
					}
					break;
					case "tutor4":
					if (m_screenTutorial.scene4.currentFrame < 12)
					{
						//m_screenTutorial.scene4.next_btn.alpha = 0;
						registerButton(m_screenTutorial.scene4.next_btn);
					}
					break;
					case "tutor5":
					if (m_screenTutorial.scene5.currentFrame < 13)
					{
						//m_screenTutorial.scene5.next_btn.alpha = 0;
						registerButton(m_screenTutorial.scene5.next_btn);
					}
					break;
					case "tutor6":
					if (m_screenTutorial.scene6.currentFrame < 13)
					{
						//m_screenTutorial.scene6.next_btn.alpha = 0;
						registerButton(m_screenTutorial.scene6.next_btn);
					}
					break;
					case "tutor7":
					if (m_screenTutorial.scene7.currentFrame < 13)
					{
						//m_screenTutorial.scene7.next_btn.alpha = 0;
						registerButton(m_screenTutorial.scene7.next_btn);
					}
					break;
				}
			
				if (m_screenTutorial.currentFrame == 8 && m_screenTutorial.scene7.tutorialDone)
				{
					GameStateManager.getInstance().setState(State_ScoutScreen.getInstance());
				}
			}
			else
			{
				if (m_screenTutorial.scene_confirm.prompt_done)
				{
					GameStateManager.getInstance().setState(State_ScoutScreen.getInstance());
				}
			}
			
			
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
		/*
		private function addText():void
		{
			m_firstWord++;
			var takeString:String = storyText[m_indexEvent][m_indexText].substr(0, m_firstWord);
			Screen_Story.panel.dialogtext.text = takeString;
			//Screen_Story.dialogPanel["dialogtext_" + m_indexText].text = takeString;
			if ((m_firstWord + 1) >= storyText[m_indexEvent][m_indexText].length) {
				m_firstWord = storyText[m_indexEvent][m_indexText].length - 1;
			}
		}
		*/
		
		override public function exit():void 
		{
			m_bgm.stop();
			m_owner.removeChild(m_screenTutorial);
			m_screenTutorial = null;
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
			
			mc.gotoAndStop(2);
			
		}
		
		
		private function registerButton(mc:MovieClip):void
		{
			mc.buttonMode = true;
			mc.useHandCursor = true;
            
			mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);
			mc.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			mc.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			mc.addEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			mc.addEventListener(MouseEvent.MOUSE_OUT, onMouseClickLeave);
		}
		private function unregisterButton(mc:MovieClip):void
		{
			mc.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);
			mc.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
			mc.removeEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			mc.removeEventListener(MouseEvent.ROLL_OUT, onMouseLeave);
			mc.removeEventListener(MouseEvent.MOUSE_OUT, onMouseClickLeave);	
		}
      
		private function onMouseClickLeave(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			mc.gotoAndStop(1);
		}
		
		private function onMouseOver(event:MouseEvent):void
		{	
			var mc:MovieClip = MovieClip(event.currentTarget);
			
			TweenMax.to(mc, 0.15, {glowFilter:{color:0x996600, alpha:1, blurX:10, blurY:10,strength:1.5, quality:3}});
			/*if (m_screenTutorial.currentFrameLabel == "tutor_confirm")
			{
				m_screenTutorial.scene_confirm.sign.x = mc.x;
			}*/
			SoundManager.getInstance().playSFX("SN02");
		}
               
		private function onMouseLeave(event:MouseEvent):void
		{
			//trace("rollout");

			var mc:MovieClip = MovieClip(event.currentTarget);
						
			TweenMax.to(mc, 0.25, {glowFilter:{alpha:0}});
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(event.currentTarget);
			mc.gotoAndStop(1);
			switch (m_screenTutorial.currentFrameLabel)
			{
				
				case "tutor_confirm":
				if (mc == m_screenTutorial.scene_confirm.yes_btn)
				{
					m_SkipTutorial = false;
					m_screenTutorial.gotoAndStop("tutor1");
				}
				else
				{
					m_screenTutorial.scene_confirm.play();
					m_SkipTutorial = true;
				}
				break;
				case "tutor1":
				m_screenTutorial.scene1.play();
				break;
				case "tutor2":
				m_screenTutorial.nextFrame();
				break;
				case "tutor3":
				m_screenTutorial.scene3.play();
				break;
				case "tutor4":
				m_screenTutorial.scene4.play();
				break;
				case "tutor5":
				m_screenTutorial.scene5.play();
				break;
				case "tutor6":
				m_screenTutorial.scene6.play();
				break;
				case "tutor7":
				m_screenTutorial.scene7.play();
				break;
			}
			
		}
		
	
		
		/* ============================
		 * 			SINGLETON
		 * ============================
		*/
		
		static public function getInstance(): State_TutorialScreen
		{
			if ( m_instance == null )
			{
				m_instance = new State_TutorialScreen( new SingletonLock() );
			}
			return m_instance;
		}
	}

}
class SingletonLock{}