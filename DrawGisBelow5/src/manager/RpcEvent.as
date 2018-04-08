package manager
{
	import flash.events.Event;
	
	import mx.rpc.AsyncToken;

	public class RpcEvent extends Event
	{
		public function RpcEvent(type:String, token:AsyncToken = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type,bubbles,cancelable);
		}
		public var token : AsyncToken;
	}
}