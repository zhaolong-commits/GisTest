package manager
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.PNGEncoder;
	
	import Config.PathManager;
	
	import Utils.LogManager;
	
	import arcGis.ArcGisMap;
	
	public class FileManager extends EventDispatcher
	{
		public function FileManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private static var instance : FileManager;
		
		public static function getInstance():FileManager{
			if( instance == null ){
				instance = new FileManager();
			}
			return instance;
		}
		private var basePath:String = "mapImages";
		
		public var gisMap : ArcGisMap;
		
		public function saveImage(component:IBitmapDrawable,x:Number,y:Number):void{
			
			var bitmapData:BitmapData = new BitmapData(256,256,true,0);
			var matrix:Matrix = new Matrix();
			matrix.translate(x,y);
			bitmapData.draw(component,matrix);
			
			var encoder:PNGEncoder = new PNGEncoder();
			var bytes:ByteArray = encoder.encode(bitmapData);
			
			var resultAddress : String = PathManager.getInstance().getValue("destination");
			var file:File;
			if( resultAddress ){
				file = new File(resultAddress+File.separator+basePath+File.separator+gisMap.level+File.separator+gisMap.currentCol+File.separator+gisMap.currentRow+".png");
			}else{
				file = new File(File.desktopDirectory.resolvePath(basePath+File.separator+gisMap.level+File.separator+gisMap.currentCol+File.separator+gisMap.currentRow+".png").nativePath);
			}
			bitmapData.dispose();
			bitmapData = null;
			
			LogManager.getInstance().onLogMessage("保存的图片为:"+file.nativePath)
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.WRITE);
			fileStream.writeBytes(bytes,0,bytes.bytesAvailable);
			fileStream.close();
			
			gisMap.newMoveTile();
		}
		
		public function saveLittleImage(component:IBitmapDrawable,width:Number,height:Number,index:Number):void{
			var bitmapData:BitmapData = new BitmapData(width,height,true,0);
			var matrix:Matrix = new Matrix();
			matrix.translate(0,0);
			bitmapData.draw(component,matrix);
			
			var encoder:PNGEncoder = new PNGEncoder();
			var bytes:ByteArray = encoder.encode(bitmapData);
			
			var resultAddress : String = PathManager.getInstance().getValue("destination");
			var file:File;
			if( resultAddress ){
				file = new File(resultAddress+File.separator+basePath+File.separator+gisMap.level+File.separator+gisMap.currentCol+File.separator+gisMap.currentRow+"-"+index+".png");
			}else{
				file = new File(File.desktopDirectory.resolvePath(basePath+File.separator+gisMap.level+File.separator+gisMap.currentCol+File.separator+gisMap.currentRow+"-"+index+".png").nativePath);
			}
			bitmapData.dispose();
			bitmapData = null;
			
			LogManager.getInstance().onLogMessage("保存的图片为:"+file.nativePath)
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.WRITE);
			fileStream.writeBytes(bytes,0,bytes.bytesAvailable);
			fileStream.close();
		}

	}
}