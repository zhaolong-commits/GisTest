package nodeAndLine
{
	import mx.core.UIComponent;
	
	public class TestNode extends UIComponent
	{
		public function TestNode()
		{
			super();
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			this.graphics.beginFill(0x000000);
			this.graphics.drawCircle(x,y,2);
			this.graphics.endFill();
		}
	}
}