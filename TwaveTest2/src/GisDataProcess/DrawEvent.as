package GisDataProcess
{
	import flash.events.Event;
	
	public class DrawEvent extends Event
	{
		public static const DRAW_SUCCESSED : String = "drawSuccessed";
		
		public var data : Boolean;
		
		public var currentIndex : Number;
		
		public function DrawEvent(type:String, isDivied :Boolean = false,currentIndex:Number = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = isDivied;
			this.currentIndex = currentIndex;
		}
	}
}