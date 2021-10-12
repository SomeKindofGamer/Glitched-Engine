import flixel.FlxG;

class Ratings
{
    public static function GenerateLetterRank(accuracy:Float) // generate a letter ranking
    {
        var ranking:String = "N/A";
		if(FlxG.save.data.botplay)
			ranking = "BotPlay";
        if (PlayState.misses == 0) // FC
            ranking = "FC -";
        else if (PlayState.misses < 10) // Single Digit Combo Breaks
            ranking = "SDCB -";
        else if (PlayState.misses < 20)
            ranking = "Good -";
        else if (PlayState.misses < 35)
            ranking = "Ehhh -";
        else if (PlayState.misses < 50)
            ranking = "Bad -";
        else
            ranking = "Horrible -";

        // WIFE TIME :)))) (based on Wife3)

        var wifeConditions:Array<Bool> = [
            accuracy >= 100, // SSS
            accuracy >= 99.9935, // SS+
            accuracy >= 99.980, // SS
            accuracy >= 99.970, // S+
            accuracy >= 99.955, // S
            accuracy >= 99.90, // AAAAAAA
            accuracy >= 99.80, // AAAAAA
            accuracy >= 99.70, // AAAAA
            accuracy >= 99, // AAAA
            accuracy >= 96.50, // AAA
            accuracy >= 93, // AA
            accuracy >= 90, // A:
            accuracy >= 85, // A.
            accuracy >= 80, // A
            accuracy >= 70, // B
            accuracy >= 60, // C
            accuracy >= 50, // D
            accuracy < 40 // F
        ];

        for(i in 0...wifeConditions.length)
        {
            var b = wifeConditions[i];
            if (b)
            {
                switch(i)
                {
                    case 0:
                        ranking += " SSS";
                    case 1:
                        ranking += " SS+";
                    case 2:
                        ranking += " SS";
                    case 3:
                        ranking += " S+";
                    case 4:
                        ranking += " S";
                    case 5:
                        ranking += " AAAAAAA";
                    case 6:
                        ranking += " AAAAAA";
                    case 7:
                        ranking += " AAAAA";
                    case 8:
                        ranking += " AAAA";
                    case 9:
                        ranking += " AAA";
                    case 10:
                        ranking += " AA";
                    case 11:
                        ranking += " A:";
                    case 12:
                        ranking += " A.";
                    case 13:
                        ranking += " A";
                    case 14:
                        ranking += " B";
                    case 15:
                        ranking += " C";
                    case 16:
                        ranking += " D";
                    case 17:
                        ranking += " F";
                }
                break;
            }
        }

        if (accuracy == 0)
            ranking = "N/A";
		else if(FlxG.save.data.botplay)
			ranking = "AutoPlay";

        return ranking;
    }
    
    public static function CalculateRating(noteDiff:Float, ?customSafeZone:Float):String // Generate a judgement through some timing shit
    {

        var customTimeScale = Conductor.timeScale;

        if (customSafeZone != null)
            customTimeScale = customSafeZone / 166;

        // trace(customTimeScale + ' vs ' + Conductor.timeScale);

        // I HATE THIS IF CONDITION
        // IF LEMON SEES THIS I'M SORRY :(

        // trace('Hit Info\nDifference: ' + noteDiff + '\nZone: ' + Conductor.safeZoneOffset * 1.5 + "\nTS: " + customTimeScale + "\nLate: " + 155 * customTimeScale);

	if (FlxG.save.data.botplay)
	    return "good"; // FUNNY
	    
        if (noteDiff > 166 * customTimeScale) // so god damn early its a miss
            return "miss";
        if (noteDiff > 125 * customTimeScale) // way early
            return "shit";
        else if (noteDiff > 90 * customTimeScale) // early
            return "bad";
        else if (noteDiff > 65 * customTimeScale) // your kinda there
            return "good";
        else if (noteDiff < -65 * customTimeScale) // little late
            return "good";
        else if (noteDiff < -90 * customTimeScale) // late
            return "bad";
        else if (noteDiff < -125 * customTimeScale) // late as fuck
            return "shit";
        else if (noteDiff < -166 * customTimeScale) // so god damn late its a miss
            return "miss";
        return "sick";
    }

    public static function CalculateRanking(score:Int,scoreDef:Int,nps:Int,maxNPS:Int,accuracy:Float):String
    {
        return 
        (FlxG.save.data.npsDisplay ? "NPS: " + nps + " (Max " + maxNPS + ")" + (!FlxG.save.data.botplay ? " | " : "") : "") + (!FlxG.save.data.botplay ?	// NPS Toggle
        "Score:" + (Conductor.safeFrames != 10 ? score + " (" + scoreDef + ")" : "" + score) + 									// Score
        " | Misses:" + PlayState.misses + 	                                                                                    // Misses
        " | Health:" + PlayState.instance.health +																	             // Health
        " | Accuracy:" + (FlxG.save.data.botplay ? "N/A" : HelperFunctions.truncateFloat(accuracy, 2) + " %") +  				// Accuracy
        " | " + GenerateLetterRank(accuracy) : ""); 																			// Letter Rank
    }
}
