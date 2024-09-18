# Doki Doki Friday Night Funkin' Club Deluxe - The End Update
The final update for Doki Doki FNF Club! (Well, not really, it's Part 1 of the final update. Part 2 releases next year.)

This mod was built using an enhanced version of Psych Engine DS V1.1.0

This README will provide some information on how to compile the source code for yourself.

## Step 1:
You must have [Haxe Version 4.2.5](https://haxe.org/download/version/4.2.5/), DO NOT USE older or newer versions, it won't work!

## Step 2:

## Step 2:
If you're not on Windows, or you've FNF compiled on Windows before you can skip this step.
But if you're compiling on Windows, and you've never compiled FNF Source Code before, PLEASE READ THIS.
You're gonna need to download Visual Studio Community 2019 if you haven't already:
https://my.visualstudio.com/Downloads?q=visual%20studio%202019&wt.mc_id=o~msft~vscom~older-downloads

While installing VSC, DON'T click on any of the options to install workloads. 
Instead, go to the individual components tab and choose the following:
- MSVC v142 - VS 2019 C++ x64/x86 build tools (Latest Version)
- Windows SDK (10.0.17763.0)

Install these and you should be able to compile properly.

## Step 3:
Open up a Command Prompt/PowerShell or Terminal and enter all these into it:
  - haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc.git
  - haxelib install flixel-addons 3.0.2
  - haxelib install flixel-tools 1.5.1
  - haxelib install flixel-ui 2.5.0
  - haxelib install flixel 5.2.2
  - haxelib install tjson 1.4.0
  - haxelib install hxCodec 2.6.1 *{This is VERY important. DO NOT USE HXCODEC 3.0.2 AS IT WILL NOT COMPILE!}*
  - haxelib install lime 8.0.1
  - haxelib install openfl 9.2.1
  - haxelib run lime setup

This is to ensure all the needed libraries are at the correct version in order for the game to actually compile properly.

## Step 4:
You should be good to go now.
In order to compile the game you need to type something different on the Command Prompt/PowerShell or Terminal depending on what you're compiling on.
`lime test windows` - Windows
`haxelib run lime test mac` - Mac
`haxelib run lime test linux` - Linux
You can add ` -debug` to the end of the command to compile the game in debug mode.
(DO NOT COMPILE IT TO HTML5!!)

And that's it. If you did everything right, it should compile.