package Config
{
	import mx.utils.StringUtil;
	
	import cn.zhrz.arcgis.LogManager;

	public class NodeAndLineConfigManager
	{
		public function NodeAndLineConfigManager()
		{
		}
		private static var instance : NodeAndLineConfigManager;
		
		public static function getInstance():NodeAndLineConfigManager{
			if( instance == null ){
				instance = new NodeAndLineConfigManager();
			}
			return instance;
		}
		/**
		 *	解析nodeAndLine配置文件
		 *  @param content 配置文件信息 
		 */
		public function parseConfig(content:String):void{
			if( StringUtil.trim(content) == "" ){
				return;
			}
			var xml : XML = new XML(content);
			var xmlChild : XMLList = xml.children();
			if( xmlChild == null ){
				LogManager.getInstance().onLogMessage("nodeAndLine配置文件配置错误！");
			}
			NodeAndLineConfig = new Object();
			for each( var item : XML in xmlChild ){
				var childObject :Object = new Object();
				var key : String = item.name()+"";
				parseChildConfig(item,childObject);
				NodeAndLineConfig[key] = childObject;
			}
		}

		/**
		 * 解析XML子的配置文件
		 * @param config 关于节点的配置信息 
		 * @param resultObj 返回的结果集
		 */
		private function parseChildConfig(config:XML,resultObj:Object):void{
			var propertyXMLList : XMLList = config.children();
			for each( var item : XML in propertyXMLList ){
				resultObj[item.name()+""] = item.toString();
			}
		}
		
		public var NodeAndLineConfig : Object;
	}
}