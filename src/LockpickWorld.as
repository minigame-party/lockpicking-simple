package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author {@link mailto:zach.w.lewis@us.army.mil "Zachary W. Lewis"}
	 */
	public class LockpickWorld extends World 
	{
		// Assets
		[Embed(source = "../assets/lock.png")] protected static const LOCK_BITMAP:Class;
		[Embed(source = "../assets/pick.png")] protected static const PICK_BITMAP:Class;
		[Embed(source = "../assets/start.png")] protected static const START_BITMAP:Class;
		[Embed(source = "../assets/success.png")] protected static const SUCCESS_BITMAP:Class;
		[Embed(source = "../assets/failure.png")] protected static const FAILURE_BITMAP:Class;
		
		protected var _lock:Image;
		protected var _pick:Image;
		
		protected var _start:Entity;
		protected var _success:Entity;
		protected var _failure:Entity;
		
		protected var _pickValue:Number;
		protected var _lockValue:Number;
		
		protected var _active:Boolean;
		
		// Gameplay Variables
		protected var _guessCount:uint;
		protected var _guessMax:uint;
		protected var _target:Number;
		
		protected const ROTATION_SPEED:Number = 90;
		
		public function LockpickWorld() 
		{
			
			
			super();
			
			// Create and setup the lock.
			_lock = new Image(LOCK_BITMAP);
			_lock.centerOrigin();
			_lock.smooth = true;
			
			// Create and setup the pick.
			_pick = new Image(PICK_BITMAP);
			_pick.originX = 5;
			_pick.originY = 200;
			_pick.smooth = true;
			
			// Create the start button.
			_start = new Entity(360, 20, new Image(START_BITMAP), new Hitbox(80, 32));
			
			_success = new Entity(336, 500, new Image(SUCCESS_BITMAP));
			_failure = new Entity(336, 500, new Image(FAILURE_BITMAP));
			Image(_success.graphic).color = 0xff9eed37;
			Image(_failure.graphic).color = 0xffef4136;
		}
		
		protected function init():void
		{
			_pickValue = 0.5;
			_lockValue = 0;
			_active = false;
			_target = Math.random();
			_guessCount = 0;
			_guessMax = 100;
			add(_start);
		}
		
		override public function begin():void 
		{
			addGraphic(_pick, 0, 400, 300);
			addGraphic(_lock, 1, 400, 300);
			
			init();
			
			super.begin();
		}
		
		override public function update():void 
		{
			var inputAngle:Number = 90;
			
			if (_active)
			{
				/* Use the mouse to place the pick.
			 * The pick value can be [0—1], and determines the success of the picking.
			 * The value is based on the mouse position on the screen, from [200–600].
			 * This is shown visually by rotating the pick.
			 */
			
				// Lock the angle input between 0—180.
				inputAngle = FP.angle(400, 300, mouseX, mouseY);
				
				if (inputAngle > 180)
				{
					inputAngle = inputAngle < 270 ? 180 : 0;
				}
				
				_pickValue = inputAngle / 180;
				
				
				// Handle player guess input.
				if (Input.check(Key.SPACE))
				{
					_lockValue += ROTATION_SPEED * FP.elapsed;
					
					// Handle guessing based on pick position.
					// Guess distance should be very small.
					var guessDistance:Number = Math.abs(_target - _pickValue);
					
					if (guessDistance > 0.05)
					{
						if (1 - guessDistance < (_lockValue / 90) * 4)
						{
							_guessCount++;
							_lockValue -= 5;
							
							if (_guessCount > _guessMax)
							{
								// TODO: Handle failure state.
								add(_failure);
								init();
							}
						}
					}
					else if (_lockValue >= 90)
					{
						// TODO: Handle win state.
						add(_success);
						init();
					}
				}
				else if (_lockValue > 0)
				{
					_lockValue -= ROTATION_SPEED * 1.5 * FP.elapsed;
				}
				
				// Clamp lock movement.
				_lockValue = FP.clamp(_lockValue, 0, 90);
			}
			else
			{
				// Handle game start.
				if (_start.collidePoint(_start.x, _start.y, mouseX, mouseY))
				{
					Image(_start.graphic).alpha = 0.8;
					if (Input.mousePressed)
					{
						remove(_start);
						remove(_success);
						remove(_failure);
						_active = true;
					}
				}
				else
				{
					Image(_start.graphic).alpha = 1.0;
				}
			}
			
			
			// Update visuals.
			_pick.color = FP.colorLerp(0xffcccccc, 0xffef4136, _guessCount / _guessMax);
			_pick.angle = inputAngle - 90;
			_lock.angle = _lockValue;
			
			super.update();
		}
	}

}