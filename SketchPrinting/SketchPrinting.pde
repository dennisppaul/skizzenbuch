/* Code adapted for Processing By Ben Fry and Amit Pitaru (2005-10-15) */

import java.awt.print.*;

PrinterJob job;

void setup() {
  size(200, 200);
}

void draw() {
  background(255);
  ellipse(width / 2, height / 2, random(90, 110), random(90, 110));
}

void keyPressed() {
  if (key == 't') {
    printStageThreaded();
  }
  if (key == 'p') {
    printStage();
  }
}

void printStageThreaded() {
  job = PrinterJob.getPrinterJob();

  Runnable printRunner = new Runnable() {
    public void run() {
      handlePrint();
    }
  };
  javax.swing.SwingUtilities.invokeLater(printRunner);
}

void printStage() {
  job = PrinterJob.getPrinterJob();
  handlePrint();
}

void handlePrint() {
  job.setPrintable(new Printable() {
    public int print(java.awt.Graphics pg, PageFormat f, int pageIndex) {
      switch (pageIndex) {
      case 0:
        pg.drawImage(g.image, 0, 0, null);
        return Printable.PAGE_EXISTS;
      default:
        return NO_SUCH_PAGE;
      }
    }
  }
  );
  try {
    job.print();
  }
  catch (PrinterException e) {
    System.out.println(e);
  }
}
