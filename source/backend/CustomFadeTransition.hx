package backend;

class CustomFadeTransition extends MusicBeatSubstate {
	public static var isHeartTran:Bool = false;
	public static var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	//public static var nextCamera:FlxCamera;
	var isTransIn:Bool = false;
	var endBlack:FlxSprite;

	var transGradient:FlxSprite;
	var transSprite:FlxSprite;

	var nextState:FlxState;

	public function new(duration:Float, isTransIn:Bool, ?nextState:FlxState) {
		super();

		this.isTransIn = isTransIn;
		this.nextState = (nextState == null) ? (new MainMenuState()) : nextState;

		var zoom:Float = CoolUtil.boundTo(FlxG.camera.zoom, 0.05, 1);
		var width:Int = Std.int(FlxG.width / zoom);
		var height:Int = Std.int(FlxG.height / zoom);

		endBlack = new FlxSprite().makeGraphic(width + 400, height + 400, FlxColor.BLACK);
		endBlack.scrollFactor.set();
		endBlack.visible = false;
		endBlack.screenCenter();

		transSprite = new FlxSprite().loadGraphic('assets/transitions/HeartTransition.png');
		transSprite.scrollFactor.set();
		transSprite.screenCenter();
		transSprite.antialiasing = true;
		if (isTransIn) transSprite.scale.set(0.1, 0.1);
		else transSprite.scale.set(18, 18);

		transGradient = new FlxSprite().loadGraphic('assets/transitions/GradientTransition.png');
		transGradient.scrollFactor.set();
		transGradient.antialiasing = true;
		if (isTransIn) {
			transGradient.flipX = true;
			transGradient.x = -150;
		} else {
			transGradient.flipX = false;
			transGradient.x = FlxG.width;
		}

		if (isHeartTran) {
			add(endBlack);
			add(transSprite);
		}
		else {
			add(transGradient);
		}

		if (!isTransIn) finishCallback = function() {
			FlxG.switchState(nextState);
		};

		if (isHeartTran) {
			if(isTransIn) {
				transSprite.screenCenter();
				FlxTween.tween(transSprite.scale, {x: 18, y: 18}, duration, {
					onComplete: function(twn:FlxTween) {
						transSprite.scale.set(18, 18);
						close();
					},
				ease: FlxEase.linear});
			} else {
				transSprite.screenCenter();
				leTween = FlxTween.tween(transSprite.scale, {x: 0.1, y: 0.1}, duration, {
					onComplete: function(twn:FlxTween) {
						transSprite.scale.set(0.1, 0.1);
						endBlack.visible = true;
						if(finishCallback != null) {
							finishCallback();
						}
					},
				ease: FlxEase.linear});
			}
		} else {
			if(isTransIn) {
				FlxTween.tween(transGradient, {x: (0 - transGradient.width)}, duration, {
					onComplete: function(twn:FlxTween) {
						close();
					},
				ease: FlxEase.linear});
			} else {
				leTween = FlxTween.tween(transGradient, {x: -420}, duration, {
					onComplete: function(twn:FlxTween) {
						if(finishCallback != null) {
							finishCallback();
						}
					},
				ease: FlxEase.linear});
			}
		}

		transSprite.cameras = FlxG.cameras.list;
		endBlack.cameras = FlxG.cameras.list;
		transGradient.cameras = FlxG.cameras.list;
		if (isTransIn) isHeartTran = false;
	}

	override function update(elapsed:Float) {
		if(isTransIn) {
			transSprite.screenCenter();
		} else {
			transSprite.screenCenter();
		}
		super.update(elapsed);
		if(isTransIn) {
			transSprite.screenCenter();
		} else {
			transSprite.screenCenter();
		}
	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}