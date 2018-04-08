package GisDataProcess
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.DragEvent;
	import mx.utils.StringUtil;
	
	import Utils.GisUtil;
	
	import arcGis.ArcGisMap;
	
	import cn.zhrz.arcgis.LogManager;
	
	import manager.NodeAndLineManager;

	public class MethodManager extends EventDispatcher
	{
		public function MethodManager()
		{
			super();
		}
		
		private static var instance : MethodManager;
		
		public static function getInstance():MethodManager{
			if( instance == null ){
				instance = new MethodManager();
			}
			return instance;
		}
		
		public var loadObj : Object;
		
		private var _gisMap : ArcGisMap;

		public function get gisMap():ArcGisMap
		{
			return _gisMap;
		}

		public function set gisMap(value:ArcGisMap):void
		{
			_gisMap = value;
			if( _gisMap ){
				_gisMap.addEventListener("saveOneAreaSuccessed",savePictureSuccessed);
			}
		}

		
		/**
		 *	先加载火车站，飞机场，省会，城市，县市，乡镇等点
		 */
		public function firstCall():void{
			for( var key : String in loadObj ){
				
				if( key == "isAddSite" ){
					getSite();
				}
				if(key == "isAddAirPort"){
					getAirPort();
				}
				
				if( key == "isAddCapital" ){
					getCapital();
				}
				if( key == "isAddCity" ){
					getCityName();
				}
				if( key == "isAddArea" ){
					getArea();
				}
				if(key == "isAddCounty"){
					getCounty();
				}
//				if( key == "isAddTown" ){
//					getTown();
//				}
				if( key == "isAddStreet" ){
					getStreet();
				}
			}
		}
		
		/**
		 *	添加省界，城市边界，县界 
		 * 	铁路，高速公路，国道，省道，城市快速车道，县道 等需要重复调用的方法
		 *  新添加油站，服务点，九级道路
		 */
		public function CallMethod():void{
			if( !hasKey(loadObj) ){
//				saveImage();
				dispatchEvent(new DrawEvent("drawSuccessed",isDivided,currentIndex));
			}
			transformRowAndCol();
			dealSpecialRowAndCol();
			loadData();
		}
		
		private function loadData():void{
			for( var key : String in loadObj ){
				//添加省界，城市边界，县边界
				if( key == "isAddBounder" && loadObj[key] == false ){
//					if( gisMap.level > 4 ){
						getAreaProvince();
//					}else{
//						getProvincialLineInMaxMinCoordinate();
//					}
					return;
				}
				
				if( key == "isAddCityBorder" && loadObj[key] == false ){
					getCityPoints();
					return;
				}
				if( key == "isAddCountyBorder" && loadObj[key] == false ){
					getCountyBorder();
					return;
				}
				
				//铁路，高速公路，国道，省道，城市快速车道，县道
				if( key == "isAddrailway" && loadObj[key] == false ){
					getRoadLines();
					return;
				}
				if( key == "isAddHighwayLine" && loadObj[key] == false ){
//					getHeightwayLines();
					getHeightwayLinse2();
					return;
				}
				if( key == "isAddNationalHighwayLine" && loadObj[key] == false ){
//					getNationalHighwayLine();
					getNationalHighwayLine2();
					return;
				}
				if( key == "isAddProvincialHighway" && loadObj[key] == false ){
//					getProvincialHighway();
					getProvincialHighway2();
					return;
				}
				if( key == "isAddExpressway" && loadObj[key] == false ){
//					getExpressway();
					getExpressway2();
					return;
				}
				if( key == "isAddCountyHighway" && loadObj[key] == false ){
//					getCountyHighway();	
					getCountyHighway2();
					return;
				}
				// 乡道
				if( key == "isAddTown" && loadObj[key] == false ){
					getAreaTown();
				}
				// 乡村道路
				if( key == "isAddXZCD" && loadObj[key] == false ){
					getAreaXZCD();
				}
				
				// 是否添加加油站 
				if( key == "isAddGasStation" && loadObj[key] == false ){
					getGasStation();
				}
				// 是否添加金融中心
				if( key == "isAddFinance" && loadObj[key] == false ){
					getFinancePoint();
				}
				// 是否添加九级路点
				if( key == "isAddNineGrade" && loadObj[key] == false ){
					getNineGradePoint();
				}
			}
		}
		
		/**
		 *	判断是否存在需要重复调用的方法 （火车站，飞机场，省会，城市，县市等一次加载的不需要重复加载）
		 */
		private function hasKey(obj:Object):Boolean{
			var bol : Boolean = false;
			if( obj == null ){
				return bol
			}
			for( var key : String in obj ){
				if( key != "isAddSite" && key !="isAddAirPort" && key !="isAddCapital" && key != "isAddCity" && key != "isAddArea" && key != "isAddCounty" && key != "isAddStreet" ){
					bol = true;
					break;
				}
			}
			return bol;
		}		
		//添加火车站点
		private function getSite():void{
			ParseGisData.getAllRailwayStn(addSitePoint);
		}
		//添加飞机场
		private function getAirPort():void{
			ParseGisData.getAllAirportStn(addAirPort);
		}
		
		//添加省会			
		private function getCapital():void{
			ParseGisData.getAllProvinicalCapitals(getCaptialRebackFun);
		}
		//查询城市
		private function getCityName():void{
			ParseGisData.getAllCityPoints(getAllCityPointsReback);
		}
		//添加区
		private function getArea():void{
			ParseGisData.getAllAreaPoints(getAllAreaPointsReback);
		}
		
		//添加县
		private function getCounty():void{
			ParseGisData.getAllCountyPoints(getCountyReback);
		}
		//添加乡镇
		private function getTown():void{
			ParseGisData.getAllTownPoints(getTownReback);
		}
		
		//添加街道
		private function getStreet():void{
			ParseGisData.getAllStreetPoints(getStreetReback);
		}
		
		//添加飞机场
		private function addAirPort( airArr : ArrayCollection ):void{
			if( airArr && airArr.length > 0 ){
				NodeAndLineManager.getInstance().addAirPort(airArr);
			}
			else{
				onlog("添加飞机场点失败");
			}
			loadObj.isAddAirPort = true;
		}
		
		//添加火车站点
		private function addSitePoint(siteArr : ArrayCollection):void{
			if( siteArr && siteArr.length > 0 ){
				NodeAndLineManager.getInstance().addSite(siteArr);
			}else{
				onlog("添加火车站点失败！！！");
			}
			loadObj.isAddSite = true;
		}
		
		//获取省会的返回点
		private function getCaptialRebackFun(capitalArr : ArrayCollection):void{
			if( capitalArr == null || capitalArr.length <= 0 ){
				onlog("获取省会失败！");
			}else{
				NodeAndLineManager.getInstance().addCapitalPoint(capitalArr);
			}
			loadObj.isAddCapital = true;
		}
		
		//添加城市名
		private function getAllCityPointsReback(cityArr : ArrayCollection):void{
			if( cityArr && cityArr.length > 0 ){
				NodeAndLineManager.getInstance().addCity(cityArr);
			}else{
				onlog("获取城市集合失败！！！！！！");
			}
			loadObj.isAddCity = true;
		}
		//获取所有的区
		private function getAllAreaPointsReback(areaArr : ArrayCollection):void{
			if( areaArr && areaArr.length > 0 ){
				NodeAndLineManager.getInstance().addArea(areaArr);
			}else{
				onlog("获取区点集合失败！！！！！！");
			}
			loadObj.isAddArea = true;
		}
		//添加县市
		private function getCountyReback( countyArr : ArrayCollection ):void{
			if( countyArr && countyArr.length > 0 ){
				NodeAndLineManager.getInstance().addCounty(countyArr);
			}else{
				onlog("获取县失败!!!");
			}
			loadObj.isAddCounty = true;
		}
		//获取乡镇
		private function getTownReback( townArr : ArrayCollection ):void{
			if( townArr && townArr.length > 0 ){
				NodeAndLineManager.getInstance().addTown(townArr);
			}else{
				onlog("添加乡镇失败！！！");
			}
			loadObj.isAddTown = true;
		}
		//获取街道
		private function getStreetReback(streetArr : ArrayCollection):void{
			if( streetArr && streetArr.length > 0 ){
				NodeAndLineManager.getInstance().addStreet(streetArr);
			}else{
				onlog("添加乡镇失败！！！");
			}
			loadObj.isAddStreet = true;
		}
		
		//边界线
		//单独调用画省边线
		private function getAreaProvince():void{
			ParseGisData.getAreaRangeProvincePolygonIds(lonAndLatArr,getAreaProvinceReback);	
		}	
		//省边界线
		private function getProvincialLineInMaxMinCoordinate():void{
			ParseGisData.getProvincialLineInMaxMinCoordinate(lonAndLatArr,getAreaProvinceReback2);
		}
		//查询市边界线
		private function getCityPoints():void{
			ParseGisData.getAreaRangeCityPolygonPoints(lonAndLatArr,getCityPointsReback);
		}
		//添加县市边界
		private function getCountyBorder():void{
			ParseGisData.getAreaRangeCountyPolygonPoints(lonAndLatArr,getCountyBorderReback);
		}
		
		/**
		 * 获取边线成功回调函数
		 */
		private function getAreaProvinceReback(lineArr : ArrayCollection):void{
			
			if( lineArr == null || lineArr.length <=0 ){
				LogManager.getInstance().onLogMessage("当前区域没有边界线");
			}else{
				onlog("当前区域共有"+lineArr.length+"个边界线！！");
				for( var i :int = 0; i< lineArr.length; i++ ){
					onlog("添加第"+(i+1)+"个边界线！！");
					NodeAndLineManager.getInstance().addBoundary(lineArr[i]);
				}
				onlog("当前区域"+lineArr.length+"个边界线加载成功！！");
			}
			loadObj.isAddBounder = true;
			checkIsAllLoad();
		}
		
		/**
		 * 获取边线成功回调函数2
		 */
		private function getAreaProvinceReback2(lineArr : ArrayCollection):void{
			var eventName : String = "addProvince";
			DataUtil.getInstance().addEventListener(eventName,addProvinceSuccessed);
			DataUtil.getInstance().getDataAndDrawLine(lineArr,ParseGisData.getProvincialLinePointById,NodeAndLineManager.getInstance().addBoundary,eventName,"添加省界");
		}
		private function addProvinceSuccessed(e:Event):void{
			DataUtil.getInstance().removeEventListener("addProvince",addProvinceSuccessed);
			loadObj.isAddBounder = true;
			checkIsAllLoad();
		}
		//-------------------------------------------------区域内的城市快速车道-----------------------------------------------------------//
		private function getExpresswayReback(lineArr : ArrayCollection):void{
			var eventName : String = "addExpressway";
			DataUtil.getInstance().addEventListener(eventName,addExpressWaySuccessed);
			DataUtil.getInstance().getDataAndDrawLine(lineArr,ParseGisData.getExpresswayLinePointById,NodeAndLineManager.getInstance().addExpresswayLine,eventName,"城市快线");
		}
		private function addExpressWaySuccessed(e:Event):void{
			DataUtil.getInstance().removeEventListener("addExpressway",addExpressWaySuccessed);
			loadObj.isAddExpressway = true;
			checkIsAllLoad();
		}
		//获取城市快车道回调方法2
		private function getExpresswayReback2(pointArr:ArrayCollection):void{
			if( pointArr == null || pointArr.length <=0 ){
				LogManager.getInstance().onLogMessage("当前区域没有城市快车道线");
			}else{
				onlog("当前区域共有"+pointArr.length+"个城市快车道线！！");
				for( var i :int = 0; i< pointArr.length; i++ ){
					onlog("添加第"+(i+1)+"个城市快车道线！！");
					NodeAndLineManager.getInstance().addExpresswayLine(pointArr[i]);
				}
				onlog("当前区域"+pointArr.length+"个城市快车道线加载成功！！");
			}
			loadObj.isAddExpressway = true;
			checkIsAllLoad();
		}
		
		//添加城市边界
		private function getCityPointsReback(cityPointArr : ArrayCollection):void{
			if( cityPointArr && cityPointArr.length > 0 ){
				onlog("当前区域共有"+cityPointArr.length+"个城市边界线！！");
				for( var i :int = 0; i< cityPointArr.length; i++ ){
					onlog("添加第"+(i+1)+"个边界线！！");
					NodeAndLineManager.getInstance().addCityBorder(cityPointArr[i]);
				}
				onlog("当前区域"+cityPointArr.length+"个城市边界线加载成功！！");
			}else{
				onlog("该区域内没有城市边界线！");
			}
			loadObj.isAddCityBorder = true;
			checkIsAllLoad();
		}
		
		//添加县市边界
		private function getCountyBorderReback(countyArr : ArrayCollection):void{
			if( countyArr && countyArr.length > 0 ){
				var i : int = 1;
				onlog("当前区域共有"+countyArr.length+"个县边界线！！");
				for each( var item : ArrayCollection in countyArr ){
					onlog("添加第"+i+"条县市边界线");
					NodeAndLineManager.getInstance().addCountyBorder(item);
					i++;
				}
				onlog("当前区域"+countyArr.length+"个县边界线加载成功！！");
			}else{
				onlog("该区域没有县市边界线！！！！！！");
			}
			loadObj.isAddCountyBorder = true;
			checkIsAllLoad();
		}
		
		//铁路，高速，国道，省道，城市快速车道，县道
		//画铁路线
		private function getRoadLines():void{
			ParseGisData.getAreaLines(lonAndLatArr,getLinesSuccessed);
		}
		/****************************************添加高速道路***************************************************/
		private function getHeightwayLines():void{
			ParseGisData.getHighwayLineInMaxMinCoordinate(lonAndLatArr,getHeightwayLinesReback);
		}
		//添加高速道2
		private function getHeightwayLinse2():void{
			ParseGisData.getAreaRangeHightWayPoints(lonAndLatArr,getHeightwayLinesReback2);
		}
		/****************************************end***************************************************/
		//添加国道
		private function getNationalHighwayLine():void{
			ParseGisData.getNationalHighwayLineInMaxMinCoordinate(lonAndLatArr,getNationalHighwayLineReback);
		}
		//添加国道2
		private function getNationalHighwayLine2():void{
			ParseGisData.getAreaRangeNationalHighWayPoints(lonAndLatArr,getNationalHighwayLineReback2);
		}
		
		//添加省道
		private function getProvincialHighway():void{
			ParseGisData.getProvincialHighwayLineInMaxMinCoordinate(lonAndLatArr,getProvincialHighwayReback);
		}
		//获取省道2
		private function getProvincialHighway2():void{
			ParseGisData.getAreaRangeProvincialHighWayPoints(lonAndLatArr,getProvincialHighwayReback2);
		}
		//添加城市快速车道
		private function getExpressway():void{
			ParseGisData.getExpresswayLineInMaxMinCoordinate(lonAndLatArr,getExpresswayReback);
		}
		private function getExpressway2():void{
			ParseGisData.getAreaRangeExpressWayPoints(lonAndLatArr,getExpresswayReback2);
		}
		//添加县道路
		private function getCountyHighway():void{
			ParseGisData.getCountyHighwayLineInMaxMinCoordinate(lonAndLatArr,getCountyHighwayReback);
		}
		private function getCountyHighway2():void{
			ParseGisData.getAreaRangeCountyHighWayPoints(lonAndLatArr,getCountyHighwayReback2);
		}
		//获取区域内的乡镇
		private function getAreaTown():void{
			ParseGisData.getAreaTownPoints(lonAndLatArr,getAreaTownReback);
		}
		//获取区域内乡镇村道
		private function getAreaXZCD():void{
			ParseGisData.getAreaRangeXZCDPoints(lonAndLatArr,getAreaXZCDReback);
		}
		// 	获取区域内加油站
		private function getGasStation():void{
			ParseGisData.getAreaRangeGasStations(lonAndLatArr,getAreaGasStationReaback);
		}
		// 获取区域内金融中心
		private function getFinancePoint():void{
			ParseGisData.getAreaRangeFinancePoints(lonAndLatArr,getAreaFinanceReaback);
		}
		// 获取区域内九级道路点
		private function getNineGradePoint():void{
			ParseGisData.getAreaRangeNineGradePoints(lonAndLatArr,getAreaNineGradeReaback);
		}
		
		//-------------------------------------------------区域内的铁路线-----------------------------------------------------------//
		private var roadLineArr : ArrayCollection;
		private var lineLength:Number; 
		private var lineIndex: int = 0;
		private var resNum : int = 0;
		private function getLinesSuccessed(lineArr:ArrayCollection):void{
			if( lineArr == null || lineArr.length <= 0 ){
				LogManager.getInstance().onLogMessage("查询的区域没有铁路线！");
				loadObj.isAddrailway = true;
				checkIsAllLoad();
			}else{
				LogManager.getInstance().onLogMessage("查询的区域共有"+lineArr.length+"铁路线！");
				lineLength = lineArr.length;
				roadLineArr = lineArr;
				getPoint();
			}
		}
		private function getPoint():void{
			for( var i:int = lineIndex;i < roadLineArr.length;i++ ){
				lineIndex++;
				var lineID : String = roadLineArr[i].id;
				if( StringUtil.trim(lineID) != "" ){
					LogManager.getInstance().onLogMessage("根据线ID查询！线ID是："+lineID);
					ParseGisData.getPointByLineId(lineID,getPointByLineIDSuccessed);
				}
				if( lineIndex%20 == 0 ){
					break;	
				}
			}
		}
		private function getPointByLineIDSuccessed(pointArr : ArrayCollection):void{
			lineLength--;
			resNum++;	
			if( pointArr == null || pointArr.length <= 0 ){
				LogManager.getInstance().onLogMessage("查询的线没有点！");
				return;
			}
			NodeAndLineManager.getInstance().addNodeAndLine(pointArr);
			if( lineLength == 0 ){
				trace("当前区域的线画完了。");
				resNum = 0;
				lineIndex = 0;
				roadLineArr = null;
				loadObj.isAddrailway = true;
				checkIsAllLoad();
			}else{
				onlog("没有画完的铁路线:"+lineLength);
			}
			if( resNum == 20 ){
				resNum = 0;
				getPoint();
			}
		}
		//-------------------------------------------------区域内的高速-----------------------------------------------------------//
		private var heightWayLineArrLength:Number = 0;
		private var heightWayLineArr : ArrayCollection;
		private var wayLineIndex : int = 0;
		private var wayLineRes : int = 0;
		private function getHeightwayLinesReback(heightwayArr : ArrayCollection):void{
			if(heightwayArr == null || heightwayArr.length <= 0){
				onlog("高速路路段当前区域没有结果！！！");
				loadObj.isAddHighwayLine = true;
				checkIsAllLoad();
			}else{
				heightWayLineArrLength = heightwayArr.length;
				heightWayLineArr = heightwayArr;
				getEveryLineByID();
			}
		}
		private function getEveryLineByID():void{
			for( var i : int = wayLineIndex; i < heightWayLineArr.length;i++ ){
				wayLineIndex++;
				var lineId : String = heightWayLineArr[i].id;
				onlog("当前区域高速公路查询的线ID:"+lineId);
				ParseGisData.getHighwayLinePointById(lineId,getHeightWayPointByLineId);
				if( wayLineIndex%20 == 0 ){
					break;
				}
			}
		}
		private function getHeightWayPointByLineId(pointArr : ArrayCollection):void{
			heightWayLineArrLength--;
			wayLineRes++;
			if( pointArr == null || pointArr.length <= 0 ){
				onlog("查询的这个线段没有值！！");
				return;
			}
			NodeAndLineManager.getInstance().addHeightWayLine(pointArr);
			if( heightWayLineArrLength == 0 ){
				onlog("当前区域的高速路画完了！！！！");
				wayLineIndex = 0;
				wayLineRes = 0;
				heightWayLineArr = null;
				loadObj.isAddHighwayLine = true;
				checkIsAllLoad();
			}else{
				onlog("当前区域没有画完的高速线:"+heightWayLineArrLength);
			}
			if( wayLineRes == 20 ){
				wayLineRes = 0;
				getEveryLineByID();
			}
		}
		//获取区域内高速返回的结果集
		private function getHeightwayLinesReback2(lineArr : ArrayCollection):void{
			if( lineArr && lineArr.length > 0 ){
				var i : int = 1;
				onlog("当前区域共有"+lineArr.length+"条高速线段！！");
				for each( var item : ArrayCollection in lineArr ){
					onlog("添加第"+i+"条高速线");
					NodeAndLineManager.getInstance().addHeightWayLine(item);
					i++;
				}
				onlog("当前区域第"+lineArr.length+"个高速线加载成功！！");
			}else{
				onlog("该区域没有高速！！！！！！");
			}
			loadObj.isAddHighwayLine = true;
			checkIsAllLoad();
		}
		//-------------------------------------------------区域内的国道-----------------------------------------------------------//
		private function getNationalHighwayLineReback(lineArr : ArrayCollection):void{
			var eventName : String = "addNationalHighway";
			DataUtil.getInstance().addEventListener(eventName,addNationalHightwaySuccessed);
			DataUtil.getInstance().getDataAndDrawLine(lineArr,ParseGisData.getNationalHighwayLinePointById,NodeAndLineManager.getInstance().addNationalHeightWayLine,eventName,"国道");
		}
		private function addNationalHightwaySuccessed(e:Event):void{
			DataUtil.getInstance().removeEventListener("addNationalHighway",addNationalHightwaySuccessed);
			loadObj.isAddNationalHighwayLine = true;
			checkIsAllLoad();
		}
		private function getNationalHighwayLineReback2(lineArr : ArrayCollection):void{
			if( lineArr && lineArr.length > 0 ){
				var i : int = 1;
				onlog("当前区域共有"+lineArr.length+"条国道线段！！");
				for each( var item : ArrayCollection in lineArr ){
					onlog("添加第"+i+"条国道线");
					NodeAndLineManager.getInstance().addNationalHeightWayLine(item);
					i++;
				}
				onlog("当前区域第"+lineArr.length+"个国道线加载成功！！");
			}else{
				onlog("该区域没有国道！！！！！！");
			}
			loadObj.isAddNationalHighwayLine = true;
			checkIsAllLoad();
		}
		//-------------------------------------------------区域内的省道-----------------------------------------------------------//
		
		private function getProvincialHighwayReback(lineArr : ArrayCollection):void{
			var eventName : String = "addProvincialHighway";
			DataUtil.getInstance().addEventListener(eventName,addProvincialHighwaySuccessed);
			DataUtil.getInstance().getDataAndDrawLine(lineArr,ParseGisData.getProvincialHighwayLinePointById,NodeAndLineManager.getInstance().addProvincialHighwayLine,eventName,"省道");
		}
		private function addProvincialHighwaySuccessed(e:Event):void{
			DataUtil.getInstance().removeEventListener("addProvincialHighway",addProvincialHighwaySuccessed);
			loadObj.isAddProvincialHighway = true;
			checkIsAllLoad();
		}
		//获取区域内的省道回调函数2
		private function getProvincialHighwayReback2(lineArr : ArrayCollection):void{
			if( lineArr && lineArr.length > 0 ){
				var i : int = 1;
				onlog("当前区域共有"+lineArr.length+"条省道线段！！");
				for each( var item : ArrayCollection in lineArr ){
					onlog("添加第"+i+"条省道线");
					NodeAndLineManager.getInstance().addProvincialHighwayLine(item);
					i++;
				}
				onlog("当前区域第"+lineArr.length+"个省道线加载成功！！");
			}else{
				onlog("该区域没有省道！！！！！！！");
			}
			loadObj.isAddProvincialHighway = true;
			checkIsAllLoad();
		}
		//-------------------------------------------------区域内的县道-----------------------------------------------------------//
		private function getCountyHighwayReback(lineArr : ArrayCollection):void{
			var eventName : String = "addCountyHightWay";
			DataUtil.getInstance().addEventListener(eventName,addCountyHighWaySuccessed);
			DataUtil.getInstance().getDataAndDrawLine(lineArr,ParseGisData.getCountyHighwayLinePointById,NodeAndLineManager.getInstance().addCountyHighwayLine,eventName,"县道");
		}
		private function addCountyHighWaySuccessed(e:Event):void{
			DataUtil.getInstance().removeEventListener("addCountyHightWay",addCountyHighWaySuccessed);
			loadObj.isAddCountyHighway = true;
			checkIsAllLoad();
		}
		//获取区域内的县道回调函数2
		private function getCountyHighwayReback2(pointArr:ArrayCollection):void{
			if( pointArr && pointArr.length > 0 ){
				var i : int = 1;
				onlog("当前区域共有"+pointArr.length+"条县道线段！！");
				for each( var item : ArrayCollection in pointArr ){
					onlog("添加第"+i+"条县道线");
					NodeAndLineManager.getInstance().addCountyHighwayLine(item);
					i++;
				}
				onlog("当前区域第"+pointArr.length+"个县道线加载成功！！");
			}else{
				onlog("该区域没有县道！！！！！！！");
			}
			loadObj.isAddCountyHighway = true;
			checkIsAllLoad();
		}
		//添加区域内的乡镇点集合
		private function getAreaTownReback(pointArr:ArrayCollection):void{
			if( pointArr && pointArr.length > 0 ){
				onlog("当前区域共有"+pointArr.length+"乡镇点！！");
				NodeAndLineManager.getInstance().addTown2(pointArr);
			}else{
				onlog("该区域没有乡镇点！！！！！！！");
			}
			loadObj.isAddTown = true;
			checkIsAllLoad();
		}
		
		private function getAreaXZCDReback(pointArr:ArrayCollection):void{
			if( pointArr && pointArr.length > 0 ){
				var i : int = 1;
				onlog("当前区域共有"+pointArr.length+"条乡镇车道线段！！");
				for each( var item : ArrayCollection in pointArr ){
					onlog("添加第"+i+"条乡镇车道道线");
					NodeAndLineManager.getInstance().addXZCD(item);
					i++;
				}
				onlog("当前区域第"+pointArr.length+"个乡镇车道线加载成功！！");
			}else{
				onlog("该区域没有乡镇车道线！！！！！！！");
			}
			loadObj.isAddXZCD = true;
			checkIsAllLoad();
		}  
		// 获取区域内加油站回调函数
		private function getAreaGasStationReaback(pointArr:ArrayCollection):void{
			if( pointArr && pointArr.length > 0 ){
				onlog("开始添加加油站！！");
				NodeAndLineManager.getInstance().addGasStation(pointArr);
			}else{
				onlog("该区域没有加油站！！！！！！！");
			}
			loadObj.isAddGasStation = true;
			checkIsAllLoad();
		}
		// 获取区域内金融中心回调函数
		private function getAreaFinanceReaback(pointArr:ArrayCollection):void{
			if( pointArr && pointArr.length > 0 ){
				onlog("开始添加金融中心！！");
				NodeAndLineManager.getInstance().addFinancePoint(pointArr);
			}else{
				onlog("该区域没有金融中心！！！！！！！");
			}
			loadObj.isAddFinance = true;
			checkIsAllLoad();
		}
		// 获取区域内的九级道路点回调函数
		private function getAreaNineGradeReaback(pointArr:ArrayCollection):void{
			if( pointArr && pointArr.length > 0 ){
				var i : int = 1;
				onlog("当前区域共有"+pointArr.length+"条九级道路线段！！");
				for each( var item : ArrayCollection in pointArr ){
					onlog("添加第"+i+"条九级道路道线");
					NodeAndLineManager.getInstance().addNineGrade(item);
					i++;
				}
				onlog("当前区域第"+pointArr.length+"个九级道路线加载成功！！");
			}else{
				onlog("该区域没有九级道路线！！！！！！！");
			}
			loadObj.isAddNineGrade = true;
			checkIsAllLoad();
		}
		
		public var pos : Number;
		//当前行和列的经纬度
		public var lonAndLatArr : Array;
		//需要特殊处理的数据
		public var specialArr : Array;
		//分多少块
		public var block : Number;
		
		private var manyLoadArr : Array;
		/**
		 *	将行列转化成经纬度 
		 */
		private function transformRowAndCol():void{
			var startCol : Number = gisMap.currentCol;
			var startRow : Number = gisMap.currentRow;
			var zoom : Number = gisMap.level;
			
			var endCol : Number = startCol+1;
			var endRow : Number = startRow+1;
			var startCoordinateArr : Array = GisUtil.getCenterLngLatOfGridandZooms(startCol,startRow,zoom);
			LogManager.getInstance().onLogMessage("当前区域开始的坐标点："+startCoordinateArr);
			var endCoordinateArr : Array = GisUtil.getCenterLngLatOfGridandZooms(endCol,endRow,zoom);
			LogManager.getInstance().onLogMessage("当前区域结束的坐标点:"+endCoordinateArr);
			//经度
			var minLongitude : Number = startCoordinateArr[0] - pos;
			var maxLongitude : Number = endCoordinateArr[0] + pos;
			//纬度
			var minLatitude : Number = endCoordinateArr[1] - pos;
			var maxLatitude : Number = startCoordinateArr[1] + pos;
			
			lonAndLatArr = new Array();
			lonAndLatArr.push(minLongitude);
			lonAndLatArr.push(maxLongitude);
			lonAndLatArr.push(minLatitude);
			lonAndLatArr.push(maxLatitude);
		}
		private var isDivided : Boolean = false;
		
		private var currentIndex : Number = 0;
		
		public var lpos : Number = 0.1;
		public var rpos : Number = 0.1;
		public var tpos : Number = 0.1;
		public var bpos : Number = 0.1;
		private function dealSpecialRowAndCol():void{
			if( block > 0 ){
				if( specialArr.length == 0 ){
					calculate(block);
				}else{
					for each( var item : Object in specialArr ){
						if( gisMap.currentCol == Number(item.col) && gisMap.currentRow == Number(item.row) )
						{
							calculate(block);
							return;
						}
					}
				}
			}
		}
		/**
		 *	计算当前行列分块后的经纬度 
		 */
		private function calculate(block:Number):void{
			//平方根
			var sqrt : Number = Math.sqrt(block); 
			//单个经度
			var singleLongitude : Number = (lonAndLatArr[1] - lonAndLatArr[0] - ( 2 * pos ))/sqrt;
			//单个纬度
			var singleLatitude : Number = (lonAndLatArr[3] - lonAndLatArr[2] - ( 2 * pos ))/sqrt;
			
			manyLoadArr = new Array();
			
			for( var i : int = 0; i < sqrt ; i++ ){
				for( var j : int = 0;j < sqrt;j++ ){
					var oneArea : Object = new Object();
					
					oneArea.startLat = lonAndLatArr[2] + ((sqrt - i - 1)*singleLatitude) - bpos;
					oneArea.endLat = lonAndLatArr[2]  + (( sqrt - i) * singleLatitude) + tpos;
					
					oneArea.startLon = lonAndLatArr[0] + (j * singleLongitude) - lpos;
					oneArea.endLon = lonAndLatArr[0] + ((j+1)*singleLongitude) + rpos;
					
					manyLoadArr.push(oneArea);
				}
			}
			isDivided = true;
			
			lonAndLatArr = null;
			lonAndLatArr = new Array();
			
			lonAndLatArr.push(manyLoadArr[0].startLon);
			lonAndLatArr.push(manyLoadArr[0].endLon);
			lonAndLatArr.push(manyLoadArr[0].startLat);
			lonAndLatArr.push(manyLoadArr[0].endLat);
		}
		
		private function savePictureSuccessed(e:Event):void{
			e.stopPropagation();
			currentIndex++;
			isDivided = false;
			if( currentIndex < manyLoadArr.length ){
				isDivided = true;
				lonAndLatArr = new Array();
				
				lonAndLatArr.push(manyLoadArr[currentIndex].startLon);
				lonAndLatArr.push(manyLoadArr[currentIndex].endLon);
				lonAndLatArr.push(manyLoadArr[currentIndex].startLat);
				lonAndLatArr.push(manyLoadArr[currentIndex].endLat);
				loadData();				
			}else{
				currentIndex = 0;
				manyLoadArr = null;
			}
		}
		
		/**
		 *	判断当前区域内的线是否全部加载成功！ 
		 */
		private function checkIsAllLoad():void{
			
			loadData();
			
			for each( var item : Boolean in loadObj){
				if( item == false ){
					return;
				}
			}
			for( var key : String in loadObj ){
				if( key != "isAddAirPort" && key != "isAddSite" && key != "isAddCapital" && key != "isAddCity" &&  key != "isAddCounty" && key != "isAddArea" && key != "isAddStreet"  ){
					loadObj[key] = false;
				}
			}
			
			dispatchEvent(new DrawEvent("drawSuccessed",isDivided,currentIndex));
		}

		private function onlog(message:String):void{
			LogManager.getInstance().onLogMessage(message);
		}
	}
}