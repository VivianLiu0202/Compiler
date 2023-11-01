#ifndef __ALGORITHMS_H_
#define __ALGORITHMS_H_

#include "datastructure.h"

//算法
NFA re2nfa(string re); //正则表达式转NFA
void nfa2dfa(NFA nfa, DFA &dfa); //NFA转DFA
DFA minimize_dfa(DFA dfa); //最小化DFA


string parse_range(string);                                    // 范围解析的函数, 可以解析出如A-Z, a-zA-Z0-9_- 这一类范围定义的字符
void get_closure(NFA, vector<set<int> >&, int, vector<bool>&);  // 分别是nfa, 全部的closure, 当前状态, 是否访问过
Graph Thompson(string, int&);                                  // 解析re_exp的函数, 递归调用, 传递当前已分配状态进去(当前已分配)

#endif  // !__ALGORITHMS_H_