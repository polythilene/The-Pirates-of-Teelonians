///////////////////////////////////////////////////////////
//  CPlayerTeelos.as
//  Macromedia ActionScript Implementation of the Class CPlayerTeelos
//  Generated by Enterprise Architect
//  Created on:      11-Des-2010 22:24:33
//  Original author: poof!
///////////////////////////////////////////////////////////

package com.game
{
	import com.game.ai.*;
	import com.game.CBaseTeelos;
	import com.greensock.TweenMax;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author poof!
	 * @version 1.0
	 * @created 11-Des-2010 22:24:33
	 */
	public class CPlayerCaptain extends CPlayerTeelos
	{
	    /*protected var m_cost: int;
	    protected var m_node: CPlacementNode;
		
		protected var m_killCount:int;
		protected var m_trainCost:int;
		protected var m_retreated:Boolean;
		protected var m_swapping:Boolean;
		protected var m_flagPlacing:mc_placingFlag;*/
		
		/*Captain Smith properties*/
		protected var m_damageMultiplier:int;
		protected var m_rateMultiplier:int;
		protected var m_doubleShotMultiplier:int;
		
		public function CPlayerCaptain() { }
		
		override public function initialize():void 
		{
			super.initialize();
			m_flagPlacing = new mc_placingFlag();
		}
		
		override public function onCreate(lane:int, xPos:int, container:DisplayObjectContainer):void 
		{
			super.onCreate(lane, xPos, container);
			
			/*m_level = 1;
			m_killCount = 0;
			m_sprite.x = xPos;
			m_sprite.scaleX = 1;
			m_retreated = false;
			m_swapping = false;
			setDestination(850);
			
			if ( m_sprite.rank != null )
			{
				m_sprite.rank.gotoAndStop(1);
			}*/
			
			m_sprite.x = xPos;
			m_sprite.scaleX = 1;
			
			changeAIState( AIState_Captain_Idle.getInstance() );
		
			//m_container.addChild(m_flagPlacing);
			//m_flagPlacing.visible = true;
		}
		
		/*override public function setDestination(dest:int):void 
		{
			super.setDestination(dest);
			m_flagPlacing.x = dest;
			m_flagPlacing.y  = -200;
			TweenMax.to(m_flagPlacing, 0.25, { y:m_sprite.y+10 } );
		}*/
		
		/*public function addKillCount():void
		{
			m_killCount++;
			if ( m_killCount >= 5 && m_level < 3 )
			{
				onLevelUp();
				m_killCount = 0;
			}
		}*/
		
		override public function set placementNode(value:CPlacementNode):void
		{
			//m_node = value;
		}
		
		override public function get placementNode():CPlacementNode
		{
			return null;
		}
		
		public function get damageMultiply():int
		{
			return m_damageMultiplier;
		}
		public function get rateMultiply():int
		{
			return m_rateMultiplier;
		}
		public function get doubleShotMultiply():int
		{
			return m_doubleShotMultiplier;
		}
		
		
		override public function onRemove():void 
		{
			super.onRemove();
			
			// remove tactic glow
			TweenMax.to(m_sprite, 0.1, { glowFilter: { color:0x91e600, alpha:0, blurX:0, blurY:0 }	} );
			
			if( m_node )
				m_node.obtained = false;
				
			if ( m_sprite.rank != null )
			{
				TweenMax.killTweensOf(m_sprite.rank);
			}
			
			//m_container.removeChild(m_flagPlacing);
		}
		
		override public function attack(target:CBaseTeelos):void 
		{
			super.attack(target);
			
			if ( !isCoolingDown() )
			{
				m_cooldownCounter = 0;
				// melee unit cast direct hit
				if( unitClass == UNITCLASS.INFANTRY || unitClass == UNITCLASS.CAVALRY || unitClass == UNITCLASS.SIEGE )
				{
					var bonus:int = ( m_counterClass == target.unitClass ) ? m_counterBonus : 0;
					target.damage( attackDamage + m_level + bonus, this );
				}
			}
			else
			{
				if( m_sprite.currentFrame != 1 )
				{
					m_sprite.gotoAndStop(1);
					animationReset();
				}
			}
		}
		
		/*public function onLevelUp():void
		{
			SoundManager.getInstance().playSFX("SNLvl");
			m_currLife = m_maxLife + m_level;
			m_level++;
			if ( m_sprite.rank != null )
			{
				m_sprite.rank.alpha = 0;
				m_sprite.rank.gotoAndStop(m_level);
				m_sprite.rank.y = -50;
				TweenMax.to( m_sprite.rank, 0.5, { y: -78, alpha:1 } );
			}
		}*/
		
		override public function onDestinationReached():void
		{
			m_flagPlacing.visible = false; 
		}
		
		// stats
		override public function get attackDamage():int
		{
			return ( m_baseAttack + m_level );
		}
		
		override public function get defense():int
		{
			return ( m_defense + m_level );
		}
		
		override public function getFaction():int
		{
			return FACTION.PLAYER;
		}
		
		override public function animationHit():void 
		{
			if( !m_retreated && !m_swapping )
				changeAIState( AIState_Player_Hit.getInstance() );
		}
		
		/*public function getTrainingCost():int
		{
			return m_trainCost;
		}
		
		public function get retreated():Boolean
		{
			return m_retreated;
		}
		
		public function set retreated(value:Boolean):void
		{
			m_retreated = value;
		}
		
		public function get swapping():Boolean
		{
			return m_swapping;
		}
		
		public function set swapping(value:Boolean):void
		{
			m_swapping = value;
		}*/
		
		override public function update(elapsedTime:int):void 
		{
			super.update(elapsedTime);
			
			if ( m_active && (x > 820 || x < -1000))
			{
				m_active = false;
			}
		}
	}//end CPlayerCaptain

}