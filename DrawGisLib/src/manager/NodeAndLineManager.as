package manager
{
	import com.esri.ags.Graphic;
	import com.esri.ags.Map;
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.MapPoint;
	import com.esri.ags.geometry.Polyline;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.symbols.SimpleLineSymbol;
	import com.esri.ags.symbols.SimpleMarkerSymbol;
	import com.esri.ags.symbols.TextSymbol;
	
	import flash.text.TextFormat;
	
	import mx.collections.ArrayCollection;
	
	import Config.NodeAndLineConfigManager;
	
	import cn.zhrz.arcgis.CoordinateUtil;
	import cn.zhrz.arcgis.LogManager;

	public class NodeAndLineManager
	{
		public function NodeAndLineManager()
		{
			init();
		}
		
		private static var instance : NodeAndLineManager;
		
		public static function getInstance():NodeAndLineManager{
			if( instance == null ){
				instance = new NodeAndLineManager();
			}
			return instance;
		}
		private var _gisMap : Map;
		
		public function get gisMap():Map
		{
			return _gisMap;
		}

		public function set gisMap(value:Map):void
		{
			_gisMap = value;
		}
		
		private var nodeConfig :Object;
		/**
		 * 获取初始化配置文件中配置
		 */
		private function init():void{
			
			nodeConfig = NodeAndLineConfigManager.getInstance().NodeAndLineConfig;	
		}
		
		//铁路站点
		private var siteVec : Vector.<Graphic> = new Vector.<Graphic>();
		//飞机场
		private var airportStn : Vector.<Graphic> = new Vector.<Graphic>();
		//省会
		private var capitalVec : Vector.<Graphic> = new Vector.<Graphic>();
		//城市
		private var cityVec : Vector.<Graphic> = new Vector.<Graphic>();
		//区县
		private var countyPointsVec : Vector.<Graphic> = new Vector.<Graphic>();
		//乡镇
		private var townPointsVec : Vector.<Graphic> = new Vector.<Graphic>();
		
		//省边界
		private var borderVec :　Vector.<Graphic> = new Vector.<Graphic>();
		//城市边界
		private var cityBorderVec : Vector.<Graphic> = new Vector.<Graphic>();
		//县边界
		private var CountyPolygonVec : Vector.<Graphic> = new Vector.<Graphic>();
		
		//铁路线
		private var RailwayVec : Vector.<Graphic> = new Vector.<Graphic>();
		//高速公路
		private var heightWayVec : Vector.<Graphic> = new Vector.<Graphic>();
		//国道
		private var nationalHeightWayVec : Vector.<Graphic> = new Vector.<Graphic>();
		//省道
		private var ProvincialHighwayVec : Vector.<Graphic> = new Vector.<Graphic>();
		//县道
		private var CountyHighwayVec : Vector.<Graphic> = new Vector.<Graphic>();
		//城际快速车道
		private var expressWayVec : Vector.<Graphic> = new Vector.<Graphic>();
		
		/**
		 *	添加全部火车站点
		 *  @param siteArr:Array 站点集合 
		 */
		public function addSite(siteArr : ArrayCollection):void{	
			var siteObj : Object = nodeConfig.site;
			addPoint(gisMap.defaultGraphicsLayer,siteArr,siteObj,"添加火车站点");
		}
		
		public function addAirPort(airArr : ArrayCollection):void{
			var airConfig : Object = nodeConfig.airPort;
			addPoint(gisMap.defaultGraphicsLayer,airArr,airConfig,"添加飞机场");
		}
		
		/**
		 *	添加省会 
		 */
		public function addCapitalPoint(capitalArr : ArrayCollection):void{
			var capitalConfig : Object = nodeConfig.capital;
			addPoint(gisMap.defaultGraphicsLayer,capitalArr,capitalConfig,"添加省会");
		}
		/**
		 *	添加城市
		 * @param cityArr 城市点集合
		 */
		public function addCity(cityArr : ArrayCollection):void{
			var cityConfig : Object = nodeConfig.city;
			addPoint(gisMap.defaultGraphicsLayer,cityArr,cityConfig,"添加城市");
		}
		/**
		 *	添加县城
		 * 	@param  CountyArr 县城集合
		 */
		public function addCounty(CountyArr : ArrayCollection):void{
			var contyConfig : Object = nodeConfig.County;
			addPoint(gisMap.defaultGraphicsLayer,CountyArr,contyConfig,"添加县市");
		}
		/**
		 * 添加乡镇
		 * @param townArr 乡镇点集合
		 */
		public function addTown( townArr : ArrayCollection ):void{
			var townConfig : Object = nodeConfig.town;
			addPoint(gisMap.defaultGraphicsLayer,townArr,townConfig,"添加乡镇");
		}
		
		/**
		 *	添加站点，省会，城市，县等站点 
		 */
		public function addPoint(layer : GraphicsLayer,pointArr : ArrayCollection,config:Object,message : String):void{
			if( layer == null ){
				log(message+"层报错！层为null！！！！");
				return;
			}
			if( pointArr == null || pointArr.length <= 0 ){
				log(message+"给的点集合报错！！");
				return;
			}
			if( config == null ){
				log(message+"配置文件错误！！！");
				return;
			}
			var style : String = config.style;
			var size : Number = Number(config.size);
			var color : Number = Number(config.color);
			var textXpos : Number = Number(config.textXpos);
			var textYpos : Number = Number(config.textYpos);
			var fontFamily : String = config.fontFamily;
			var fontSize : Number = Number(config.fontSize);
			var fontColor : Number = Number(config.fontColor);
			var isShowNode : Boolean;
			if(config.isShowNode == "true"){
				isShowNode = true;
			}else{
				isShowNode = false;
			}
			var isShowText : Boolean;
			if(config.isShowText == "true"){
				isShowText = true;
			}else{
				isShowText = false;
			}
			if( isNaN(size) || isNaN(color) || isNaN(textXpos) || isNaN(textYpos) || isNaN(fontSize) || isNaN(fontColor) ){
				log(message+"配置文件错误！！！！");
				return;
			}
			log(message+"开始添加！！！！");
			for each( var capital : Object in pointArr ){
				if(isShowNode){
					var mapPoint : MapPoint = CoordinateUtil.jingwei2MoQia(capital.gisLatitude,capital.gisLongitude,new SpatialReference(102100));
					var nodeSy : SimpleMarkerSymbol = new SimpleMarkerSymbol(config.style,config.size,config.color);
					var node : Graphic = new Graphic(mapPoint,nodeSy);
					layer.add(node);
					capitalVec.push(node);
				}
				if(isShowText){
					var textSy : TextSymbol = new TextSymbol(capital.name,null,0,1,false,0,false,16777215,"middle",0,config.textXpos,config.textYpos,new TextFormat(config.fontFamily,config.fontSize,config.fontColor,true));
					var textGraphic : Graphic = new Graphic(CoordinateUtil.jingwei2MoQia(capital.gisLatitude,capital.gisLongitude,new SpatialReference(102100)),textSy);
					layer.add(textGraphic);
					capitalVec.push(textGraphic);					
				}

			}
			log(message+"添加成功！！！");
		}
		
		/**
		 *	画省边界线
		 *  @param boundArr  线集合
		 */
		public function addBoundary(boundArr : ArrayCollection):void{
			var boundarLayer : GraphicsLayer = gisMap.getLayer("bounder") as GraphicsLayer;
			var provinceBorderObj : Object = nodeConfig.border;
			addBorder(boundarLayer,boundArr,borderVec,provinceBorderObj,"添加省边界线");
		}
		
		/**
		 *	添加城市边界线 
		 */
		public function addCityBorder(cityPointArr : ArrayCollection):void{
			var cityBoundaryLayer : GraphicsLayer = gisMap.getLayer("cityBoundary") as GraphicsLayer;
			var cityBorderConfig : Object = nodeConfig.cityBorder;
			addBorder(cityBoundaryLayer,cityPointArr,cityBorderVec,cityBorderConfig,"添加城市边界线");
		}
		/**
		 *	添加县边界 
		 */
		public function addCountyBorder(countyArr : ArrayCollection):void{
			var countyBorderLayer : GraphicsLayer = gisMap.getLayer("countyBorder") as GraphicsLayer;
			var countyBorderConfig : Object = nodeConfig.CountyBorder;
			addBorder(countyBorderLayer,countyArr,CountyPolygonVec,countyBorderConfig,"添加县边界线");
		}
		
		/**
		 *	添加火车线
		 *  @param nodeArr 点集合
		 */
		public function addNodeAndLine(nodeArr : ArrayCollection):void{
			var railwayLayer : GraphicsLayer = gisMap.getLayer("railway") as GraphicsLayer;
			var railWayConfig : Object = nodeConfig.Line;
			addLines(railwayLayer,nodeArr,RailwayVec,railWayConfig,"添加火车线");
		}
		
		/**
		 *	添加高速线 
		 */
		public function addHeightWayLine( pointArr : ArrayCollection ):void{
			var heightWayLayer : GraphicsLayer = gisMap.getLayer("heightWay") as GraphicsLayer;
			var config : Object = nodeConfig.heightWay;
			addLines(heightWayLayer,pointArr,heightWayVec,config,"添加高速路");
		}
		/**
		 *	添加国道
		 */
		public function addNationalHeightWayLine(pointArr : ArrayCollection):void{
			var nationalHeightWayLayer : GraphicsLayer = gisMap.getLayer("nationalHeightWay") as GraphicsLayer;
			var config : Object = nodeConfig.nationalHeightWay;
			addLines(nationalHeightWayLayer,pointArr,nationalHeightWayVec,config,"添加国道");
		}
		/**
		 *	添加省道
		 */
		public function addProvincialHighwayLine(pointArr : ArrayCollection):void{
			var provinceialHeighWayLayer : GraphicsLayer = gisMap.getLayer("provincialWay") as GraphicsLayer;
			var config : Object = nodeConfig.ProvincialHighway;
			addLines(provinceialHeighWayLayer,pointArr,ProvincialHighwayVec,config,"添加省道");
		}
		/**
		 *	添加城际快车道 
		 */
		public function addExpresswayLine( pointArr : ArrayCollection ):void{
			var expressWayLayer : GraphicsLayer = gisMap.getLayer("expressWay") as GraphicsLayer;
			var config : Object = nodeConfig.Expressway;
			addLines(expressWayLayer,pointArr,expressWayVec,config,"添加城际快车道");
		}
		/**
		 *	添加县道 
		 */
		public function addCountyHighwayLine(pointArr : ArrayCollection):void{
			var countyHeightwayLayer : GraphicsLayer = gisMap.getLayer("countyHeighway") as GraphicsLayer;
			var config : Object = nodeConfig.CountyHighway;
			addLines(countyHeightwayLayer,pointArr,CountyHighwayVec,config,"添加县道");
		}
		
		/**
		 *	添加线 
		 */
		private function addLines(layer:GraphicsLayer,pointArr : ArrayCollection,vec : Vector.<Graphic>,config : Object,message:String):void{
			if( layer == null ){
				log(message+"图层错误！");
				return;
			}
			if( pointArr == null || pointArr.length <= 0 ){
				log(message+"点集合失败！");
				return;
			}
			if( vec == null ){
				log(message+"临时存储集合为null！！");
				return;	
			}
			if( config == null ){
				log(message+"样式配置文件错误！！！！");
				return;
			}
			
			var lineBoderWidth : Number = Number(config.width);
			var lineBorderAlpha : Number = Number(config.alpha);
			var lineBorderColor : uint = Number(config.color);
			
			if( isNaN(lineBoderWidth) || isNaN(lineBorderAlpha) || isNaN(lineBorderColor) ){
				log(message+"线的样式配置不正确！请查看");
				return;
			}
			
			for( var i :int = 0; i < pointArr.length; i++ ){
				var mapPoint : MapPoint = CoordinateUtil.jingwei2MoQia(pointArr[i].gisLatitude,pointArr[i].gisLongitude,new SpatialReference(102100));
				var nodeSy : SimpleMarkerSymbol = new SimpleMarkerSymbol("circle",lineBoderWidth,lineBorderColor);
				var node : Graphic = new Graphic(mapPoint,nodeSy);
				node.id = pointArr[i].id;
				layer.add(node);
				vec.push(node);
				if( i <= pointArr.length ){
					var arr : Array = [];
					arr.push(CoordinateUtil.jingwei2MoQia(pointArr[i].gisLatitude,pointArr[i].gisLongitude));
					arr.push(CoordinateUtil.jingwei2MoQia(pointArr[i].gisLatitude,pointArr[i].gisLongitude));
					var myPolyLine : Polyline = new Polyline([arr],new SpatialReference(102100));
					var lineSy : SimpleLineSymbol = new SimpleLineSymbol("normal",lineBorderColor,lineBorderColor,lineBoderWidth);
					var myGraphicLine : Graphic = new Graphic(myPolyLine,lineSy);
					layer.add(myGraphicLine);
					vec.push(myGraphicLine);
				}
			}
		}
		
		private function addBorder(layer:GraphicsLayer,pointArr : ArrayCollection,vec : Vector.<Graphic>,config : Object,message:String):void{
			if( layer == null ){
				log(message+"图层错误！");
				return;
			}
			if( pointArr == null || pointArr.length <= 0 ){
				log(message+"点集合失败！");
				return;
			}
			if( vec == null ){
				log(message+"临时存储集合为null！！");
				return;	
			}
			if( config == null ){
				log(message+"样式配置文件错误！！！！");
				return;
			}
			
			var lineBoderWidth : Number = Number(config.width);
			var lineBorderAlpha : Number = Number(config.alpha);
			var lineBorderColor : uint = Number(config.color);
			
			if( isNaN(lineBoderWidth) || isNaN(lineBorderAlpha) || isNaN(lineBorderColor) ){
				log(message+"线的样式配置不正确！请查看");
				return;
			}
			
			for( var i :int = 0; i < pointArr.length; i++ ){
				var mapPoint : MapPoint = CoordinateUtil.jingwei2MoQia(pointArr[i].gisLatitude,pointArr[i].gisLongitude,new SpatialReference(102100));
				var nodeSy : SimpleMarkerSymbol = new SimpleMarkerSymbol("circle",lineBoderWidth,lineBorderColor);
				var node : Graphic = new Graphic(mapPoint,nodeSy);
				node.id = pointArr[i].id;
				layer.add(node);
				vec.push(node);
			}
		}
		
		
		/**
		 *	清理已经添加的边线以及铁路线 
		 */
		public function clearAllNodes():void{
			if( gisMap == null ){ return; }
			//省边界
			var boundarLayer : GraphicsLayer = gisMap.getLayer("provinceBorder") as GraphicsLayer;
			if( borderVec && boundarLayer && borderVec.length > 0 ){		
				for each( var borderNode : Graphic in borderVec ){
					boundarLayer.remove(borderNode);
					borderNode.geometry = null;
					borderNode.symbol = null;
					borderNode = null;
				}
				borderVec = null;
				borderVec = new Vector.<Graphic>();
			}
			//城市边界
			var cityBoundaryLayer : GraphicsLayer = gisMap.getLayer("cityBoundary") as GraphicsLayer;
			if( cityBorderVec && cityBoundaryLayer && cityBorderVec.length > 0 ){
				for each( var cityBorderNode : Graphic in cityBorderVec ){
					cityBoundaryLayer.remove(cityBorderNode);
					cityBorderNode.geometry = null;
					cityBorderNode.symbol = null;
					cityBorderNode = null;
				}
				cityBorderVec = null;
				cityBorderVec = new Vector.<Graphic>();
			}
			//县边界
			var countyBorderLayer : GraphicsLayer = gisMap.getLayer("countyBorder") as GraphicsLayer;
			if( countyBorderLayer && CountyPolygonVec && CountyPolygonVec.length > 0 ){
				for each( var countyBorderNode : Graphic in CountyPolygonVec ){
					countyBorderLayer.remove(countyBorderNode);
					countyBorderNode.geometry = null;
					countyBorderNode.symbol = null;
					countyBorderNode = null;
				}
				CountyPolygonVec = null;
				CountyPolygonVec = new Vector.<Graphic>();
			}
			
			//铁路线
			var railwayLayer : GraphicsLayer = gisMap.getLayer("railway") as GraphicsLayer;
			if( RailwayVec && RailwayVec.length > 0 && railwayLayer ){
				for each( var node : Graphic in RailwayVec){
					railwayLayer.remove(node);
					node.geometry = null;
					node.symbol = null;
					node = null;
				}
				RailwayVec = null;
				RailwayVec = new Vector.<Graphic>();
			}
			//高速路
			var heightWayLayer : GraphicsLayer = gisMap.getLayer("heightWay") as GraphicsLayer;
			if( heightWayLayer && heightWayVec && heightWayVec.length > 0 ){
				for each( var heightWayPoint : Graphic in heightWayVec ){
					heightWayLayer.remove(heightWayPoint);
					heightWayPoint.geometry = null;
					heightWayPoint.symbol = null;
					heightWayPoint = null;
				}
				heightWayVec = null;
				heightWayVec = new Vector.<Graphic>();
			}
			//国道
			var nationalHeightWayLayer : GraphicsLayer = gisMap.getLayer("nationalHeightWay") as GraphicsLayer;
			if( nationalHeightWayLayer && nationalHeightWayVec && nationalHeightWayVec.length > 0 ){
				for each( var nationalPoint : Graphic in nationalHeightWayVec ){
					nationalHeightWayLayer.remove(nationalPoint);
					nationalPoint.geometry = null;
					nationalPoint.symbol = null;
					nationalPoint = null;
				}
				nationalHeightWayVec = null;
				nationalHeightWayVec = new Vector.<Graphic>();
			}
			//省道
			var provinceialHeighWayLayer : GraphicsLayer = gisMap.getLayer("provincialWay") as GraphicsLayer;
			if( provinceialHeighWayLayer && ProvincialHighwayVec && ProvincialHighwayVec.length > 0 ){
				for each( var provinceNode : Graphic in ProvincialHighwayVec ){
					provinceialHeighWayLayer.remove(provinceNode);
					provinceNode.geometry = null;
					provinceNode.symbol = null;
					provinceNode = null;
				}
				ProvincialHighwayVec = null;
				ProvincialHighwayVec = new Vector.<Graphic>();
			}
			//城际快车道
			var expressWayLayer : GraphicsLayer = gisMap.getLayer("expressWay") as GraphicsLayer;
			if( expressWayLayer && expressWayVec && expressWayVec.length > 0 ){
				for each( var expresssNode : Graphic in expressWayVec ){
					expressWayLayer.remove(expresssNode);
					expresssNode.geometry = null;
					expresssNode.symbol = null;
					expresssNode = null;
				}
				expressWayVec = null;
				expressWayVec = new Vector.<Graphic>();
			}
			//县道
			var countyHeightwayLayer : GraphicsLayer = gisMap.getLayer("countyHeighway") as GraphicsLayer;
			if( countyHeightwayLayer && CountyHighwayVec && CountyHighwayVec.length > 0 ){
				for each( var countyWayNode : Graphic in CountyHighwayVec  ){
					countyHeightwayLayer.remove(countyWayNode);
					countyWayNode.geometry = null;
					countyWayNode.symbol = null;
					countyWayNode = null;
				}
				CountyHighwayVec = null;
				CountyHighwayVec = new Vector.<Graphic>();
			}
			log("清理当前区域的边界，道路完成！！");
			return;
		}
		
		/**
		 * 设置显示日志
		 */
		private function log(message:String):void{
			LogManager.getInstance().onLogMessage(message);
		}
	}
}