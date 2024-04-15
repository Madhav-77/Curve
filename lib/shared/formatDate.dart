class FormatDate {
  String monthString = "";
  String monthInt = "";
  String year = "";
  String month = "";
  String day = "";
  String convertedDate = "";

  convertMonth(String date) {
    monthString = date.substring(3, 6);
    switch (monthString) {
      case "Jan":
        monthInt = "01";
        break;
      case "Feb":
        monthInt = "02";
        break;
      case "Mar":
        monthInt = "03";
        break;
      case "Apr":
        monthInt = "04";
        break;
      case "May":
        monthInt = "05";
        break;
      case "Jun":
        monthInt = "06";
        break;
      case "Jul":
        monthInt = "07";
        break;
      case "Aug":
        monthInt = "08";
        break;
      case "Sep":
        monthInt = "09";
        break;
      case "Oct":
        monthInt = "10";
        break;
      case "Nov":
        monthInt = "11";
        break;
      case "Dec":
        monthInt = "12";
        break;
    }
    monthInt = date.replaceRange(3, 6, monthInt); //replace string month with numbers
    monthInt = monthInt.replaceRange(6, 8, "2020"); //replace 20 with 2020
    year = monthInt.substring(6, 10);
    month = monthInt.substring(3, 5);
    day = monthInt.substring(0, 2);
    convertedDate = year + "-" + month + "-" + day;
    return convertedDate;
  }
}
