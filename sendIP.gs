function doPost(e) {
  var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet(); // get sheet object
  var ip = e.parameter.ip; // Get the IP address from the request
  sheet.appendRow([new Date(), ip]); // Append a new row with timestamp and IP
  return ContentService.createTextOutput("Success");
}
