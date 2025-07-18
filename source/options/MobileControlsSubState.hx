package options;

class MobileControlsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = Language.getPhrase('controls_menu', 'Controls Settings');
		rpcTitle = 'Controls Settings Menu';

		#if mobile
		var option:Option = new Option('Show Note Touch Buttons',
			'If checked, shows the Note on the screen',
			'notetouchbuttons',
			BOOL);
		addOption(option);
		#end

		super();
	}
}
