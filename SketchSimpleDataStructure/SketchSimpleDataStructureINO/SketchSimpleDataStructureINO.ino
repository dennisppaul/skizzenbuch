#include "Card.h"

const int NUM_CARDS = 3;
Card mCards[] = {
  Card("193b439bfa"),
  Card("5994e9b85"),
  Card("49bf499b24"),
};

void setup() {
  for (int i = 0; i < NUM_CARDS; i++) {
    mCards[i].color = Card::RED;
    mCards[i].number = i + 1;
  }
}

void loop() {
  String rfid_1tag = "5994e9b85";

  for (int i = 0; i < NUM_CARDS; i++) {
    Card c = mCards[i];
    if (rfid_1tag.equals(c.ID)) {
      Serial.println("showCardForPlayerBeginn -> " + c.ID + ": " + c.color + " : " + c.number);
    }
  }
}
