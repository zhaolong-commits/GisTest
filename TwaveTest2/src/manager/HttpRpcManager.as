package manager
{
	import mx.rpc.AbstractOperation;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.remoting.RemoteObject;
	import mx.utils.StringUtil;
	
	import cn.zhrz.arcgis.LogManager;

	public class HttpRpcManager
	{
		private static var instance : HttpRpcManager;

		public static function getInstance():HttpRpcManager{
			if( instance == null ){
				instance = new HttpRpcManager();	
			}
			return instance;
		}
		private var _endPoint : String;
		
		public function get endPoint():String
		{
			return _endPoint;
		}
		
		public function set endPoint(value:String):void
		{
			_endPoint = value;
			if( StringUtil.trim(_endPoint) != "" ){
				createRemoteObject(_endPoint);
			}else{
				LogManager.getInstance().onLogMessage("服务地址为null！");
			}
		}
		
		private var remoteObj : RemoteObject;
		private var aop : AbstractOperation;
		
		private function createRemoteObject(point : String):void{
			remoteObj = new RemoteObject();
			remoteObj.endpoint = point;
			remoteObj.destination = "sourceService";
			aop = remoteObj.getOperation("runRemoteMethod");
		}
		/**
		 *	执行远程方法调用
		 *	@param pkgName 包名
		 * 	@param methodName 方法名
		 * 	@param successedFun 成功回调函数
		 * 	@param failtFun 失败回调函数
		 * 	@param args 参数数组 
		 */
		public function executeHttpRpc(pkgName:String,methodName:String,successedFun:Function,failtFun:Function,args:Array=null):void{
			var responder : Responder = new Responder(successedFun,failtFun);
			var token : AsyncToken = aop.send(pkgName,methodName,args);
			token.addResponder(responder);
		}
	}
}