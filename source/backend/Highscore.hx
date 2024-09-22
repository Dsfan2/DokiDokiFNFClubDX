package backend;

class Highscore
{
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songRating:Map<String, Float> = new Map<String, Float>();


	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		setScore(daSong, 0);
		setRating(daSong, 0);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0);
	}

	public static function resetAllScores():Void
	{
		resetWeek('Start BF', 0);
		resetWeek('Start BF', 1);
		resetWeek('Sayori BF', 0);
		resetWeek('Sayori BF', 1);
		resetWeek('Natsuki BF', 0);
		resetWeek('Natsuki BF', 1);
		resetWeek('Yuri BF', 0);
		resetWeek('Yuri BF', 1);
		resetWeek('Monika BF', 0);
		resetWeek('Monika BF', 1);
		resetWeek('Midway BF', 0);
		resetWeek('Midway BF', 1);
		resetWeek('Sxyori BF', 0);
		resetWeek('Sxyori BF', 1);
		resetWeek('Glitchsuki BF', 0);
		resetWeek('Glitchsuki BF', 1);
		resetWeek('Yurdere BF', 0);
		resetWeek('Yurdere BF', 1);
		resetWeek('Final BF', 0);
		resetWeek('Final BF', 1);
		resetWeek('Start JR', 0);
		resetWeek('Start JR', 1);
		resetWeek('Sayori JR', 0);
		resetWeek('Sayori JR', 1);
		resetWeek('Natsuki JR', 0);
		resetWeek('Natsuki JR', 1);
		resetWeek('Yuri JR', 0);
		resetWeek('Yuri JR', 1);
		resetWeek('Monika JR', 0);
		resetWeek('Monika JR', 1);
		resetWeek('Midway JR', 0);
		resetWeek('Midway JR', 1);
		resetWeek('Sxyori JR', 0);
		resetWeek('Sxyori JR', 1);
		resetWeek('Glitchsuki JR', 0);
		resetWeek('Glitchsuki JR', 1);
		resetWeek('Yurdere JR', 0);
		resetWeek('Yurdere JR', 1);
		resetWeek('Final JR', 0);
		resetWeek('Final JR', 1);
		resetWeek('Start MONI', 0);
		resetWeek('Start MONI', 1);
		resetWeek('Sayori MONI', 0);
		resetWeek('Sayori MONI', 1);
		resetWeek('Natsuki MONI', 0);
		resetWeek('Natsuki MONI', 1);
		resetWeek('Yuri MONI', 0);
		resetWeek('Yuri MONI', 1);
		resetWeek('Others MONI', 0);
		resetWeek('Others MONI', 1);
		resetWeek('Final MONI', 0);
		resetWeek('Final MONI', 1);

		resetSong('Welcome To The Club', 0);
		resetSong('Welcome To The Club', 1);
		resetSong('Daydream', 0);
		resetSong('Daydream', 1);
		resetSong('Happy Thoughts', 0);
		resetSong('Happy Thoughts', 1);
		resetSong('Cinnamon Bun', 0);
		resetSong('Cinnamon Bun', 1);
		resetSong('Trust', 0);
		resetSong('Trust', 1);
		resetSong('Manga', 0);
		resetSong('Manga', 1);
		resetSong('Anime', 0);
		resetSong('Anime', 1);
		resetSong('Tsundere', 0);
		resetSong('Tsundere', 1);
		resetSong('Respect', 0);
		resetSong('Respect', 1);
		resetSong('Novelty', 0);
		resetSong('Novelty', 1);
		resetSong('Shy', 0);
		resetSong('Shy', 1);
		resetSong('Cup Of Tea', 0);
		resetSong('Cup Of Tea', 1);
		resetSong('Reflection', 0);
		resetSong('Reflection', 1);
		resetSong('Poetry', 0);
		resetSong('Poetry', 1);
		resetSong('Writing Tip', 0);
		resetSong('Writing Tip', 1);
		resetSong('I Advise', 0);
		resetSong('I Advise', 1);
		resetSong('Last Dual', 0);
		resetSong('Last Dual', 1);
		resetSong('Un-welcome To The Club', 0);
		resetSong('Un-welcome To The Club', 1);
		resetSong('Depression', 0);
		resetSong('Depression', 1);
		resetSong('Hxppy Thxughts', 0);
		resetSong('Hxppy Thxughts', 1);
		resetSong('Cxnnamon Bxn', 0);
		resetSong('Cxnnamon Bxn', 1);
		resetSong('Malnourished', 0);
		resetSong('Malnourished', 1);
		resetSong('Pale', 0);
		resetSong('Pale', 1);
		resetSong('Glitch', 0);
		resetSong('Glitch', 1);
		resetSong('Yandere', 0);
		resetSong('Yandere', 1);
		resetSong('Obsessed', 0);
		resetSong('Obsessed', 1);
		resetSong('Psychopath', 0);
		resetSong('Psychopath', 1);
		resetSong('Revelation', 0);
		resetSong('Revelation', 1);
		resetSong('Lines Of Code', 0);
		resetSong('Lines Of Code', 1);
		resetSong('Self-Aware', 0);
		resetSong('Self-Aware', 1);
		resetSong('Elevated Access', 0);
		resetSong('Elevated Access', 1);
		resetSong('Script Error', 0);
		resetSong('Script Error', 1);
		resetSong('System Failure', 0);
		resetSong('System Failure', 1);
		resetSong('Candy Hearts', 0);
		resetSong('Candy Hearts', 1);
		resetSong('Lavender Mist', 0);
		resetSong('Lavender Mist', 1);
		resetSong('Strawberry Peppermint', 0);
		resetSong('Strawberry Peppermint', 1);
		resetSong('Candy Heartz', 0);
		resetSong('Candy Heartz', 1);
		resetSong('My Song Your Note', 0);
		resetSong('My Song Your Note', 1);
		resetSong('Play With Me', 0);
		resetSong('Play With Me', 1);
		resetSong('Poem Panic', 0);
		resetSong('Poem Panic', 1);
		resetSong('Just Monika', 0);
		resetSong('Just Monika', 1);
		resetSong('Doki Forever', 0);
		resetSong('Doki Forever', 1);
		resetSong('Dark Star', 0);
		resetSong('Dark Star', 1);
		resetSong("You Can't Run", 0);
		resetSong("You Can't Run", 1);
		resetSong('Ultimate Glitcher', 0);
		resetSong('Ultimate Glitcher', 1);
		resetSong('Fresh Literature', 0);
		resetSong('Fresh Literature', 1);
		resetSong('Cupcakes', 0);
		resetSong('Cupcakes', 1);
		resetSong('Poems Are Forever', 0);
		resetSong('Poems Are Forever', 1);
		resetSong('The Final Battle', 0);
		resetSong('The Final Battle', 1);
		resetSong('Your Reality', 0);
		resetSong('Your Reality', 1);
		resetSong('Mon-Ika', 0);
		resetSong('Mon-Ika', 1);
		resetSong('Flower Power', 0);
		resetSong('Flower Power', 1);
		resetSong('Honeycomb', 0);
		resetSong('Honeycomb', 1);
		resetSong('Supernatural', 0);
		resetSong('Supernatural', 1);
		resetSong('Spiders Of Markov', 0);
		resetSong('Spiders Of Markov', 1);
		resetSong('Yuri Is A Raccoon', 0);
		resetSong('Yuri Is A Raccoon', 1);
		resetSong('Amy Likes Ninjas', 0);
		resetSong('Amy Likes Ninjas', 1);
		resetSong('Roar Of Natsuki', 0);
		resetSong('Roar Of Natsuki', 1);
		resetSong('Crossover Clash', 0);
		resetSong('Crossover Clash', 1);
		resetSong('Festival Deluxe', 0);
		resetSong('Festival Deluxe', 1);
	}

	public static function floorDecimal(value:Float, decimals:Int):Float
	{
		if(decimals < 1)
		{
			return Math.floor(value);
		}

		var tempMult:Float = 1;
		for (i in 0...decimals)
		{
			tempMult *= 10;
		}
		var newValue:Float = Math.floor(value * tempMult);
		return newValue / tempMult;
	}

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, ?rating:Float = -1):Void
	{
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong)) {
			if (songScores.get(daSong) < score) {
				ResultsScreen.newHighscore = true;
				setScore(daSong, score);
				if(rating >= 0) setRating(daSong, rating);
			}
		}
		else {
			setScore(daSong, score);
			if(rating >= 0) setRating(daSong, rating);
		}
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);

		if (weekScores.exists(daWeek))
		{
			if (weekScores.get(daWeek) < score)
				setWeekScore(daWeek, score);
		}
		else
			setWeekScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}
	static function setWeekScore(week:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekScores.set(week, score);
		FlxG.save.data.weekScores = weekScores;
		FlxG.save.flush();
	}

	static function setRating(song:String, rating:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, rating);
		FlxG.save.data.songRating = songRating;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		return Paths.formatToSongPath(song) + CoolUtil.getDifficultyFilePath(diff);
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		return songScores.get(daSong);
	}

	public static function getRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0);

		return songRating.get(daSong);
	}

	public static function getWeekScore(week:String, diff:Int):Int
	{
		var daWeek:String = formatSong(week, diff);
		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores.get(daWeek);
	}

	public static function load():Void
	{
		if (FlxG.save.data.weekScores != null)
		{
			weekScores = FlxG.save.data.weekScores;
		}
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songRating != null)
		{
			songRating = FlxG.save.data.songRating;
		}
	}
}