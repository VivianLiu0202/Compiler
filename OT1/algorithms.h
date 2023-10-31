#ifndef __ALGORITHMS_H_
#define __ALGORITHMS_H_

#include "datastructure.h"

//算法
NFA re2nfa(string re); //正则表达式转NFA
void nfa2dfa(NFA nfa, DFA &dfa); //NFA转DFA
DFA minimize_dfa(DFA dfa); //最小化DFA


string parse_range(string); //范围解析的函数
Graph parse_re(string,int&);  //解析正则式的函数，递归调用传递当前一分配的状态进去
void get_closure(NFA,vector< set<int> >&,int,vector<bool>&); //获取闭包    

void writeNfaData(NFA, string);  // 将NFA写入到nfa文件中
void writeDfaData(DFA, string);  // 将转化成的dfa写入到dfa文件中

#endif  // !__ALGORITHMS_H_