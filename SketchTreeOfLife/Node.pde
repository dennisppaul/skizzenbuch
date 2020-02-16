class Node {
  final float X_ADVANCE = 9.0;
  final float X_OFFSET  = 0.5;
  final float Y_OFFSET  = 17.5;

  ArrayList<Node> mChildren = new ArrayList<Node>();
  String mName = "";
  boolean mIsLeaf = true;
  PVector mPosition;
  Node mParent;
  boolean WE_ARE_HERE = false;

  Node(XML pNodeData, Node pParent) {
    mParent = pParent;
    mPosition = new PVector();
    String mLeafInfo = pNodeData.getString("LEAF");
    if (mLeafInfo != null) {
      mIsLeaf = pNodeData.getString("LEAF").equals("1");
    }
    XML mNameInfo = pNodeData.getChild("NAME");
    if (mNameInfo != null) {
      mName = pNodeData.getChild("NAME").getContent();
    }
    if (mName.equals("Homo sapiens")) {
      WE_ARE_HERE= true;
    }

    /* find absolut position in relation to parent node */
    if (mParent != null) {
      mPosition.set(mParent.position());
      mPosition.x += X_ADVANCE + random(-X_OFFSET, X_OFFSET);
      mPosition.y += random(-Y_OFFSET, Y_OFFSET);
    }

    /* create children */
    XML mChildNodes = pNodeData.getChild("NODES");
    if (mChildNodes != null) {
      for (int i = 0; i < mChildNodes.getChildCount(); i++) {
        XML mChildNode = mChildNodes.getChild(i);
        Node mChild = new Node(mChildNode, this);
        mChildren.add(mChild);
      }
    }
  }

  PVector position() {
    return mPosition;
  }

  void draw(float pScale, boolean pDrawText) {
    /* draw line from node to parent */
    if (mParent != null) {
      stroke(255, 127);
      line(mPosition.x, mPosition.y, mParent.position().x, mParent.position().y);
    }
    /* mark leaf */
    if (mIsLeaf) {
      if (WE_ARE_HERE) {
        fill(255, 127, 0);
        noStroke();
        final float d = 60.0 / pScale;
        ellipse(mPosition.x, mPosition.y, d, d);
      }
      stroke(0, 127, 255, 91);
      final float c = 5.0 / pScale;
      line(mPosition.x + c, mPosition.y + c, mPosition.x - c, mPosition.y - c);
      line(mPosition.x - c, mPosition.y + c, mPosition.x + c, mPosition.y - c);
    }
    /* draw name */
    if (pDrawText) {
      fill(255);
      noStroke();
      text(mName, mPosition.x, mPosition.y);
    }
    /* handle children */
    for (int i = 0; i < mChildren.size(); i++) {
      mChildren.get(i).draw(pScale, pDrawText);
    }
  }
}
