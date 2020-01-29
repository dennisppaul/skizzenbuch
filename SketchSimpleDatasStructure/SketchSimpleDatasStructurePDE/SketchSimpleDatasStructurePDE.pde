ArrayList<Card> mCards;

void setup() {
  mCards = new ArrayList<Card>();
  mCards.add(new Card("193b439bfa"));
  mCards.add(new Card("5994e9b85"));
  mCards.add(new Card("49bf499b24"));

  for (int i=0; i<mCards.size(); i++) {
    mCards.get(i).mcolor = Card.RED;
    mCards.get(i).mcolor = i + 1;
  }
}

void draw() {
  String rfid_1tag = "5994e9b85";

  for (int i=0; i<mCards.size(); i++) {
    Card c = mCards.get(i);
    if (rfid_1tag.equals(c.ID)) {
      println("showCardForPlayerBeginn -> " + c.ID + ": " + c.mcolor + " : " + c.number);
    }
  }
}
