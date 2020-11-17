void setup() {
  size(210, 297);
}

void draw() {
  background(255);
  ellipse(width / 2, height / 2, random(90, 110), random(90, 110));
}

void keyPressed() {
  if (key == 'p') {
    printFrame(g);
  }
}

void printFrame(final PGraphics pPGraphics) {
  java.awt.print.PrinterJob mJob = java.awt.print.PrinterJob.getPrinterJob();
  mJob.setPrintable(new java.awt.print.Printable() {
    public int print(java.awt.Graphics pg, java.awt.print.PageFormat f, int pageIndex) {
      switch (pageIndex) {
      case 0:
        pg.drawImage(pPGraphics.image, 0, 0, null);
        return java.awt.print.Printable.PAGE_EXISTS;
      default:
        return NO_SUCH_PAGE;
      }
    }
  }
  );
  try {
    mJob.print();
  } 
  catch (Exception e) {
    e.printStackTrace();
  }
}
