import java.awt.*;
import java.awt.datatransfer.*;

void setup() {
  println(get_clipboard());
  set_clipboard("foobar");
  exit();
}

void set_clipboard(String text) {
  Clipboard clipboard = getSystemClipboard();
  clipboard.setContents(new StringSelection(text), null);
}

String get_clipboard() {
  try {
    Clipboard systemClipboard = getSystemClipboard();
    DataFlavor dataFlavor = DataFlavor.stringFlavor;

    if (systemClipboard.isDataFlavorAvailable(dataFlavor)) {
      Object text = systemClipboard.getData(dataFlavor);
      return (String) text;
    }
  } 
  catch (Exception e) {
  }
  return "";
}

Clipboard getSystemClipboard() {
  Toolkit defaultToolkit = Toolkit.getDefaultToolkit();
  return defaultToolkit.getSystemClipboard();
}
