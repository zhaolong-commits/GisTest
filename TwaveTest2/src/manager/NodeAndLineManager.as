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
	
	import flash.system.System;
	import flash.text.TextFormat;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
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
		
		private var allPointVec : Vector.<Graphic> = new Vector.<Graphic>();
		
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
		// 乡村车道
		private var xzcdVec : Vector.<Graphic> = new Vector.<Graphic>();
		// 加油站
		private var gasStationVec : Vector.<Graphic> = new Vector.<Graphic>(); 
		// 添加金融服务中心
		private var financePointVec : Vector.<Graphic> = new Vector.<Graphic>();
		// 添加九级路点
		private var nineGradeVec : Vector.<Graphic> = new Vector.<Graphic>();
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
		 * 添加区
		 * @param areaArr 区集合 
		 */
		public function addArea(areaArr : ArrayCollection):void{
			var areaConfig : Object = nodeConfig.area;
			addPoint(gisMap.defaultGraphicsLayer,areaArr,areaConfig,"添加区");
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
		//添加乡镇
		public function addTown2(townArr : ArrayCollection):void{
			var townLayer : GraphicsLayer = gisMap.getLayer("town") as GraphicsLayer;
			var townConfig : Object = nodeConfig.town;
			addPoint(townLayer,townArr,townConfig,"添加乡镇",townPointsVec);
		}
		/**
		 * 添加街道
		 * @param streetArr 街道点集合
		 */
		public function addStreet(streetArr:ArrayCollection):void{
			var streetConfig : Object = nodeConfig.street;
			addPoint(gisMap.defaultGraphicsLayer,streetArr,streetConfig,"添加街道");
		}
		
		/**
		 *	添加站点，省会，城市，县等站点 
		 */
		public function addPoint(layer : GraphicsLayer,pointArr : ArrayCollection,config:Object,message : String,vec:Vector.<Graphic> = null):void{
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
			if( vec == null ){
				vec = allPointVec;
			}
			var style : String = config.style;
			var size : Number = Number(config.size);
			var color : Number = Number(config.color);
			var textXpos : Number = Number(config.textXpos);
			var textYpos : Number = Number(config.textYpos);
			var fontFamily : String = config.fontFamily;
			var fontSize : Number = Number(config.fontSize);
			var fontColor : Number = Number(config.fontColor);
			var bold : Boolean = false;
			var boldStr : String = config.bold;
			if( StringUtil.trim(boldStr) == "true" ){
				bold = true;
			}
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
					var nodeSy : SimpleMarkerSymbol = new SimpleMarkerSymbol(style,size,color);
					var node : Graphic = new Graphic(mapPoint,nodeSy);
					layer.add(node);
					vec.push(node);
				}
				if(isShowText){
					var text : String = capital.name;
					var result : String = text;
					var textYchange : Number = textYpos;
					if( text && text.length > 6 ){
						var textArr : Array = new Array();
						var group : int = text.length/6;
						for(var i : int=0;i<group;i++ ){
							var childStr : String = text.substr(i*6,6);
							textArr.push(childStr);
						}
						
						var myFunction:Function = function(item:String, index:int, array:Array):void {
							if( index == 0 ){
								result = item;
							}else{
								result = result + "\n" + item;
							}
						}
						textArr.map(myFunction);
						textYchange = textYchange *2;
					}
					var textSy : TextSymbol = new TextSymbol(result,null,0,1,false,0,false,16777215,"middle",1,textXpos,textYchange,new TextFormat(fontFamily,fontSize,fontColor,bold,null, null, null, null, "center"));
					var textGraphic : Graphic = new Graphic(CoordinateUtil.jingwei2MoQia(capital.gisLatitude,capital.gisLongitude,new SpatialReference(102100)),textSy);
					layer.add(textGraphic);
					vec.push(textGraphic);					
				}

			}
			log(message+"添加成功！！！");
		}
		
		/**
		 *	画省边界线
		 *  @param boundArr  线集合
		 */
		public function addBoundary(boundArr : ArrayCollection):void{
			var boundarLayer : GraphicsLayer = gisMap.getLayer("provinceBorder") as GraphicsLayer;
			var provinceBorderObj : Object = nodeConfig.border;
			addLines(boundarLayer,boundArr,borderVec,provinceBorderObj,"添加省边界线");
		}
		
		/**
		 *	添加城市边界线 
		 */
		public function addCityBorder(cityPointArr : ArrayCollection):void{
			var cityBoundaryLayer : GraphicsLayer = gisMap.getLayer("cityBoundary") as GraphicsLayer;
			var cityBorderConfig : Object = nodeConfig.cityBorder;
			addLines(cityBoundaryLayer,cityPointArr,cityBorderVec,cityBorderConfig,"添加城市边界线");
		}
		/**
		 *	添加县边界 
		 */
		public function addCountyBorder(countyArr : ArrayCollection):void{
			var countyBorderLayer : GraphicsLayer = gisMap.getLayer("countyBorder") as GraphicsLayer;
			var countyBorderConfig : Object = nodeConfig.CountyBorder;
			addLines(countyBorderLayer,countyArr,CountyPolygonVec,countyBorderConfig,"添加县边界线");
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
		 * 添加乡镇车道线 
		 */
		public function addXZCD(pointArr : ArrayCollection):void{
			var xzcdLayer : GraphicsLayer = gisMap.getLayer("xzcd") as GraphicsLayer;
			var config : Object = nodeConfig.xzcd;
			addLines(xzcdLayer,pointArr,xzcdVec,config,"添加乡镇车道");
		}
		/**
		 *	添加加油站 
		 */
		public function addGasStation(pointArr : ArrayCollection):void{
			var commonLayer : GraphicsLayer = gisMap.getLayer("common") as GraphicsLayer;
			var config : Object = nodeConfig.gasStation;
			addPoint(commonLayer,pointArr,config,"添加加油站",gasStationVec);
		}
		/**
		 * 添加金融服务中心点 
		 */
		public function addFinancePoint(pointArr:ArrayCollection):void{
			var commonLayer : GraphicsLayer = gisMap.getLayer("common") as GraphicsLayer;
			var config : Object = nodeConfig.financePoint;
			addPoint(commonLayer,pointArr,config,"添加金融服务中心",financePointVec);
		}
		/**
		 * 添加九级路点 
		 */
		public function addNineGrade(pointArr:ArrayCollection):void{
			var commonLayer : GraphicsLayer = gisMap.getLayer("common") as GraphicsLayer;
			var config : Object = nodeConfig.nineGrade;
			addLines(commonLayer,pointArr,nineGradeVec,config,"添加九级路点");
		}
		
		/**
		 *	添加线 
		 */
		private function addLines(layer:GraphicsLayer,pointArr : ArrayCollection,vec : Vector.<Graphic>,config : Object,message:String):void{
			var starTime : Number = new Date().getTime();
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
			var lineBorderColor : uint = uint(config.color);
			
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
				if( i < pointArr.length-1 ){
					var arr : Array = [];
					arr.push(CoordinateUtil.jingwei2MoQia(pointArr[i].gisLatitude,pointArr[i].gisLongitude));
					arr.push(CoordinateUtil.jingwei2MoQia(pointArr[i+1].gisLatitude,pointArr[i+1].gisLongitude));
					var myPolyLine : Polyline = new Polyline([arr],new SpatialReference(102100));
					var lineSy : SimpleLineSymbol = new SimpleLineSymbol("normal",lineBorderColor,lineBorderAlpha,lineBoderWidth);
					var myGraphicLine : Graphic = new Graphic(myPolyLine,lineSy);
					layer.add(myGraphicLine);
					vec.push(myGraphicLine);
				}
			}
			var endTime : Number = new Date().getTime();
			log("这条线加载了:"+pointArr.length+"数据,耗时"+(endTime - starTime)+"毫秒");
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
			//县
			var townLayer : GraphicsLayer = gisMap.getLayer("town") as GraphicsLayer;
			if( townLayer && townPointsVec && townPointsVec.length > 0 ){
				for each( var townPoint : Graphic in townPointsVec ){
					townLayer.remove(townPoint);
					townPoint.geometry = null;
					townPoint.symbol = null;
					townPoint = null;
				}
				townPointsVec = null;
				townPointsVec = new Vector.<Graphic>();
			}
			//乡镇车道
			var xzcdLayer : GraphicsLayer = gisMap.getLayer("xzcd") as GraphicsLayer;
			if( xzcdLayer && xzcdVec && xzcdVec.length > 0 ){
				for each( var xzcdPoint : Graphic in xzcdVec ){
					xzcdLayer.remove(xzcdPoint);
					xzcdPoint.geometry = null;
					xzcdPoint.symbol = null;
					xzcdPoint = null;
				}
				xzcdVec = null;
				xzcdVec = new Vector.<Graphic>();
			}
			
			// 删除加油站
			var commonLayer : GraphicsLayer = gisMap.getLayer("common") as GraphicsLayer;
			if( gasStationVec && gasStationVec.length > 0 && commonLayer  ){		
				for each( var gasNode : Graphic in gasStationVec ){
					commonLayer.remove(gasNode);
					gasNode.geometry = null;
					gasNode.symbol = null;
					gasNode = null;
				}
				gasStationVec = null;
				gasStationVec = new Vector.<Graphic>();
			}
			// 删除金融中心
			if( financePointVec && financePointVec.length > 0 && commonLayer ){
				for each( var financeNode : Graphic in financePointVec ){
					commonLayer.remove(financeNode);
					financeNode.geometry = null;
					financeNode.symbol = null;
					financeNode = null;
				}
				financePointVec = null;
				financePointVec = new Vector.<Graphic>();
			}
			// 删除九级道路点
			if( nineGradeVec && nineGradeVec.length > 0 && commonLayer ){
				for each( var nineGradeNode : Graphic in nineGradeVec ){
					commonLayer.remove(nineGradeNode);
					nineGradeNode.geometry = null;
					nineGradeNode.symbol = null;
					nineGradeNode = null;
				}
				nineGradeVec = null;
				nineGradeVec = new Vector.<Graphic>();
			}
			
			System.gc();
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