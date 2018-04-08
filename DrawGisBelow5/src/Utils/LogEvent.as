package Utils
{
	import flash.events.Event;
	
	public class LogEvent extends Event
	{
		public static const LOG_EVENT:String = "logEvent";
		
		public function LogEvent(msg:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(LOG_EVENT, bubbles, cancelable);
			this.msg = msg;
		}
		
		public var msg:String;
	}
}