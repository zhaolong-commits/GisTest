package Config
{
	import mx.utils.StringUtil;

	public class PathManager
	{
		public function PathManager()
		{
		}
		private static var instance : PathManager;
		
		public static function getInstance():PathManager{
			if( instance == null ){
				instance = new PathManager();
			}
			return instance;
		}
		private var cach : Object = new Object();
		
		public function parseConfig( content : String ):void{
			var arr : Array = content.split("\r\n");
			for each( var child : String in arr ){
				var trimChild : String = StringUtil.trim(child);
				if( trimChild != "" && trimChild.charAt(0) != "#"){
					var singleArr : Array = trimChild.split("=");
					cach[singleArr[0]] = singleArr[1];
				}
			}
		}
		
		public function getValue(key:String):String{
			if( cach.hasOwnProperty(key) ){
				return cach[key];
			}
			return null;
		}
	}
}