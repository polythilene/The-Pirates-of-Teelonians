package com.game.physics 
{
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	/**
	 * ...
	 * @author Wiwit
	 */
	public class CustomContactListener extends b2ContactListener 
	{
		
		public function CustomContactListener() 
		{
			
		}
		
		
		override public function Add(point:b2ContactPoint):void 
		{
			super.Add(point);
			
			
			// bullet vs ground
			
			var bullet:CBasePhysicBullet;
			var enemy:CBasePhysicEnemy;
			
			if( (point.shape1.GetBody().GetUserData() is CBasePhysicBullet && 
				 point.shape2.GetBody().GetUserData() is String && String(point.shape2.GetBody().GetUserData()) == "ground") ||
				   
				(point.shape1.GetBody().GetUserData() is String && String(point.shape1.GetBody().GetUserData()) == "ground" &&
				 point.shape2.GetBody().GetUserData() is CBasePhysicBullet) )
			{	
				bullet = point.shape1.GetBody().GetUserData() is CBasePhysicBullet ? 
						 CBasePhysicBullet(point.shape1.GetBody().GetUserData()) :
						 CBasePhysicBullet(point.shape2.GetBody().GetUserData());
				bullet.hit();	
				
				State_MiniGame.getInstance().camera.shake(2, 5);
			}
			
			
			// bullet vs enemy
			
			else if( (point.shape1.GetBody().GetUserData() is CBasePhysicBullet && point.shape2.GetBody().GetUserData() is CBasePhysicEnemy) || 
					 (point.shape1.GetBody().GetUserData() is CBasePhysicEnemy && point.shape2.GetBody().GetUserData() is CBasePhysicBullet) )	
			{
				bullet = point.shape1.GetBody().GetUserData() is CBasePhysicBullet ? 
						 CBasePhysicBullet(point.shape1.GetBody().GetUserData()) :
						 CBasePhysicBullet(point.shape2.GetBody().GetUserData());
				bullet.hit();		 
				
				enemy = point.shape1.GetBody().GetUserData() is CBasePhysicEnemy ? 
						 CBasePhysicEnemy(point.shape1.GetBody().GetUserData()) :
						 CBasePhysicEnemy(point.shape2.GetBody().GetUserData());
				enemy.hit();		 
				
				State_MiniGame.getInstance().camera.shake(2, 5);
			}
		}
	}
}