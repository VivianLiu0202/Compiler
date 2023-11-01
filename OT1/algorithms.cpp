#include "algorithms.h"
#include "datastructure.h"

// * 关键算法

NFA re2nfa(string rexp) {  // Function to convert regular expression to NFA
    // Preprocess rexp, handling the case of []
    string prexp, middle;
    bool is_mid = false;
    for (char c : rexp) {
        if (c == '[') {
            is_mid = true;
            prexp.push_back('(');
        } else if (c == ']') {
            string mid = parse_range(middle);
            prexp += mid + "|";
            prexp.pop_back(); // Remove the last '|'
            prexp.push_back(')');
            middle.clear();
            is_mid = false;
        } else {
            is_mid ? middle += c : prexp += c;
        }
    }
    cout << "prexp: " << prexp << endl;
    rexp = move(prexp);

    int state = 0;
    Graph nfa_graph = parse_re(rexp, state);
    cout<<"正规式转DFA:"<<endl;
    cout << "start: " << nfa_graph.start << endl;
    cout << "end: " << nfa_graph.end << endl;
    for (const auto& edge : nfa_graph.edges) {
        cout << edge.from << ' ' << edge.c << ' ' << edge.to << endl;
    }

    // Get characters other than rule characters
    set<char> char_set;
    char_set.insert('-');
    for (char c : rexp) {
        if (!(c == '|' || c == '(' || c == ')' || c == '*')) {
            char_set.insert(c);
        }
    }

    // Store data into nfa
    NFA nfa;
    nfa.char_count = char_set.size();
    nfa.state_count = state;
    nfa.start_state = 0;
    nfa.end_state_count = 1;
    nfa.end_states.push_back(state - 1);
    nfa.character.assign(char_set.begin(), char_set.end());
    nfa.states.resize(state);
    iota(nfa.states.begin(), nfa.states.end(), 0);
    
    nfa.transition.resize(state);
    for (const auto& edge : nfa_graph.edges) {
        nfa.transition[edge.from][edge.c].push_back(edge.to);
    }

    return nfa;
}

void nfa2dfa(NFA nfa, DFA &dfa) {
    // 1. 计算每个状态的 ε-闭包，并存储
    vector<set<int> > epsilon_closures(nfa.state_count);
    for (int i = 0; i < nfa.state_count; ++i) {
        // 使用深度优先搜索计算ε-闭包
        stack<int> dfs_stack;
        dfs_stack.push(i);
        epsilon_closures[i].insert(i);
        while (!dfs_stack.empty()) {
            int current_state = dfs_stack.top();
            dfs_stack.pop();
            if (nfa.transition[current_state].count('-') > 0) {
                for (int next_state : nfa.transition[current_state]['-']) {
                    if (epsilon_closures[i].count(next_state) == 0) {
                        epsilon_closures[i].insert(next_state);
                        dfs_stack.push(next_state);
                    }
                }
            }
        }
    }

    //查看闭包
    cout << "epsilon-closures: " << endl;
    for (int i = 0; i < nfa.state_count; ++i) {
        cout << i << ": ";
        for (auto clo : epsilon_closures[i]) {
            cout << clo << ' ';
        }
        cout << endl;
    }

    // 2. 子集构造算法
    map<set<int>, int> state_mapping; // 映射: 状态集合 -> DFA状态
    int dfa_state_counter = 0;
    queue<set<int> > processing_queue; // 待处理的NFA状态集合队列

    set<int> start_set = epsilon_closures[nfa.start_state];
    processing_queue.push(start_set);
    state_mapping[start_set] = dfa_state_counter++;

    while (!processing_queue.empty()) {
        set<int> current_set = processing_queue.front();
        processing_queue.pop();

        map<char, int> transition_map; // 存储当前DFA状态的转移

        for (char ch : nfa.character) {
            if (ch == '-') continue; // 忽略ε转移

            set<int> next_set; // 下一个NFA状态集合

            for (int nfa_state : current_set) {
                if (nfa.transition[nfa_state].count(ch) > 0) {
                    for (int next_nfa_state : nfa.transition[nfa_state][ch]) {
                        next_set.insert(epsilon_closures[next_nfa_state].begin(), epsilon_closures[next_nfa_state].end());
                    }
                }
            }

            if (!next_set.empty() && state_mapping.count(next_set) == 0) {
                // 如果是新状态集合，给其分配一个DFA状态，并加入处理队列
                state_mapping[next_set] = dfa_state_counter++;
                processing_queue.push(next_set);
            }

            if (!next_set.empty()) {
                transition_map[ch] = state_mapping[next_set];
            }
        }

        dfa.transition.push_back(transition_map);
    }

    // 3. 设置DFA的其他属性
    dfa.char_count = nfa.char_count;
    dfa.state_count = dfa_state_counter;
    dfa.start_state = 0;
    dfa.character = nfa.character;

    // 判断并设置DFA的终止状态
    for (const auto &entry : state_mapping) {
        const set<int> &nfa_states = entry.first;
        int dfa_state = entry.second;

        for (int final_state : nfa.end_states) {
            if (nfa_states.count(final_state) > 0) {
                dfa.end_states.push_back(dfa_state);
                break;
            }
        }
    }
    dfa.end_state_count = dfa.end_states.size();

    // 填充DFA状态列表
    for (int i = 0; i < dfa_state_counter; ++i) {
        dfa.states.push_back(i);
    }

    cout << "NFA转DFA:" << endl;
    for (int i = 0; i < dfa.transition.size(); ++i) {
        for (const auto &transition : dfa.transition[i]) {
            char character = transition.first; // 获取转移字符
            int nextState = transition.second; // 获取转移后的状态
            cout << i << " " << character << " " << nextState << endl; // 输出 起始状态 转移字符 目标状态
        }
    }
}


DFA minimize_dfa(DFA dfa) {
    vector<set<int> > state2set(dfa.state_count);  
    map<set<int>, int> set_cnt;
    int last;
    
    // 初始化状态集
    set<int> end_states, non_end_states;
    for (int s : dfa.states) {
        if (count(dfa.end_states.begin(), dfa.end_states.end(), s)) {
            end_states.insert(s);
        } else {
            non_end_states.insert(s);
        }
    }
    
    // 分配初始状态集
    for (int s : non_end_states) state2set[s] = non_end_states;
    for (int s : end_states) state2set[s] = end_states;
    
    do {
        set_cnt.clear();
        for (auto& s : state2set) set_cnt[s]++;
        last = set_cnt.size();
        
        for (auto& pair : set_cnt) {
            auto& current_set = pair.first;
            map<set<int>, vector<int> > transitions;
            
            for (char c : dfa.character) {
                map<set<int>, vector<int> > next2state;
                set<int> no_trans_states;
                
                for (int state : current_set) {
                    if (!dfa.transition[state].count(c)) {
                        no_trans_states.insert(state);
                    } else {
                        int next_state = dfa.transition[state][c];
                        next2state[state2set[next_state]].push_back(state);
                    }
                }
                
                // 状态分割
                if (next2state.size() > 1 || (!no_trans_states.empty() && next2state.size() == 1)) {
                    for (auto& next : next2state) {
                        set<int> new_set(next.second.begin(), next.second.end());
                        for (int s : next.second) {
                            state2set[s] = new_set;
                        }
                    }
                    if (!no_trans_states.empty()) {
                        for (int s : no_trans_states) {
                            state2set[s] = no_trans_states;
                        }
                    }
                    break;
                }
            }
        }
        
        for (auto& s : state2set) set_cnt[s]++;
    } while (last != set_cnt.size());
    
    // 构建新的 DFA
    DFA min_dfa;
    map<set<int>, int> set2id;
    int new_id = 0;
    for (auto& pair : set_cnt) set2id[pair.first] = new_id++;
    
    min_dfa.state_count = new_id;
    min_dfa.transition.resize(new_id);
    
    // 添加新的转换
    for (int i = 0; i < dfa.state_count; ++i) {
        int new_from = set2id[state2set[i]];
        for (auto& trans : dfa.transition[i]) {
            int new_to = set2id[state2set[trans.second]];
            min_dfa.transition[new_from][trans.first] = new_to;
        }
    }
    
    // 设置其他 DFA 参数
    min_dfa.character = dfa.character;
    min_dfa.start_state = set2id[state2set[dfa.start_state]];
    for (int end_state : dfa.end_states) {
        min_dfa.end_states.push_back(set2id[state2set[end_state]]);
    }
    min_dfa.end_state_count = min_dfa.end_states.size();

    cout << "最小化DFA:" << endl;
    for (int i = 0; i < min_dfa.transition.size(); ++i) {
        for (const auto &transition : min_dfa.transition[i]) {
            char character = transition.first; // 获取转移字符
            int nextState = transition.second; // 获取转移后的状态
            cout << i << " " << character << " " << nextState << endl; // 输出 起始状态 转移字符 目标状态
        }
    }
    
    return min_dfa;
}

string parse_range(string str) { //解析范围定义的函数
    string range;  // 用来存储解析后得到的字符范围
    for (size_t i = 0; i < str.size(); ++i) {
        char current_char = str[i];  // 当前处理的字符
        // 检查是否是一个范围的开始
        if (i + 2 < str.size() && str[i + 1] == '-' && current_char < str[i + 2]) { 
            // 如果识别到一个范围，例如"A-Z"
            for (char c = current_char; c <= str[i + 2]; ++c) { // 遍历范围内的每一个字符
                range += c;  // 将字符加入到结果字符串中
            }
            i += 2;  // 跳过已经处理过的字符
        } else {
            range += current_char;  // 如果不是范围，直接将字符加入到结果字符串中
        }
    }
    return range;  // 返回解析后得到的字符串
}

void get_closure(NFA nfa, vector<set<int> > &closures, int state, vector<bool> &visited) {
    /**
     * ! 获取nfa某状态闭包的函数。存储在closures中。
     * ! 参数解释:
     * NFA nfa: 要求闭包的nfa。
     * vector<set<int>> &closures: 闭包存储的数据结构。
     * int state: 当前要求闭包的状态。由于dfa, 先求出它可以扩展的状态, 再回来求它。
     * vector<bool> &visited: 回溯的标记, 先标记为true, 回溯之后标记为false。
     */
     
    if (visited[state]) return; // 如果该状态已访问过，直接返回，避免无限递归

    visited[state] = true;  // 标记当前状态已访问
    closures[state].insert(state);  // 将自身状态添加到闭包中

    // 遍历从当前状态出发的所有转换
    for (const auto& transition : nfa.transition[state]) {
        char symbol = transition.first;
        const auto& next_states = transition.second;

        if (symbol == '-') {  // 检查是否是epsilon转换（空转换）
            for (int next_state : next_states) {
                // 递归获取epsilon转换状态的闭包
                get_closure(nfa, closures, next_state, visited);
                // 将找到的状态添加到当前状态的闭包中
                closures[state].insert(closures[next_state].begin(), closures[next_state].end());
            }
        }
    }

    visited[state] = false;  // 撤销当前状态的访问标记，以便于后续递归调用
}


Graph parse_re(string rexp, int &state) {
    if (rexp.size() == 1) {  // ! 当只有一个字符时, 构造基本的转移函数, 然后返回. 这是这个函数的递归基例
        Graph base;
        base.start = state++;
        base.end   = state++;
        Edge edge(base.start, rexp[0], base.end);
        base.edges.push_back(edge);
        return base;
    }
    vector<Graph> graphes;  // 这个rexp可以解析出来的所有graph, 用vector存储, 方便合并
    bool has_bra = count(rexp.begin(), rexp.end(), '(');  // 是否有括号
    bool or_out  = false;                                 // | 是否在括号外面
    int or_loc   = 0;
    if (has_bra) {
        stack<char> in_or_out;
        int i = 0;
        for (auto s : rexp) {
            i++;
            if (s == '(') {
                in_or_out.push('*');
            } else if (s == ')') {
                in_or_out.pop();
            }
            if (s == '|' && in_or_out.size() == 0) {
                or_out = true;
                or_loc = i - 1;
            }
        }
    }
    if (has_bra && or_out == false) {  // 存在括号, 且如果出现 | , 都在括号之中
        // 检测到有括号, 解析括号
        stack<char> bra;  // 括号, 用来处理括号嵌套的情况
        string sub_rexp;
        for (int i = 0; i < rexp.size(); ++i) {
            char c = rexp[i];
            if (c == '(') {
                if (sub_rexp.size() && bra.size() == 0) {
                    graphes.push_back(parse_re(sub_rexp, state));
                    sub_rexp.clear();
                }
                bra.push('*');
                if (bra.size() != 1) sub_rexp.push_back('(');
            } else if (c == ')') {
                bra.pop();
                if (bra.size() != 0) sub_rexp.push_back(')');
                if (bra.size() == 0) {  // 最外层括号被弹出, 将括号包裹的部分进行解析
                    if (i + 1 < rexp.size() && (rexp[i + 1] == '*' || rexp[i + 1] == '+')) {  // * 对 * 和 + 的解析
                        if (rexp[i + 1] == '+')
                            graphes.push_back(parse_re(sub_rexp, state));
                        int start = state++;
                        graphes.push_back(parse_re(sub_rexp, state));
                        int end = state++;
                        graphes.back().edges.push_back(Edge(start, '-', graphes.back().start));
                        graphes.back().edges.push_back(Edge(graphes.back().end, '-', graphes.back().start));
                        graphes.back().edges.push_back(Edge(graphes.back().end, '-', end));
                        graphes.back().edges.push_back(Edge(start, '-', end));
                        graphes.back().start = start;
                        graphes.back().end   = end;
                        i++;
                    } else {
                        graphes.push_back(parse_re(sub_rexp, state));
                    }
                    sub_rexp.clear();
                }
            } else {
                sub_rexp += c;
            }
        }
        if (sub_rexp.size()) {
            graphes.push_back(parse_re(sub_rexp, state));
            sub_rexp.clear();
        }
    } 
    else if (count(rexp.begin(), rexp.end(), '|')) {  // ! 解析或, 没有括号的存在
        string sub_rexp;
        Graph merge;
        merge.start = state++;  // 先编号开始, 顺序好看些
        int i       = 0;
        for (auto s : rexp) {
            i++;
            if (s == '|') {
                if (or_out && or_loc != (i - 1)) {
                    sub_rexp += s;
                    continue;
                }
                if (sub_rexp.size()) {
                    graphes.push_back(parse_re(sub_rexp, state));
                    sub_rexp.clear();
                }
            } else {
                sub_rexp += s;
            }
        }
        if (sub_rexp.size()) {
            graphes.push_back(parse_re(sub_rexp, state));
            sub_rexp.clear();
        }
        merge.end = state++;
        for (auto graph : graphes) {
            merge.edges.push_back(Edge(merge.start, '-', graph.start));
            merge.edges.insert(merge.edges.end(), graph.edges.begin(), graph.edges.end());
            merge.edges.push_back(Edge(graph.end, '-', merge.end));
        }
        return merge;  // ! 处理或的直接返回, 因为和处理简单的并或者括号不一样
    } 
    else {           // 处理普通的没有 | , 也没有括号的情况
        for (int i = 0; i < rexp.size(); ++i) {
            string next_rexp;
            next_rexp += rexp[i];
            if (i + 1 < rexp.size() && (rexp[i + 1] == '*' || rexp[i + 1] == '+')) {  // * 对 * 和 + 的解析
                if (rexp[i + 1] == '+')
                    graphes.push_back(parse_re(next_rexp, state));
                int start = state++;
                graphes.push_back(parse_re(next_rexp, state));
                int end = state++;
                graphes.back().edges.push_back(Edge(start, '-', graphes.back().start));
                graphes.back().edges.push_back(Edge(graphes.back().end, '-', graphes.back().start));
                graphes.back().edges.push_back(Edge(graphes.back().end, '-', end));
                graphes.back().edges.push_back(Edge(start, '-', end));
                graphes.back().start = start;
                graphes.back().end   = end;
                i++;
            } else {
                graphes.push_back(parse_re(next_rexp, state));
            }
            next_rexp.clear();
        }
    }

    // 解析多原子单位的合并
    Graph merge;
    merge.start = graphes[0].start;
    merge.end   = graphes.back().end;
    merge.edges = graphes[0].edges;
    for (int i = 1; i < graphes.size(); ++i) {
        merge.edges.push_back(Edge(graphes[i - 1].end, '-', graphes[i].start));
        merge.edges.insert(merge.edges.end(), graphes[i].edges.begin(), graphes[i].edges.end());
    }
    return merge;
}
