Node mRoot;
float mScale = 1.0;
float mFontSize = 18.0;

void setup() {
  size(1024, 768, P3D);
  textFont(createFont("Courier", mFontSize));
  textAlign(CENTER);

  /* 
   * downloading *vertebrata* XML ( `node_id=14829` ) from [tree of life web project](http://tolweb.org)
   * ( this may takle a while ... approx 50MB )
   * consider downloading the XML file and loading it via `XML mXML = loadXML("vertebrata.xml");`
   * or use another `node_id` ( e.g `node_id=16418` for *humans* )
   * 
   */
  XML mXML = loadXML("http://tolweb.org/onlinecontributors/app?service=external&page=xml/TreeStructureService&node_id=14829");
  //XML mXML = loadXML("vertebrata.xml");
  //XML mXML = loadXML("http://tolweb.org/onlinecontributors/app?service=external&page=xml/TreeStructureService&node_id=16418");
  mRoot = new Node(mXML.getChild("NODE"), null);
}

void draw() {
  background(50);

  /* move tree view to center and zoom in */
  translate(width / 2, height / 2);
  scale(mScale);
  float mOffsetX = -(float)mouseX/width;
  float mOffsetY = -(float)mouseY/height + 0.5;
  translate(width * mOffsetX, height * mOffsetY);

  /* start recursive drawing */
  strokeWeight(1.0 / mScale);
  textSize(mFontSize / mScale);
  mRoot.draw(mScale, mousePressed);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  mScale += ( e * 0.1 );
  mScale = mScale < 1.0 ? 1.0 : mScale;
}
