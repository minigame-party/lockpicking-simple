package 
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	[SWF(width="800", height="600")]
	
	/**
	 * ...
	 * @author {@link mailto:zach.w.lewis@us.army.mil "Zachary W. Lewis"}
	 */
	public class Main extends Engine 
	{
		
		public function Main() 
		{
			super(800, 600, 60, false);
		}
		
		override public function init():void 
		{
			trace("FlashPunk", FP.VERSION, "started successfully.");
			
			FP.world = new LockpickWorld();
			
			super.init();
		}
		
	}
	
}