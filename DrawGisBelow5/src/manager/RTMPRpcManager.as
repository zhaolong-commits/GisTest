package manager
{	
	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.rpc.AsyncToken;
	import mx.rpc.Fault;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	import Utils.LogManager;
		
	public class RTMPRpcManager extends EventDispatcher
	{
		private static var instance:RTMPRpcManager;
		public var alertInstance:*;
		
		public static function getInstance():RTMPRpcManager {
			if(instance==null) {
				instance = new RTMPRpcManager();
			}
			return instance;
		}
		
		private const LOG_NAMESPACE:String = "RTMPRpcManager";
		public function logInfo(info:String):void {
//			LogManager.getInstance().logInfo(info, LOG_NAMESPACE);
			LogManager.getInstance().onLogMessage(info);
		}
		
		private function transferToArrayCollection(data:Object):* {
			if (data is Number || data is String || data is int || data is Boolean) {
				return data;
			} else if (data is Array) {
				var newData:ArrayCollection = new ArrayCollection();
				for each (var item:Object in data) {
					var res:* = transferToArrayCollection(item);
					newData.addItem(res);
				}
				return newData;
			} else {
				for (var key:String in data) {
					if (data[key] is Array) {
						var newArr:* = transferToArrayCollection(data[key]);
						data[key] = newArr;
					}
				}
				return data;
			}
		}
		private var tempRequestArr : ArrayCollection = new ArrayCollection();
		private var callTimer : Timer = new Timer(3000,1);
		private var requestTimer : Timer = new Timer(500);
		
		private var resNum : int = 0;
		private var reqNum : int = 0;
		private var allCompleted : Boolean = false;
		
		public function executeRtmpRpc2(url:String,methodName:String,responder:MetaResponder,args:Array, token:AsyncToken,call:Boolean = false,init:Boolean=false,complete:Boolean = false):AsyncToken {
			if (connectMap.hasOwnProperty(url)) {
				var connect:NetConnection = connectMap[url] as NetConnection;
				if (connect.connected) {
					if( call ){
						var successFn:Function = function(data){
							var newData:Object = transferToArrayCollection(data);
							if( init ){
								resNum++;
								if( reqNum == resNum ){
									allCompleted = true;
								}
							}
							var successEvent:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, newData, token, null);
							responder.result(successEvent);
							RTMPRpcManager.getInstance().dispatchEvent(new RpcEvent("rtmpResponse",token));
							if( complete && allCompleted && tempRequestArr.length == 0 ){
								RTMPRpcManager.getInstance().dispatchEvent(new RpcEvent("rtmpComplete"));
								callTimer.stop();
								callTimer = null;
								requestTimer.stop();
								requestTimer = null;
								reqNum = resNum = 0;
								allCompleted = null;
							}
						}
						var failureFn:Function = function(err) {
							var fault:Fault = new Fault(err.code, err.application, err.description);
							var failureEvent:FaultEvent = new FaultEvent(FaultEvent.FAULT, false, true, fault, token, null);
							responder.fault(failureEvent);
						}
						if( init ){
							reqNum++;
						}
						this.dispatchEvent(new RpcEvent("rtmpRequest",token));
						switch(args.length) {
							case 0:
								connect.call(methodName, new Responder(successFn, failureFn));
								break;
							case 1:
								connect.call(methodName, new Responder(successFn, failureFn), args[0]);
								break;
							case 2:
								connect.call(methodName, new Responder(successFn, failureFn), args[0], args[1]);
								break;
							case 3:
								connect.call(methodName, new Responder(successFn, failureFn), args[0], args[1], args[2]);
								break;
							case 4:
								connect.call(methodName, new Responder(successFn, failureFn), args[0], args[1], args[2], args[3]);
								break;
							case 5:
								connect.call(methodName, new Responder(successFn, failureFn), args[0], args[1], args[2], args[3], args[4]);
								break;
						}
					}else{
						if( tempRequestArr.length == 0 && callTimer.running == false ){
							callTimer.addEventListener(TimerEvent.TIMER_COMPLETE,loopRequest);
							callTimer.start();
						}
						tempRequestArr.addItem({"url":url, "methodName":methodName, "responder":responder, "args":args, "token":token,"call":call,"init":init,"complete":complete});
					}
				}else {
					pendingRequestArr.addItem({"url":url, "methodName":methodName, "responder":responder, "args":args, "token":token});
				}
			} else {
				var fault2:Fault = new Fault("999", "RTMPRpc调用失败","找不到"+url+"对应的NetConnection对象");
				var failureEvent2:FaultEvent = new FaultEvent(FaultEvent.FAULT, false, true, fault2, token, null);
				responder.fault(failureEvent2);
				logInfo("找不到"+url+"对应的NetConnection对象");
			}
			return token;
		}
		
		private function loopRequest(e:TimerEvent):void{
			if( tempRequestArr.length > 0 ){
				for( var i:int=0; i < 50 && i < tempRequestArr.length; i++ ){
					var obj : Object = tempRequestArr.getItemAt(i);
					executeRtmpRpc2(obj.url,obj.methodName,obj.responder,obj.args,obj.token,true,true,obj.complete);
				}
				if( requestTimer.running == false ){
					requestTimer.addEventListener(TimerEvent.TIMER,judge);
					requestTimer.start();
				}
				if( tempRequestArr.length <= 50 ){
					tempRequestArr.removeAll();
				}else{
					tempRequestArr.source.splice(0,50);
				}
			}
		}
		
		private function judge(e:TimerEvent):void{
			if( allCompleted ){
				loopRequest(null);
				allCompleted = false;
			}
		}
		
		public function executeRtmpMethod(remoteObj:NetConnection, url:String, methodName:String, responder:MetaResponder, args:Array):AsyncToken {
			var token:AsyncToken = new AsyncToken();
			token.remoteObject = remoteObj;
			token.url = url;
			token.addResponder(responder);
			token.method = methodName;
			token.args = args;
			executeRtmpRpc2(url, methodName, responder, args, token);
			return token;
		}
		
		public function executeRtmpRpc(url:String,pkgName:String,methodName:String,compResult:Function,args:Array,coordinator:*=null,oldToken:AsyncToken=null):AsyncToken {
			var token:AsyncToken = null;
			if (oldToken == null) {
				token = new AsyncToken();
			} else {
				token = oldToken;
			}
			if (connectMap.hasOwnProperty(url)) {
				var connect:NetConnection = connectMap[url] as NetConnection;
				if (connect.connected) {
					var successFn:Function = function(data){
						if (data && data.hasOwnProperty("result")) {
//							var rpcResult:String = JSON.stringify(data.result);
							logInfo("RTMPRPC Result pkg:"+methodDic[successFn].pkgName+", method:"+methodDic[successFn].methodName+", args:"+methodDic[successFn].args+",    result:"+ LOG_NAMESPACE);
						}
						delete methodDic[successFn];
						var newData:Object = null;
						if (data) {
							newData = data.result;
						}
						compResult(newData);
//						var successEvent:ResultEvent = new ResultEvent(ResultEvent.RESULT, false, true, newData, token, null);
//						compResult(successEvent);
					}
					var failureFn:Function = function(err) {
						logInfo("execure RTMPRPC Error, pkg:"+methodDic[failureFn].pkgName+", method:"+methodDic[failureFn].methodName+", args:"+methodDic[failureFn].args+",    error:"+err.message);
						delete methodDic[failureFn];
						var fault:Fault = new Fault(err.code, err.application, err.description);
//						var failureEvent:FaultEvent = new FaultEvent(FaultEvent.FAULT, false, true, fault, token, null);
						compResult(null);
					}
					methodDic[successFn] = {"pkgName":pkgName, "methodName":methodName, "args":args};
					methodDic[failureFn] = {"pkgName":pkgName, "methodName":methodName, "args":args};
					logInfo("execute RTMPRPC pkg:"+pkgName+", method:"+methodName+", args:"+args);
					callMethod(connect,"method.invoke",new Responder(successFn, failureFn), pkgName, methodName, args);
				} else {
					pendingRequests.addItem({"url":url,"pkgName":pkgName, "methodName":methodName, "compResult":compResult, "args":args,"token":token});
				}
			}
			else {
				var fault2:Fault = new Fault("999", "RTMPRpc调用失败","找不到"+url+"对应的NetConnection对象");
				var failureEvent2:FaultEvent = new FaultEvent(FaultEvent.FAULT, false, true, fault2, token, null);
//				compFault(failureEvent2);
				compResult(null);
				logInfo("找不到"+url+"对应的NetConnection对象");
			}
			return token;
		}
		
		private var methodDic:Dictionary = new Dictionary();
		private var loginToken:String = "";
		public function setToken(value:String):void {
			logInfo("旧token为:"+loginToken);
			logInfo("新token为:"+value);
			
			var newToken:String = value;
			if (newToken == null || newToken == "" || newToken == "null"){
				newToken = "";
			}
			if (loginToken == newToken) {
				return;
			}
			loginToken = newToken;
		}
		
		private var connectMap:Object = {};
		public function getConnect(url:String):RTMPNetConnection {
			if (connectMap.hasOwnProperty(url)) {
				return connectMap[url];
			} else {
				var connect:RTMPNetConnection = new RTMPNetConnection();
				connectMap[url] = connect;
				connect.client = this;
				connect.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onAsyncErrorHandler);
				connect.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
				connect.addEventListener(NetStatusEvent.NET_STATUS,onNetStatusHandler);
				
				var item:Object = getUrlPart(url);
				connectNetConnection(connect, item.url,item.params);
				return connect;
			}
		}
		
		public function connectNetConnection(nc:NetConnection,url:String,params:Array,loginToken:String=null):void {
			logInfo("rtmp连接地址为:"+url);
			if (params == null || params.length == 0) {
				nc.connect(url);
			} else {
				switch(params.length){
					case 1:
						nc.connect(url,params[0]);
						logInfo("rtmp连接传递的参数为:"+params[0]);
						break;
					case 2:
						nc.connect(url,params[0], params[1]);
						logInfo("rtmp连接传递的参数为:"+params[0]+" , "+params[1]);
						break;
					case 3:
						nc.connect(url,params[0], params[1], params[2]);
						logInfo("rtmp连接传递的参数为:"+params[0]+" , "+params[1]+" , "+params[2]);
						break;
					case 4:
						nc.connect(url,params[0], params[1], params[2], params[3]);
						logInfo("rtmp连接传递的参数为:"+params[0]+" , "+params[1]+" , "+params[2]+" , "+params[3]);
						break;
					case 5:
						nc.connect(url,params[0], params[1], params[2], params[3], params[4]);
						logInfo("rtmp连接传递的参数为:"+params[0]+" , "+params[1]+" , "+params[2]+" , "+params[3]+" , "+params[4]);
						break;
				}
			}
		}
		
		private function callMethod(connect:NetConnection, invokeName:String, responder:Responder, pkgName:String, methodName:String,args:Array):void {
			connect.call(invokeName, responder, this.loginToken, pkgName, methodName, getParamArr(args));
		}
		
		private function onAsyncErrorHandler(event:AsyncErrorEvent):void {
			logInfo("AsyncErrorEvent:"+event);
		}
		
		private function onSecurityError(event:SecurityErrorEvent):void {
			logInfo("SecurityErrorEvent:"+event);
		}
		
		private var pendingRequests:ArrayCollection = new ArrayCollection();
		private var pendingRequestArr:ArrayCollection = new ArrayCollection();
		
		private function onNetStatusHandler(event:NetStatusEvent):void {
			logInfo(event.info.code);
			if (event.info.code == "NetConnection.Connect.Success") {
				if (connectTimer) {
					connectTimer.stop();
					connectTimer = null;
				}
				logInfo("rtmp连接成功");
				reSubscribeTop();
				if (pendingRequests.length > 0) {
					var newArr:ArrayCollection = new ArrayCollection();
					newArr.addAll(pendingRequests);
					pendingRequests.removeAll();
					
					for each (var obj:Object in newArr) {
						executeRtmpRpc(obj.url, obj.pkgName, obj.methodName, obj.compResult,obj.args, null, obj.token);
					}
					newArr.removeAll();
				}
				
				if (pendingRequestArr.length > 0) {
					var newArr2:ArrayCollection = new ArrayCollection();
					newArr2.addAll(pendingRequestArr);
					pendingRequestArr.removeAll();
					
					for each (var obj:Object in newArr2) {
						executeRtmpRpc2(obj.url, obj.methodName, obj.responder, obj.args, obj.token);
					}
					newArr2.removeAll();
				}
			}
			if (event.info.code == "NetStream.Play.StreamNotFound") {
				logInfo("rtmp连接失败,失败原因为:NetStream.Play.StreamNotFound");
			}
			if (event.info.code == "NetConnection.Connect.Closed") {
				logInfo("rtmp连接失败,失败原因为:NetConnection.Connect.Closed");
				/*if (alertInstance != null) {
				alertInstance.prompt(FlexGlobals.topLevelApplication as DisplayObjectContainer, "连接失败，10s后重连!");
				}*/
				logInfo("连接失败，10s后重连!");  
				FlexGlobals.topLevelApplication.callLater(reConnect, [event.target as NetConnection]);
			}
			if (event.info.code == "NetConnection.Connect.Failed") {
				logInfo("rtmp连接失败,失败原因为:NetConnection.Connect.Failed");
				/*if (alertInstance != null) {
				alertInstance.prompt(FlexGlobals.topLevelApplication as DisplayObjectContainer, "连接失败，10s后重连!");
				}*/
				logInfo("连接失败，10s后重连!");  
				FlexGlobals.topLevelApplication.callLater(reConnect, [event.target as NetConnection]);
			}
		}
		
		private var connectTimer:Timer;
		
		private function reConnect(connect:NetConnection):void {
			connectTimer = new Timer(10000, 1);
			connectTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void{
				for (var key:String in connectMap) {
					var conn:NetConnection = connectMap[key];
					if (conn == connect) {
						var item:Object = getUrlPart(key);
						if (loginToken != null && loginToken != "" && loginToken != "null") {
							var newUrl:String = item.url+"?token="+loginToken;
							connectNetConnection(connect, newUrl, item.params);
							logInfo("重连:"+newUrl);
						} else {
							connectNetConnection(connect, item.url, item.params);
							logInfo("重连:"+item.url);
						}
						break;
					}
				}
			});
			connectTimer.start();
		}
		
		private var topicNames:ArrayCollection = new ArrayCollection();
		
		public function subsibeTop(url:String, topicName:String, isNew:Boolean=true):void {
			if (isNew) {
				topicNames.addItem({"url":url, "topicName":topicName});
			}
			if (connectMap.hasOwnProperty(url)) {
				var connect:NetConnection = connectMap[url] as NetConnection;
				if (connect.connected) {
					var sucessFn:Function = function(data) {
						logInfo("主题:"+topicName+"订阅成功,url="+url);
					}
					var failureFn:Function = function(data) {
						Alert.show("主题:"+topicName+"订阅失败");
						logInfo("主题:"+topicName+"订阅失败,url="+url);
					}
					connect.call("method.subscriptionTopic",new Responder(sucessFn, failureFn), [topicName]);
				}
			}
		}
		
		private function reSubscribeTop():void {
			for each (var item:Object in topicNames){
				subsibeTop(item.url, item.topicName, false);
			}
		}
		
		public function sendMsg(topicName:String, dat:Object):void {
			var cache:Object = new Object();
			for (var pro:String in dat) {
				if (!cache.hasOwnProperty(pro)) {
//					LogManager.getInstance().logInfo("主题订阅更改:pkg："+topicName+", pro:"+pro+", value:"+dat[pro], LOG_NAMESPACE);
					cache[pro] = true;
					if (topicName == "topic_task" && pro == "completed") {
//						TopicMessageManager.getInstance().dispatchEvent(new EventWithData(TopicMessageManager.TASKTOPICCHANGED));
					}
				}
			}
		}
		
		private function getParamArr(params:Array):Array {
			if (params == null) {
				return params;
			} else {
				var newParams:Array = [];
				for each(var obj:Object in params) {
					if (obj is String) {
						newParams.push(""+obj);
					} else if (obj is ArrayCollection){
						newParams.push((obj as ArrayCollection).source);
					} else {
						newParams.push(obj);
					}
				}
				return newParams
			}
		}
		
		public function getUrlPart(url:String):Object {
			logInfo("url参数:"+url);
			var obj:Object = new Object();
			if (url!=null && StringUtil.trim(url) != "" && url.indexOf("?") != -1) {
				var arr:Array = [];
				var temp:Array = url.split("?");
				
				obj.url = temp[0];
				obj.params = arr;
				
				if (temp.length == 2) {
					var paramStr:String = temp[1];
					var paramArr:Array = paramStr.split("&");
					for each (var str:String in paramArr) {
						var dd:Array = str.split("=");
						arr.push(dd[1]);
					}
				}
			} else {
				obj.url = url;
				obj.params = [];
			}
			return obj;
		}
	}
}

import flash.net.NetConnection;
class RTMPNetConnection extends NetConnection {
	public var orginUrl:String;
	public var appName:String;
}