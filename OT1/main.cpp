#include "algorithms.h"
#include "datastructure.h"

int main(){
    string re,strm;
    cout << "please input the re_expression:\n->$ ";
    cin >> re;
    NFA mynfa = re2nfa(re);
    writeNfaData(mynfa, "./tmp.nfa");
    DFA mydfa;
    nfa2dfa(mynfa,mydfa);
    writeDfaData(mydfa, "./tmp.dfa");
    DFA my_min_dfa = minimize_dfa(mydfa);
    writeDfaData(my_min_dfa, "./tmp.mindfa");
    return 0;
}