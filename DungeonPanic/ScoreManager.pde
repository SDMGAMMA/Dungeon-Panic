/**
 @author Casper Klinkhamer, Nicolaas Schuddeboom
 
 This class manages the score the player earns.
 
 Punten per kist
 common = 5 punten
 uncommon = 10 punten
 rare = 20 punten
 epic = 30 punten
 */

static class ScoreManager {

  static HashMap<String, Integer> allHighScores = new HashMap<String, Integer>();

  static int totalScore = 0;
  static int saveScore = 0;
  static int timeBonus = 0;
  static int time = 0;

  static void resetScore() {
    totalScore = 0;
  }

  static void insertScore(String playerName, int score) 
  {
    // If the player doesn't have a highscore, create a highscore with their name attached
    if (!allHighScores.containsKey(playerName)) 
    {
      allHighScores.put(playerName, score);
    } else 
    {
      //  If the player already has a highscore, but has beaten it, update it.
      if (allHighScores.get(playerName) < score) 
      {
        allHighScores.remove(playerName);
        allHighScores.put(playerName, score);
      }
    }
  }

  public static int checkTimeBonus()
  {
    if (gameManager.getCurrentScene().getTimeSpent() >= 0 && gameManager.getCurrentScene().getTimeSpent() <= 30)
    {
      timeBonus = 100;
      time = gameManager.getCurrentScene().getTimeSpent();
    } else if (gameManager.getCurrentScene().getTimeSpent() > 30 && gameManager.getCurrentScene().getTimeSpent() <= 75)
    {
      timeBonus = 75;
      time = gameManager.getCurrentScene().getTimeSpent();
    } else if (gameManager.getCurrentScene().getTimeSpent() > 45 && gameManager.getCurrentScene().getTimeSpent() <= 140)
    {
      timeBonus = 50;
      time = gameManager.getCurrentScene().getTimeSpent();
    } else if (gameManager.getCurrentScene().getTimeSpent() > 60 && gameManager.getCurrentScene().getTimeSpent() <= 190)
    {
      timeBonus = 25;
      time = gameManager.getCurrentScene().getTimeSpent();
    } else if (gameManager.getCurrentScene().getTimeSpent() > 90 && gameManager.getCurrentScene().getTimeSpent() <= 230)
    {
      timeBonus = 10;
      time = gameManager.getCurrentScene().getTimeSpent();
    }
    return timeBonus;
  }

  static void addScore(int score) {
    totalScore += score;
    setSaveScore();
  }

  private static void setSaveScore() {
    saveScore = totalScore +1;
    saveScore--;
  }

  static void removeScore(int score) {
    totalScore -= score;
    setSaveScore();
  }

  static int getScore() {
    return totalScore;
  }

  // Returns an Array of highscores from high to low
  static String[] getScoreBoard()
  {
    // Declare arrays
    String[] scoreBoardReturn = new String[10];
    int[] allScores = new int[0];

    // Increase allScores until it is as big as allHighScores (An array instead of ArrayList is used because ArrayList needs to use a library for the sort method)
    for (String name : ScoreManager.allHighScores.keySet())
    {
      int score = ScoreManager.allHighScores.get(name);

      // Incease array and give it a value
      allScores = (int[])expand(allScores, allScores.length + 1); // Expand the highscores by 1
      allScores[allScores.length - 1] = score;
    }

    // Sort the array from low to high and declare previousScore (Which is used to fix a bug)
    // If previousScore isn't used, scores with the same value will be printed twice
    // Index is used to put the highscore in the right place of scoreBoardReturn
    allScores = sort(allScores);
    int previousScore = -1;
    int index = 0;

    // The array is sorted from low to high, so we need to go through it backwards. We also only get the 10 highest highscores
    for (int i = allScores.length - 1; i >= allScores.length - 10; i--)
    {
      // Check for errors
      try
      {
        if (i >= 0)
        {
          // Go through the HashMap and check if the score matches the current index of allScores. This way, we know who the person is with this score.
          for (String name : ScoreManager.allHighScores.keySet())
          {
            int score = ScoreManager.allHighScores.get(name);

            if (score == allScores[i] && previousScore != allScores[i])
            {
              scoreBoardReturn[index] = name + " = " + score;
              index++;
            }
          }
        }
        // Update previousScore
        previousScore = allScores[i];
      }
      catch(Exception e)
      {
      }
    }

    return scoreBoardReturn;
  }

  static boolean checkScore(int score, int requiredScore)
  {
    return score >= requiredScore;
  }
}

class ScoreSaver
{
  // Deze method slaat de highscore van de speler op en maakt een nieuwe text document als het nodig is
  public void saveScores() 
  {
    try
    { 
      // Get file
      File file = getFile();

      // Load the highscores in strings (in this function it is not needed to convert them into numbers and bytes are too short)
      String[] highScores = new String[0];    

      // Go through HashMap and append it to a array (highScores)
      for (String name : ScoreManager.allHighScores.keySet())
      {
        int score = ScoreManager.allHighScores.get(name);

        highScores = (String[])expand(highScores, highScores.length + 1); // Expand the highscores by 1
        highScores[highScores.length - 1] = name + " = " + score;
      }

      // Save highscores
      saveStrings(file, highScores);

      //ArrayList<String> arrayList = new ArrayList<String>(ScoreManager.getScoreBoard());
      String[] array = ScoreManager.getScoreBoard();
      for (String s : array)
      {
        if (s != null)
        {
        }
      }
    }
    catch(Exception e)
    {
      // Error
      println(e);
    }
  }

  // Create HashMap
  public void loadScores() 
  {
    try
    {
      // Get highscores
      String[] highScores = loadStrings(getFile());

      // For each highScore, append it to HashMap
      for (int i = 0; i < highScores.length; i++)
      {
        String[] data = highScores[i].split(" = ");

        ScoreManager.allHighScores.put(data[0], parseInt(data[1]));
      }
    }
    catch(Exception e)
    {
    }
  }

  public File getFile()
  {
    try
    {
      // Get text file
      File file = new File(dataPath("") + "/highscores.txt");

      // If file doesn't exist, create it
      if (!file.exists())
      {
        file.createNewFile();
      }

      return file;
    }
    catch(Exception e)
    {
      return null;
    }
  }
}
