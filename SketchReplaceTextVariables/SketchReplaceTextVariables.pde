import java.util.regex.Matcher; 
import java.util.regex.Pattern; 

String mFilenameIN = "text.md";
String mFilenameOUT = "text.new.md";

final String PATTERN_BEGIN = "\\$\\[";
final String PATTERN_END = "\\]";
final static int HEADER_KEY = 0;
final static int HEADER_VALUE = 1;

void setup() {
  println(sketchPath());
  String[] mText = replaceFromTable(loadStrings(mFilenameIN));
  saveStrings(sketchPath() + "/data/" + mFilenameOUT, mText);
  exit();
}

String[] replaceFromTable(String[] pText) {
  Table mTable = loadTable("key-value.tsv");

  for (TableRow row : mTable.rows()) {
    String mKey = row.getString(HEADER_KEY);
    String mValue = row.getString(HEADER_VALUE);
    for (int i=0; i<pText.length; i++) {
      pText[i] = find_and_replace_key(pText[i], mKey, mValue);
    }
  }

  printArray(pText);
  return pText;
}


String find_and_replace_key(String pString, String pKey, String pValue) {
  StringBuffer r = new StringBuffer();
  r.append(PATTERN_BEGIN);
  r.append(pKey);
  r.append(PATTERN_END);
  return pString.replaceAll(r.toString(), pValue);
}
