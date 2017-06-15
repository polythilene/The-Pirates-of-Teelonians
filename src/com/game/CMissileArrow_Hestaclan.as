///////////////////////////////////////////////////////////
//  CMissileIceBall_Endrogee.as
//  Macromedia ActionScript Implementation of the Class CMissileIceBall_Endrogee
//  Generated by Enterprise Architect
//  Created on:      17-Dec-2010 11:48:16 AM
//  Original author: Kurniawan Fitriadi
///////////////////////////////////////////////////////////

package com.game
{
	import com.game.CBaseParabolicMissile;
	import com.game.CBaseTeelos;
	import com.game.fx.CEffect_IceExplosion;
	import flash.display.DisplayObjectContainer;
	import math.OpMath;

	/**
	 * @author Kurniawan Fitriadi
	 * @version 1.0
	 * @created 17-Dec-2010 11:48:16 AM
	 */
	public class CMissileArrow_Hestaclan extends CBaseParabolicMissile
	{
		public function CMissileArrow_Hestaclan(){

		}
		
		override public function initialize():void 
		{
			super.initialize();
			m_sprite = new mcArrow_Croztan();
			m_sprite.cacheAsBitmap = true;
		} 
		
		override public function onCreate(container:DisplayObjectContainer, x:int, y:int, direction:int, faction:int, lane:int, damage:int, counterOf:int, counterDamage:int, level:int, detectInvisible:Boolean, owner:CBaseTeelos, exParams:Object = null):void 
		{
			//play sfx
			SoundManager.getInstance().playSFX("SN07");
			
			super.onCreate(container, x, y, direction, faction, lane, damage, counterOf, 
						   counterDamage, level, detectInvisible, owner, exParams);
		}
		
		override protected function onGroundLevel():void 
		{
			super.onGroundLevel();
		}
		
	}//end CMissileIceBall_Endrogee

}