package options;

class MiscSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.getPhrase('misc_menu', 'Misc Settings');
		rpcTitle = 'Misc Settings Menu';

		var option:Option = new Option('Pause Music:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			STRING,
			['None', 'Tea Time', 'Breakfast', 'Breakfast (Pico)']);
		addOption(option);
		option.onChange = onChangePauseMusic;
		
		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Check for Updates',
			'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates',
			BOOL);
		addOption(option);
		#end

		#if DISCORD_ALLOWED
		var option:Option = new Option('Discord Rich Presence',
			"Uncheck this to prevent accidental leaks, it will hide the Application from your \"Playing\" box on Discord",
			'discordRPC',
			BOOL);
		addOption(option);
		#end

		var option:Option = new Option('Skip Splash',
			'If checked, skips the splash when launching the game.',
			'skipSplash',
			BOOL);
		addOption(option);

		var option:Option = new Option('Get Bullied by Botplay Text',
			'If checked, a random text will get displayed when you\'re on Botplay.',
			'botplayTxt',
			BOOL);
		addOption(option);

		var option:Option = new Option('Naughtyness',
			'If unchecked, censors any potential inappropriate stuff.',
			'naughty',
			BOOL);
		addOption(option);

		super();
	}

	var changedMusic:Bool = false;

	function onChangeMenuMusic()
	{
		if(ClientPrefs.data.menuMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			if(ClientPrefs.data.menuMusic != 'Vanilla')
				FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath("freakyMenu-" + ClientPrefs.data.menuMusic)));
			else
				FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath("freakyMenu")));


		changedMusic = true;
	}

	function onChangePauseMusic()
	{
		if(ClientPrefs.data.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.data.pauseMusic)));

		changedMusic = true;
	}
}
