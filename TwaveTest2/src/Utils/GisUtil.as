package Utils
{
	public class GisUtil
	{
		public function GisUtil()
		{
		}
		/**
		 * 根据行列获取地图坐标
		 * @param x : 列
		 * @param y : 行
		 * @return 地图坐标集合，第一个参数是经度，第二个参数是纬度
		 */
		public static function getCenterLngLatOfGridandZooms(x:int, y:int, zoom:int):Array{
			
			var lnglat:Array= [];
			var pow:Number=Math.pow(2, zoom);
//			var lngpre:Number=Math.abs(180-360*x/pow);
			var lngpre:Number=-(180-360*x/pow);
			lnglat[0]=lngpre;
			
			var exp:Number = Math.exp((1-2*y/pow)*Math.PI*2);
			var tmp:Number = (exp-1)/(1+exp);
			var latpre:Number = Math.asin(tmp)*180/Math.PI;
			lnglat[1]=latpre;
			
			return lnglat;
		}
		
		/**
		 *  根据坐标点获取行列
		 *	@param lng:经度
		 *  @param lat:纬度
		 *  @param zoom: 地图当前级别
		 *  @return 返回行列集合 第一个参数是列，第二个参数是行
		 */
		public static function getGridsOfZooms( lng:Number,  lat:Number,  zoom:int):Array{
			
			var gridxy:Array = [];
			var pow:Number= Math.pow(2,zoom);
			
			gridxy[0]=(int) (((180 + lng)*pow)/360);
			
			var phi:Number = Math.PI * lat / 180;
			var res:Number = 0.5 * Math.log((1 + Math.sin(phi)) / (1 - Math.sin(phi)));
			gridxy[1]= (int)(((1 - res / Math.PI) / 2) * pow);
			
			return gridxy;
		}
	}
}