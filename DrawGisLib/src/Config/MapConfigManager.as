package Config
{
	import mx.controls.Alert;
	import mx.utils.StringUtil;
	
	import cn.zhrz.arcgis.MapConfig;

	public class MapConfigManager
	{
		public function MapConfigManager()
		{
		}
		private static var instance : MapConfigManager;
		
		public static function getInstance():MapConfigManager
		{
			if( instance == null ){
				instance = new MapConfigManager();
			}
			return instance;
		}
		
		private var mapData : Object;
		
		public function parseMapConfig(content : String):void{
			if( StringUtil.trim(content) == "" ){
				return;
			}
			try{
				var xml:XML = new XML(content);
				var xmlChild:XMLList = xml.children();
				mapData = new Object();
				for (var i:int = 0 ; i < xmlChild.length();i++){
					var childXml:XML = xmlChild[i];
					var level:String = ""+childXml.@id;
					
					var propertyObj:Object = new Object();
					mapData[level] = propertyObj;
					
					propertyObj.beginCol = parseInt(""+childXml.@beginCol);
					propertyObj.endCol = parseInt(""+childXml.@endCol);
					
					propertyObj.beginRow = parseInt(""+childXml.@beginRow);
					propertyObj.endRow = parseInt(""+childXml.@endRow);
					
					propertyObj.pos = parseFloat(""+childXml.@pos);
									
					//火车站点，飞机场
					propertyObj.isAddSite = parseBoolean(""+childXml.@isAddSite);
					propertyObj.isAddAirPort = parseBoolean(""+childXml.@isAddAirPort);
					
					//添加省会，城市，乡镇
					propertyObj.isAddCapital = parseBoolean(""+childXml.@isAddCapital);
					propertyObj.isAddCity = parseBoolean(""+childXml.@isAddCity);
					propertyObj.isAddCounty = parseBoolean(""+childXml.@isAddCounty);
					propertyObj.isAddTown = parseBoolean(""+childXml.@isAddTown);
					
					//添加省界，城市边界，县市边界
					propertyObj.isAddBounder= parseBoolean(""+childXml.@isAddBounder);
					propertyObj.isAddCityBorder = parseBoolean(""+childXml.@isAddCityBorder);
					propertyObj.isAddCountyBorder = parseBoolean(""+childXml.@isAddCountyBorder);
					
					//添加铁路，高速，国道，省道，城际快速车道，县道
					propertyObj.isAddrailway = parseBoolean(""+childXml.@isAddrailway);	
					propertyObj.isAddHighwayLine = parseBoolean(""+childXml.@isAddHighwayLine);
					propertyObj.isAddNationalHighwayLine = parseBoolean(""+childXml.@isAddNationalHighwayLine);
					propertyObj.isAddProvincialHighway = parseBoolean(""+childXml.@isAddProvincialHighway);
					propertyObj.isAddExpressway = parseBoolean(""+childXml.@isAddExpressway);
					propertyObj.isAddCountyHighway = parseBoolean(""+childXml.@isAddCountyHighway);
					
				}
				
				MapConfig.LEVEL_DATAS =  mapData;
			}
			catch(e:Error){
				Alert.show(e.getStackTrace()); 
			}
		}
		private function parseBoolean( content : String ):Boolean{
			if( StringUtil.trim(content) == "true" ){
				return true;
			}else{
				return false;
			}
		}
	}
}