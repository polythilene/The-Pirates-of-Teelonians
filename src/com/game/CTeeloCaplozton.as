///////////////////////////////////////////////////////////
//  CTeeloCaplozton.as
//  Macromedia ActionScript Implementation of the Class CTeeloCaplozton
//  Generated by Enterprise Architect
//  Created on:      05-Jan-2011 14:58:03
//  Original author: poof!
///////////////////////////////////////////////////////////

package com.game
{
	import com.game.ai.AIState_Catapult_Fly;
	import com.game.CEnemyTeelos;
	import math.OpMath;
	import flash.display.DisplayObjectContainer;
	import com.greensock.TweenMax;

	/**
	 * @author poof!
	 * @version 1.0
	 * @created 05-Jan-2011 14:58:03
	 */
	public class CTeeloCaplozton extends CEnemyTeelos implements IJumper
	{
		private var m_hasLanded:Boolean;
		private var m_floor:int;
		
		public function CTeeloCaplozton(){

		}
		
		override public function initialize():void 
		{
			super.initialize();
			
			m_baseAttack = 4;
			m_defense = 3;
			m_maxLife = 21;
			m_unitClass = UNITCLASS.INFANTRY;
			m_counterClass = UNITCLASS.ARCHER;
			m_counterBonus = 5;
			m_baseSpeed = 0.01;
			m_dropMin = 0;
			m_dropMax = 3;
			m_baseCooldownTime = 1200;
		}
		
		override public function onCreate(lane:int, targetPosX:int, container:DisplayObjectContainer):void 
		{
			super.onCreate(lane, targetPosX, container);
			m_hasLanded = false;
			m_floor = m_sprite.y;
			m_sprite.y -= 100;
			changeAIState( AIState_Catapult_Fly.getInstance() );
		}
		
		override protected function createSprite():void 
		{
			super.createSprite();
			m_sprite = new mcTeelo_Caplozton();
		}
		
		public function fly():void
		{
			var myPosX:int = m_sprite.x;
			var myPosY:int = m_sprite.y;
			
			
			var targetX:int = m_sprite.x - OpMath.randomRange(300, 500);
			var targetY:int = m_floor;
			
			var dist:Number = OpMath.distance2(myPosX, myPosY, targetX, targetY);
			var midX:int = (myPosX - targetX) / 2;
			var midY:int = myPosY - 300;
			var time:Number = dist * 0.005;
				
			TweenMax.to( m_sprite, time, { bezier:[ { x:myPosX - midX, y:midY }, { x:targetX, y:targetY } ], 
						 orientToBezier:false, onComplete:function():void {m_hasLanded = true;} });
		}
		
		public function hasLanded():Boolean
		{
			return m_hasLanded;
		}
		

	}//end CTeeloCaplozton

}