package options;

class MiscSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.getPhrase('misc_menu', 'Misc Settings');
		rpcTitle = 'Misc Settings Menu';

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

		super();
	}
}
