///////////////////////////////////////////////////////////
//  CMissileArrow_Feela.as
//  Macromedia ActionScript Implementation of the Class CMissileArrow_Feela
//  Generated by Enterprise Architect
//  Created on:      14-Dec-2010 3:28:58 PM
//  Original author: Kurniawan Fitriadi
///////////////////////////////////////////////////////////

package com.game
{
	import com.game.CBaseLinearMissile;
	import com.game.CBaseTeelos;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Kurniawan Fitriadi
	 * @version 1.0
	 * @created 14-Dec-2010 3:28:58 PM
	 */
	public class CMissileArrow_Feela extends CBaseLinearMissile
	{
		public function CMissileArrow_Feela(){
		}
		
		override public function initialize():void 
		{
			super.initialize();
			
			m_speed = 0.7;
			m_sprite = new mcArrow_Feela();
			m_sprite.cacheAsBitmap = true;
		}
		
		override public function onCreate(container:DisplayObjectContainer, x:int, y:int, direction:int, faction:int, lane:int, damage:int, counterOf:int, counterDamage:int, level:int, detectInvisible:Boolean, owner:CBaseTeelos, exParams:Object = null):void 
		{
			//sound fx play
			SoundManager.getInstance().playSFX("SN07");
			
			super.onCreate(container, x, y, direction, faction, lane, damage, counterOf, 
							counterDamage, level, detectInvisible, owner, exParams);
		}
		
		override protected function onHit(target:CBaseTeelos):void 
		{
			super.onHit(target);
			m_targetTimes--;
		}
		
	}//end CMissileArrow_Feela

}