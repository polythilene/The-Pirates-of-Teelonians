package  
{
	/**
	 * ...
	 * @author Matthius Andy
	 */
	
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	 
	public class Preloader_Teelos extends Preloader
	{
		
		private var m_screenPreloader:mc_ScreenPreloader;
		
		public function Preloader_Teelos() 
		{
			

		}
		
		override protected function showPreloader():void 
		{
			super.showPreloader();
			m_screenPreloader = new mc_ScreenPreloader();
			addChild(m_screenPreloader);			
		}
		
		override protected function updateProgress(val:Number):void 
		{
			super.updateProgress(val);
			// update loader
			if (m_screenPreloader != null)
			{
				m_screenPreloader.percent.text = String(Math.floor(val)) + " %";
				
				var framePos:int = val / 100 * m_screenPreloader.loading_Bar.totalFrames;
				TweenMax.killTweensOf( m_screenPreloader.loading_Bar );
				TweenMax.to( m_screenPreloader.loading_Bar, 0.5, { frame:framePos } );
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