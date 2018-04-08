package cn.zhrz.arcgis
{
	import flash.events.Event;
	
	public class EventWidthData extends Event
	{
		public function EventWidthData(level:int,row:Number,col:Number, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super("mapImageLoad", bubbles, cancelable);
			this.level = level;
			this.row = row;
			this.col = col;
		}
		
		public var level:int;
		public var row:Number;
		public var col:Number;
	}
}