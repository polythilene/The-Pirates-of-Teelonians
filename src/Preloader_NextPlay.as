package  
{
	/**
	 * ...
	 * @author Matthius Andy
	 */
	import flash.display.DisplayObject;	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import flash.events.MouseEvent;
	 
	public class Preloader_NextPlay extends Preloader
	{
		
		private var m_screenPreloader:mc_ScreenPreloaderNextPlay;
		
		public function Preloader_NextPlay() 
		{
			

		}
		
		override protected function showPreloader():void 
		{
			super.showPreloader();
			m_screenPreloader = new mc_ScreenPreloaderNextPlay();
			addChild(m_screenPreloader);			
			m_screenPreloader.x = 400;
			m_screenPreloader.y = 250;
			
			m_screenPreloader.logoButton.addEventListener(MouseEvent.CLICK, linkClicked);
		}
		
		override protected function startup():void 
		{
			// hide loader
			m_screenPreloader.nextplayLogo.gotoAndStop(2);
			m_screenPreloader.nextplayLogo.playButton.addEventListener(MouseEvent.CLICK, startgame);
		}
		
		private function startgame(event:MouseEvent):void
		{
			TweenMax.killAll();
			
			//Screen_Preloader.Btn_Play.removeEventListener(MouseEvent.CLICK, playGame);
			m_screenPreloader.logoButton.removeEventListener(MouseEvent.CLICK, linkClicked);
			m_screenPreloader.nextplayLogo.playButton.removeEventListener(MouseEvent.CLICK, startgame);
			removePreloader();
			
			stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as DisplayObject);
		
		}
		
		override protected function updateProgress(val:Number):void 
		{
			super.updateProgress(val);
			// update loader
			if (m_screenPreloader != null)
			{
				//m_screenPreloader.percent.text = String(Math.floor(val)) + " %";
				
				var framePos:int = val / 100 * m_screenPreloader.nextplayLogo.loadingBar.totalFrames;
				TweenMax.killTweensOf( m_screenPreloader.nextplayLogo.loadingBar );
				TweenMax.to( m_screenPreloader.nextplayLogo.loadingBar, 0.5, { frame:framePos } );
			}
		}
		
		override protected function removePreloader():void 
		{
			super.removePreloader();
			removeChild(m_screenPreloader);
			m_screenPreloader = null;			
		}
	}

}