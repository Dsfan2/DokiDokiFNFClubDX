// Screw you, I'm straight up importing all hx files right away so I don't have to worry about it later.

// "Backend" directories
import backend.Achievements;
import backend.BaseStage;
import backend.ClientPrefs;
import backend.Conductor;
import backend.Conductor.BPMChangeEvent;
import backend.Controls;
import backend.CoolUtil;
import backend.CustomFadeTransition;
#if desktop
import backend.Discord;
#end
import backend.FlxUIDropDownMenuCustom;
import backend.FramerateTools;
import backend.Highscore;
import backend.InputFormatter;
import backend.MusicBeatState;
import backend.MusicBeatSubstate;
import backend.Paths;
import backend.PlayerSettings;
import backend.SaveData;
import backend.Section;
import backend.Song;
import backend.StageData;
import backend.WeekData;

// "Cutscenes" directories
import cutscenes.DialogueBoxRegular;

// "Objects" directories
import objects.AchievementPopup;
import objects.Alphabet;
import objects.AttachedAchievement;
import objects.AttachedDokiText;
import objects.AttachedSprite;
import objects.BGSprite;
import objects.Character;
import objects.CheckboxThingie;
import objects.CoolScrollText;
import objects.CoolSongBlurb;
import objects.DDLCBorder;
import objects.DDLCBorderBG;
import objects.FileMessage;
import objects.FreeplaySongItem;
import objects.HealthBar;
import objects.HealthIcon;
import objects.MemberCard;
import objects.Note;
import objects.NoteSplash;
import objects.Part2Popup;
import objects.PopupBlocker;
import objects.Prompt;
import objects.DDLCPrompt;
import objects.StrumNote;
import objects.ResultScore;
import objects.ClearPercentCounter;
import objects.TallyCounter;

// "Options" directories
import options.BaseOptionsMenu;
import options.ControlsSubState;
import options.GameplaySettingsSubState;
import options.GraphicsSettingsSubState;
import objects.MemberCard;
import options.NoteOffsetState;
import options.NotesSubState;
import options.Option;
import options.OptionsState;
import options.VisualsUISubState;

// "Shaders" directories
import shaders.BlendModeEffect;
import shaders.BloomShader;
import shaders.ChannelMaskShader;
import shaders.ColorMaskShader;
import shaders.ColorSwap;
import shaders.FishEyeShader;
import shaders.GlitchShader;
import shaders.InvertShader;
import shaders.OverlayShader;
import shaders.PixelShader;
import shaders.PureColor;
import shaders.RGBPalette;
import shaders.StaticShader;
import shaders.WarpShader;
import shaders.WiggleEffect;

// "Editors" directories
import states.editors.CharacterEditorState;
import states.editors.ChartingState;
import states.editors.MasterEditorMenu;

// "States" directories
import states.AchievementsMenuState;
import states.AntiCheatState;
import states.BonusFreeplayState;
import states.ClassicFreeplayState;
import states.CompletionScreen;
import states.CrashState;
import states.CreditsState;
import states.ExtraStuffState;
import states.FreeplayState;
import states.GalleryState;
import states.LoadingState;
import states.MainMenuState;
import states.PlayState;
import states.SaveFileState;
import states.StoryContinueState;
import states.StoryStartState;
import states.TitleState;
import states.WarningState;

// "Substates" directories
import substates.FreeplaySelect;
import substates.GameOverSubstate;
import substates.GameplayChangersSubstate;
import substates.PauseSubState;
import substates.PlayerSelectMenu;
import substates.ResultsScreen;
import substates.StageSelectSubstate;

//Flixel
#if (flixel >= "5.3.0")
import flixel.sound.FlxSound;
#else
import flixel.system.FlxSound;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;
import flixel.util.FlxGradient;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxStringUtil;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.FlxGraphic;
import flixel.input.FlxInput;
import flixel.ui.FlxButton;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUIGroup;
import flixel.addons.ui.FlxUIText;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUISpriteButton;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUIAssets;
import flixel.addons.ui.StrNameLabel;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.interfaces.IFlxUIClickable;
import flixel.addons.ui.interfaces.IFlxUIWidget;
import flixel.addons.ui.interfaces.IHasParams;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.display.FlxBackdrop;
import flixel.effects.FlxFlicker;

//OpenFL
import openfl.utils.Assets;
import openfl.events.AsyncErrorEvent;
import openfl.events.Event;
import openfl.events.NetStatusEvent;
import openfl.media.Video;
import openfl.net.NetConnection;
import openfl.net.NetStream;

//Lime
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

//sys
#if sys
import sys.io.File;
import sys.FileSystem;
import sys.io.Process;
#end

//hxcodec
import hxcodec.VideoSprite;

//flash
import flash.geom.Rectangle;

using StringTools;