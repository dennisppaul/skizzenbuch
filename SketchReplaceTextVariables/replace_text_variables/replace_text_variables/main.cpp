//
//  replace_text_variables
//

#include <iostream>
#include <fstream>
#include <vector>
#include <iterator>
#include <string>
#include <algorithm>
#include <sstream>
#include <regex>

using namespace std;

class CSVReader {
    string mTextFileName;
    string mKeyValuesFileName;
    string mOutputFileName;
    char delimeter;
    const string PATTERN_BEGIN = "\\$\\[";
    const string PATTERN_END = "\\]";
    
public:
    CSVReader(string text, string keyvalues, string out, char delm = ',') :
    mTextFileName(text),
    mKeyValuesFileName(keyvalues),
    mOutputFileName(out),
    delimeter(delm) {
        vector<string> mNewText = replaceVariables(loadText(), getData());
        
        std::ofstream outfile;
        outfile.open(mOutputFileName, std::ios_base::app);
        
        for(string mLine : mNewText) {
            outfile << mLine << endl;
        }
    }
    
    vector<vector<string>> getData();
    vector<string> loadText();
    vector<string> replaceVariables(vector<string> pText, vector<vector<string>> pKeyValues);
    
private:
    vector<string> split(const string& s, char delimiter);
};

vector<string> CSVReader::loadText() {
    vector<string> tokens;
    ifstream file(mTextFileName);
    string line = "";
    while (getline(file, line)) {
        tokens.push_back(line);
    }
    return tokens;
}

vector<string> CSVReader::replaceVariables(vector<string> pText, vector<vector<string>> pKeyValues)  {
    vector<string> mNewText;
    for(vector<string> mKeyValue : pKeyValues) {
        for(string mLine : pText) {
            string mKey = mKeyValue[0];
            string mValue = mKeyValue[1];
            string s;
            s.append(PATTERN_BEGIN);
            s.append(mKey);
            s.append(PATTERN_END);
            regex e (s);
            // from http://www.cplusplus.com/reference/regex/regex_replace/
            string mResult = regex_replace (mLine, e, mValue);
            mNewText.push_back(mResult);
        }
        pText = mNewText;
        mNewText.clear();
    }
    
    cout << "output:" << endl << endl;

    for(string mLine : pText) {
        cout << "> " << mLine << endl;
    }
    return pText;
}

vector<string> CSVReader::split(const string& s, char delimiter) {
    vector<string> tokens;
    string token;
    istringstream tokenStream(s);
    while (getline(tokenStream, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

vector<vector<string>> CSVReader::getData() {
    ifstream file(mKeyValuesFileName);
    vector<vector<string> > dataList;
    
    string line = "";
    while (getline(file, line)) {
        vector<string> vec;
        vec = split(line, delimeter);
        dataList.push_back(vec);
    }
    file.close();
    
    return dataList;
}

const string DELIMETER_TOKEN_TAB_STR = "TAB";
const string DELIMETER_TOKEN_COMMA_STR = "COMMA";
const string DELIMETER_TOKEN_SEMICOLON_STR = "SEMICOLON";
const char DELIMETER_TOKEN_TAB = '\t';
const char DELIMETER_TOKEN_COMMA = ',';
const char DELIMETER_TOKEN_SEMICOLON = ';';

int main(int argc, const char * argv[]) {
    if (argc < 4 || argc > 5) {
        cout << "usage: replace_text_variables input_file variable_map_file output_file [delimiter TAB|COMMA|SEMICOLON]" << endl;
    } else {
        char mDelimeter;
        if (argc == 5) {
            string mDelimeterArg = string(argv[4]);
            if (mDelimeterArg == DELIMETER_TOKEN_TAB_STR) {
                mDelimeter = DELIMETER_TOKEN_TAB;
            } else if (mDelimeterArg == DELIMETER_TOKEN_COMMA_STR) {
                mDelimeter = DELIMETER_TOKEN_COMMA;
            } else if (mDelimeterArg == DELIMETER_TOKEN_SEMICOLON_STR) {
                mDelimeter = DELIMETER_TOKEN_SEMICOLON;
            } else {
                mDelimeter = DELIMETER_TOKEN_COMMA;
            }
        } else {
            mDelimeter = DELIMETER_TOKEN_COMMA;
        }
        CSVReader reader(argv[1], argv[2], argv[3], mDelimeter);
    }
    return 0;
}
