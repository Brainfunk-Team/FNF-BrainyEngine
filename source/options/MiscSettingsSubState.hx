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

		super();
	}
}
