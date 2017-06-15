package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.system.Capabilities;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class Preloader extends MovieClip 
	{
		
		private var m_flashRequired:flashPlayer_reminder;
		private var play_tick:int = 0;
		
		public function Preloader() 
		{
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			// show loader
			if (getPlayerMajorVersionNumber() < 10)
			{
				m_flashRequired = new flashPlayer_reminder();
				addChild(m_flashRequired);
				m_flashRequired.flashLink.dummy.alpha = 0;
				m_flashRequired.flashLink.buttonMode = m_flashRequired.flashLink.useHandCursor = true;
				m_flashRequired.flashLink.addEventListener(MouseEvent.CLICK , flashLinkClicked);
			}
			else
			{
				showPreloader();
			}
			
			//Screen_Preloader.Btn_Play.visible = false;
		}
		
		protected function showPreloader():void
		{
			//to be inherited
		}
		
		private function getPlayerMajorVersionNumber():int
		{
			var ver:String = Capabilities.version;
		   
			trace("Version:", ver);
		   
			var firstSpace:int = ver.indexOf(" ");
			var firstComma:int = ver.indexOf(",");
		   
		   
			trace("First Space:", firstSpace);
			trace("First Comma:", firstComma);
		   
			var majorVer:String = ver.substring(firstSpace, firstComma);
			trace("Major Ver:", majorVer);
		   
			return int(majorVer);
		}
		private function flashLinkClicked(event:MouseEvent):void
		{
			navigateTo("http://get.adobe.com/flashplayer/");
		}
		protected function linkClicked(event:MouseEvent):void
		{
			navigateTo("http://www.nextplay.com/?utm_medium=brandedgames_external&utm_campaign=teelonians&utm_source=ingame&utm_content=ingame");
			//navigateTo("http://www.andkon.com/arcade/");
			//navigateTo("http://www.kongregate.com/");
			//navigateTo("http://armorgames.com")
		}
		private function navigateTo(url:String):void
		{
			var request:URLRequest = new URLRequest(url);
			navigateToURL(request);
		}
		
		protected function progress(e:ProgressEvent):void 
		{
			var percentLoad:Number = e.bytesLoaded / e.bytesTotal * 100;
			updateProgress(percentLoad);
		}
		
		protected function updateProgress(val:Number):void
		{
			//to be inherited
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				//removeEventListener(Event.ENTER_FRAME, checkFrame);
				play_tick ++;
				if (play_tick > 20)
				{
					play_tick = 0;
					removeEventListener(Event.ENTER_FRAME, checkFrame);
					startup();
				}
				//startup();
			}
		}
		
		protected function removePreloader():void
		{
			//to be inherited
		}
		
		protected function startup():void 
		{
			// hide loader
			TweenMax.killAll();
			
			//Screen_Preloader.Btn_Play.removeEventListener(MouseEvent.CLICK, playGame);
			removePreloader();
			
			stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
		private function playGame(e:MouseEvent):void
		{
			startup();
		}
	}
	
}