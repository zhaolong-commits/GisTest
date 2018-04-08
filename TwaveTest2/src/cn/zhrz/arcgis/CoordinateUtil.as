package  cn.zhrz.arcgis
{
	import com.esri.ags.SpatialReference;
	import com.esri.ags.geometry.MapPoint;

	public class CoordinateUtil
	{
		 
		
		static var M_PI:Number=Math.PI;
		//经纬度转墨卡托
		// 经度(lon)，纬度(lat)		
		public static function lon2Mercator(lon:Number):Number
		{
			var x:Number = lon *20037508.342789/180;
			
			return x;
		}
		
		public static function lat2Mercator(lat:Number):Number
		{
			var y:Number = Math.log(Math.tan((90+lat)*M_PI/360))/(M_PI/180);
			y = y *20037508.34789/180;
			
			return y;
		}
		
		
		public static function jingwei2MoQia(latitude:Number,longitude:Number,spatialReference:SpatialReference = null):MapPoint{
			var point:MapPoint = new MapPoint();
			point.y = lat2Mercator(latitude);
			point.x = lon2Mercator(longitude);
			point.spatialReference = spatialReference;
			return point;
		}
		
		//墨卡托转经纬度
		
		public static function Mercator2Lon(mercatorX:Number):Number
		{
			var x:Number = mercatorX/20037508.34*180;
			
			return x;
		}
		
		public static function Mercator2Lat(mercatorY:Number):Number
		{
			var y:Number = mercatorY/20037508.34*180;
			y= 180/M_PI*(2*Math.atan(Math.exp(y*M_PI/180))-M_PI/2);
			
			return y;
		}
	}
}