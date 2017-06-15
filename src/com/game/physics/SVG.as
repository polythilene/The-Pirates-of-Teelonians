package com.game.physics 
{
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2World;
	/**
	 * ...
	 * @author Wiwit
	 */
	public class SVG 
	{
		static private var m_instance:SVG;
		
		private var m_data:XML;
		private var m_world:b2World;
		private var m_ratio:int;
		
		static public function getInstance(): SVG
		{
			if( m_instance == null ){
				m_instance = new SVG( new SingletonLock() );
			}
			return m_instance;
		}
		
		public function SVG(lock:SingletonLock) { }
		
		public function buildBody(layerId:String/*, bodyData:Object=null*/):Boolean
		{
			// find a group with layerId in xml
			
			if ( m_data.children().length() > 0 )
			{
				var searchNode:XML;
				var found:Boolean = false;
				var i:int = 0;
				while( !found && i < m_data.children().length() )
				{
					if( m_data.children()[i].name() == "g" && 
						m_data.children()[i].attribute("id") == layerId )
					{	
						found = true;
						searchNode = m_data.children()[i];
					}
					i++;
				}
				
				if ( found )
				{
					// parse each polyline and convert to b2Body
					
					if ( searchNode.length() > 0 )
					{
						for ( var ctr:int = 0; ctr < searchNode.children().length(); ctr++ )
						{
							if ( searchNode.children()[ctr].name() == "polyline" )
							{
								var pointStr:String = searchNode.children()[ctr].attribute("points");
								
								// split by spaces
								var pointList:Array = pointStr.split(" ");
								if (pointList)
								{
									// get x & y coordinate, and build shape
									
									var bodyDef:b2PolygonDef = new b2PolygonDef();
									bodyDef.friction = 0.5;
									bodyDef.restitution = 0.0;
									bodyDef.vertexCount = pointList.length;
											
									for ( var x:int = 0; x < pointList.length; x++ )
									{
										var coordList:Array = pointList[x].split(",");
										bodyDef.vertices[x] = addVector(Number(coordList[0]), Number(coordList[1]));
									}
									
									m_world.GetGroundBody().CreateShape(bodyDef);
								}
							}
						}
					}
					return true;
				}
			}
			return false;
		}
		
		private function addVector(vx:Number, vy:Number):b2Vec2
		{
			return (new b2Vec2(vx / m_ratio, vy / m_ratio));
		}
		
		public function set data(value:XML):void 
		{
			m_data = value;
		}
		
		public function set world(value:b2World):void 
		{
			m_world = value;
		}
		
		public function get ratio():int 
		{
			return m_ratio;
		}
		
		public function set ratio(value:int):void 
		{
			m_ratio = value;
		}
	}
}

class SingletonLock{}