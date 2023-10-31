#ifndef __DATA_STRUCTURE_H__
#define __DATA_STRUCTURE_H__

#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <map>
#include <set>
#include <stack>
#include <queue>
#include <cstring>
#include <ctime>
#include <climits>

using namespace std;

#define OTHER '^'
#define ERROR -1 

//NFA信息
struct NFA {
    int char_count; // 字符数   
    int state_count; // 状态数
    int start_state;    // 开始状态
    int end_state_count;   // 结束状态数
    vector<int> end_states; // 结束状态列表
    vector<char> character; // 字符列表
    vector<int> states; // 状态列表
    vector< map<char, vector<int> > > transition;  // 状态转移表
};

struct DFA {
    int char_count; // 字符数   
    int state_count; // 状态数
    int start_state;    // 开始状态
    int end_state_count;   // 结束状态数
    vector<int> end_states; // 结束状态列表
    vector<char> character; // 字符列表
    vector<int> states; // 状态列表
    vector< map<char, int> > transition;  // 状态转移表
};

struct Edge {
    int from; //起点
    int to; //终点
    char c; //边的条件
    Edge(int f, int t, char ch) : from(f), to(t), c(ch) {}
};

/**
 * nfa的一个子图, 包含起始状态, 最终状态, 还有一系列边集合
*/
struct Graph{
    int start;
    int end;
    vector<Edge> edges;
};

#endif  // !__DATA_STRUCTURE_H_