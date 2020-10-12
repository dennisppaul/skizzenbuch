class Card {
  public:
    String ID;
    uint8_t color;
    uint8_t number;

    static const uint8_t RED = 0;
    static const uint8_t BLUE = 1;
    static const uint8_t GREEN = 2;
    static const uint8_t YELLOW = 3;

    Card(String pID) {
      ID = pID;
    }
};
