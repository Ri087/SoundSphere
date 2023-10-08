class AppUtilities {
  static String formatedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  static String getArtists(List<dynamic> artists) {
    String output = "";
    for (int i = 0; i < artists.length; i++) {
      output += artists.last != artists[i] ? "${artists[i]}, " : artists[i] ;
    }
    return output;
  }
}