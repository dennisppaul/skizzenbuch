import java.util.Stack;

void setup() {
  /*
   *   0
   *   |
   * +-+-+
   * |   |
   * 1   2
   *   +-+-+
   *   | | |
   *   3 4 5
   *       |
   *       6
   */
  Node root = new Node();
  Node lv1_0 = new Node();
  Node lv1_1 = new Node();
  root.addChild(lv1_0);
  root.addChild(lv1_1);
  Node lv2_0 = new Node();
  Node lv2_1 = new Node();
  Node lv2_2 = new Node();
  lv1_1.addChild(lv2_0);
  lv1_1.addChild(lv2_1);
  lv1_1.addChild(lv2_2);
  Node lv3_0 = new Node();
  lv2_2.addChild(lv3_0);

  println("process_with_stack:");
  process_with_stack(root);
  println("---");
  println("process_with_arraylist_breadth_first:");
  process_with_arraylist_breadth_first(root);
  println("---");
  println("process_with_arraylist_depth_first:");
  process_with_arraylist_depth_first(root);
}

static class Node {
  public ArrayList<Node> children;

  static int oID;
  int ID;

  Node() {
    ID = oID;
    oID++;
    children = new ArrayList<Node>();
  }

  void addChild(Node node) {
    children.add(node);
  }

  void traverse_breadth_first(ArrayList<Node> pNodeList) {
    for (Node mChild : children) {
      pNodeList.add(mChild);
      mChild.traverse_breadth_first(pNodeList);
    }
  }

  void traverse_depth_first(ArrayList<Node> pNodeList) {
    for (Node mChild : children) {
      mChild.traverse_depth_first(pNodeList);
    }
    pNodeList.add(this);
  }
}

void process_with_stack(Node node) {
  Stack<Node> st = new Stack();
  st.push(node);
  while (!st.empty()) {
    Node stParent = st.pop();
    Node parent = stParent;
    println("node ID: " + parent.ID);
    for (int i = 0; i < parent.children.size(); i++) {
      Node child = parent.children.get(i);
      st.push(child);
    }
  }
}

void process_with_arraylist_breadth_first(Node pRoot) {
  /* breadth-first search */
  ArrayList<Node> mNodeList = new ArrayList();
  mNodeList.add(pRoot);
  pRoot.traverse_breadth_first(mNodeList);
  for (Node mChild : mNodeList) {
    println("node ID: " + mChild.ID);
  }
}

void process_with_arraylist_depth_first(Node pRoot) { 
  /* depth-first traversal post-order */
  ArrayList<Node> mNodeListDepthFirst = new ArrayList();
  pRoot.traverse_depth_first(mNodeListDepthFirst);
  for (Node mChild : mNodeListDepthFirst) {
    println("node ID: " + mChild.ID);
  }
}
