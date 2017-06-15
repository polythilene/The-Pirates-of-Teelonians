package  
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class CVirtualCamera extends VirtualCamera
	{
	
		protected var m_lastTarget:Point;
		
		private var m_posX:int;
		private var m_posY:int;
		
		protected var m_shaking:Boolean;
		protected var m_shakeOffSetX:Number=0;
		protected var m_shakeOffSetY:Number = 0;
		protected var m_shake:Number = 0;
		protected var m_shakeFric:Number = 0.9;
		protected var m_shakeDir:int = 1;
		
		public function CVirtualCamera() 
		{
			m_lastTarget = new Point();
		}
		
		public function setCameraTarget(pos_x:Number, pos_y:Number):void
		{
			m_posX = pos_x;
			m_posY = pos_y;
			
			x = m_posX;
			y = m_posY;
		}
		
		public function getLastTargetPointOffsetX():int
		{
			return Math.floor(x - m_lastTarget.x);
		}
		
		public function getLastTargetPointOffsetY():int
		{
			return Math.floor(y - m_lastTarget.y);
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;	
			m_lastTarget.x = value;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			m_lastTarget.y = value;
		}
		
		public function shake( shakeValue:Number, shakeCap:int ):void 
		{
			if( m_shake < shakeCap )
				m_shake += shakeValue;
			
			m_shaking = true;
		}
		
		public function isShaking():Boolean 
		{
			return m_shaking;
		}
		
		public function update(elapsedTime:int):void 
		{
			if( m_shaking ) 
			{
				if( m_shake < 0.6 ) 
				{
	        		m_shake = 0.0;
					m_shakeOffSetX = 0.0;
					m_shakeOffSetY = 0.0;
					
					m_shaking = false;
        		}
        		else 
				{
					trace("Shake");
					m_shakeOffSetX = m_shake * m_shakeDir;
                	m_shakeOffSetY = m_shake * m_shakeDir;
					
					m_shakeDir *= -1;			// invert
                	m_shake *= m_shakeFric;		// decay
        		}
				
				x = m_posX + m_shakeOffSetX;
				y = m_posY + m_shakeOffSetY;
			}
			else
			{
				x = m_posX;
				y = m_posY;
			}
		}
	}
}