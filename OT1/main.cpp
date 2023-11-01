#include "algorithms.h"
#include "datastructure.h"

int main(){
    string re,strm;
    cout << "please input the re_expression: ";
    cin >> re;
    NFA mynfa = re2nfa(re);
    DFA mydfa;
    nfa2dfa(mynfa,mydfa);
    DFA my_min_dfa = minimize_dfa(mydfa);
    return 0;
}