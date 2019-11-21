static class EasterEggManager {
  //Easteregg one dev's names
  static boolean easterEggNamesStepOne = false, easterEggNamesStepTwo = false, easterEggNamesStepThree = true;

  static boolean canRenderEasterEggOne() {
    return  easterEggNamesStepOne && easterEggNamesStepTwo && easterEggNamesStepThree;
  }

  static void updateEasterEggs() {
  }
}
