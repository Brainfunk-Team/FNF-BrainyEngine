# Custom Characters Tutorial

Custom playable characters are super easy to add in Brainy Engine!

First, go to asset/shared/data/playableCharacterList.txt. Inside this file you will see something like this.

```
bf,bf,boyfriend,31b1d1
pico-playable,pico,pico,b7d855
tankman-playable,tankman,tankman,ffffff
```

Copy and paste this file into your mods folder in the data folder. You won't want to edit the one in assets/shared.

## What each field in the text file means

```
CHARACTER INTERNAL NAME (JSON FILE),ICONNAME,DISPLAYNAME,BGCOLOR (HEX CODE)
```

Now, you can fill out the fields for your character (of course you'll want to make your character JSON file in the Character Editor first, it is recommended that a playable character has miss animations, and hey and cheer animations), and you're done!

If you want a special character to appear in certain stages, for the `limo` stage you can add the suffix `-car`, for the school/schoolEvil stage you can add the suffix `-pixel`, and for the mall/mallEvil stage you can add the suffix `-christmas`.

You're done now! Do note that you can check a flag in the chart editor in the Extras tab if your song needs a specific character or else it'd look weird.

![](https://github.com/Brainfunk-Team/FNF-BrainyEngine/blob/main/.files/charteditor-characterexample.png?raw=true)
