package manager
{
	import mx.rpc.Responder;
	import mx.rpc.remoting.RemoteObject;
	
	public class MetaResponder extends Responder
	{
		public var param:Object;
		public var remoteObject:RemoteObject;
		public function MetaResponder(result:Function, fault:Function, _param:Object = null, _rmtObj:RemoteObject = null)
		{
			super(result, fault);
			this.param = _param;
			this.remoteObject = _rmtObj;
		}
	}
}