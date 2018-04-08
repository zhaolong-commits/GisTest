package cn.zhrz.arcgis
{
	import flash.events.EventDispatcher;

	public class LogManager extends EventDispatcher
	{
		private static var instance:LogManager;
		
		public static function getInstance():LogManager{
			if(instance == null){
				instance = new LogManager();
			}
			return instance;
		}
		
		public function onLogMessage(value:String):void{
			this.dispatchEvent(new LogEvent(value));
		}
	}
}