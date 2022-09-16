String[] mNames = {
    "Fabian",
    "Julia",
    "Jiawen",
    "Sangbong",
    "Alethia",
    "Mia",
    "Alberto",
    "Nilya",
};

int mNumberOfItems = 3;

int getHashFromString(String s) {
    int mHash = 0;
    for (int i = 0; i < s.length(); i++) {
        mHash += s.charAt(i);
    }
    return mHash;
}

void setup() {
    for (int i = 0; i < mNames.length; i++) {
        int mHash = getHashFromString(mNames[i]);
        mHash %= mNumberOfItems;
        println(mHash +  ": "  + mNames[i]);
    }
}
