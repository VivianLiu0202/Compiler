#include "algorithms.h"
#include "datastructure.h"

/**
 * 正则表达式转nfa Thompson算法
*/
NFA re2nfa(string re) {
    //对于正则式进行一些预处理，处理[]的情况
    string prexp,middle;
    bool is_mid = 0;
    for (auto c: re){
        if(c=='['){
            is_mid = 1;
            prexp.push_back('(');
        }
        else if (c==']'){
            string mid = parse_range(middle);
            for (auto m: mid){
                prexp += m;
                prexp += '|';
            }
            prexp.pop_back();
            prexp.push_back(')');
            is_mid = false;
            middle = "";
        }
        else if (is_mid){
            middle += c;
        }
        else{
            prexp += c;
        }
    }

    cout<<"prexp: "<<prexp<<endl;
    re = prexp;

    int state = 0;
    Graph nfa_graph = parse_re(re, state);
    cout << "start: " << nfa_graph.start << endl;
    cout << "end: " << nfa_graph.end << endl;
    for (auto edge : nfa_graph.edges) {
        cout << edge.from << ' ' << edge.c << ' ' << edge.to << endl;
    }


    //获取除了规则字符之外的字符
    set<char> other_char;
    other_char.insert('~');
    for (auto c: re){
        if (not(c == '|' || c == '(' || c == ')' || c == '*')) {
            other_char.insert(c);
        }
    }

    //将数据存入nfa中
    NFA nfa;
    nfa.char_count = other_char.size();
    nfa.state_count = state;
    nfa.start_state = 0;
    nfa.end_state_count = 1;
    nfa.end_states.push_back(state-1);
    for (auto c: other_char){
        nfa.character.push_back(c);
    }
    for (int i=0;i<state;i++){
        nfa.states.push_back(i);
    }
    vector< map<char, vector<int> > > transition(state);
    for (auto e: nfa_graph.edges){
        transition[e.from][e.c].push_back(e.to);
    }
    nfa.transition = transition;
    return nfa;
}

void nfa2dfa(NFA nfa,DFA &dfa){
    /**
     * 1. 先获取所有的epsilon闭包 为O(n)
     * 2. 然后根据闭包进行状态转移 使用子集构造算法
    */
    //将所有状态的闭包一次性计算出来
    vector< set<int> > closures = vector< set<int> >(nfa.state_count,set<int>());
    vector<bool> ext_start(nfa.state_count);
    for(int i=0;i<nfa.state_count;i++){
        if(closures[i].size()==0){
            ext_start[i] = true;
            vector<bool> visited(nfa.state_count);
            visited[i] = true;
            get_closure(nfa,closures,i,visited);
            visited[i] = false;
        }
    }
    
    //使用子集构造算法
    map<int,vector<int> > ext_closure_map;
    for(int i=0;i<nfa.state_count;i++){
        for(auto m: nfa.transition[i]){
            if(m.first == '~'){
                for(auto s: m.second){
                    ext_closure_map[i].push_back(s);
                }
            }
        }
    }
    cout << "ext_closure_map:" << endl;
    for (auto m: ext_closure_map) {
        for (auto v: m.second) {
            cout << m.first << ' ' << v << endl;
        }
    }

    for(int i=0;i<nfa.state_count;i++){
        queue<int> q;
        vector<int> visited(nfa.state_count);
        q.push(i);
        visited[i] = true;
        while(not q.empty()){
            int now = q.front();
            q.pop();
            for(auto v:ext_closure_map[now]){
                if(visited[v] == false){
                    closures[i].insert(closures[v].begin(),closures[v].end());
                    q.push(v);
                    visited[v] = true;
                }
            }
        }
    }

    //查看闭包
    cout << "closures: " << endl;
    for (int i = 0; i < nfa.state_count; ++i) {
        cout << i << ": ";
        for (auto clo : closures[i]) {
            cout << clo << ' ';
        }
        cout << endl;
    } 

    //进行接收状态的扩展
    set<int> ext_end_states;
    for(auto x: nfa.end_states){
        ext_end_states.insert(x); //先插入最基本的接收状态
    }
    int ic = 0;
    for(auto closure : closures){
        ic++;
        for(auto x: closure){
            if(ext_end_states.count(x)){
                ext_end_states.insert(ic-1);
                break;
            }
        }
    }

    cout << "ext_end_states: ";
    for (auto s : ext_end_states) {
        cout << s << ' ';
    }
    cout << endl;

    //开始构造DFA,使用子集构造算法
    set<int> end_states;
    if(ext_end_states.count(0)){
        end_states.insert(0);
    }
    map<set<int>,int> set_hash;
    vector<map<char,int> > transition_dfa;
    set<int> set_visied;
    int set_state;
    set_hash[closures[nfa.start_state]] = set_state++;
    cout << "0: ";
    for (auto s: closures[nfa.start_state]) {
        cout << s << ' ';
    }
    cout << endl;

    transition_dfa.push_back(map<char,int>());
    set_visied.insert(set_hash[closures[nfa.start_state]]);
    queue<set<int> > work_queue;
    work_queue.push(closures[nfa.start_state]);
    while(not work_queue.empty()){
        set<int> now = work_queue.front();
        work_queue.pop();
        for(auto c: nfa.character){
            set<int> next_state_set;
            for(auto state: now){
                if(nfa.transition[state].count(c)){
                    for(auto next_state: nfa.transition[state][c]){
                        set<int> next_closure = closures[next_state];
                        next_state_set.insert(next_closure.begin(),next_closure.end());
                    }
                }
            }
            if(next_state_set.size()==0){
                if(set_hash.count(next_state_set)==0){
                    set_hash[next_state_set] = set_state++;
                    cout << set_state - 1 << ": ";
                    for (auto s: next_state_set) {
                        cout << s << ' ';
                    }
                    cout << endl;
                    for(auto s : next_state_set){
                        if(ext_end_states.count(s)){
                            end_states.insert(set_state-1);
                            break;
                        }
                    }
                    transition_dfa.push_back(map<char,int>());
                }
                int set_hash_next_state = set_hash[next_state_set];
                transition_dfa[set_hash[now]][c] = set_hash_next_state;
                if(set_visied.count(set_hash_next_state)==0){
                    set_visied.insert(set_hash_next_state);
                    work_queue.push(next_state_set);
                }
            }
        }
    }

    cout<<"子集构造法"<<endl;
    for (auto s: set_hash) {
        cout << s.second << ": ";
        for (auto v: s.first) {
            cout << ' ';
        }
        cout << endl;
    }

    //将数据存入dfa中
    dfa.char_count = nfa.char_count;
    dfa.state_count = set_state;
    dfa.start_state = 0;
    dfa.end_state_count = end_states.size();
    dfa.character = nfa.character;
    for(int i=0;i<dfa.state_count;i++){
        dfa.states.push_back(i);
    }
    for(auto s: end_states){
        dfa.end_states.push_back(s);
    }
    dfa.transition = transition_dfa;
}

DFA minimize_dfa(DFA dfa){
    //先分出终止状态集和非终止状态集
    set<int> no_end,end;
    for(auto s : dfa.states){
        if(count(dfa.end_states.begin(),dfa.end_states.end(),s)){
            end.insert(s);
        }
        else{
            no_end.insert(s);
        }
    }

    vector<set<int> > state2set(dfa.state_count);
    for(auto s : no_end){
        state2set[s] = no_end;
    }
    for(auto s : end){
        state2set[s] = end;
    }

    //集合的记录
    map<set<int>,int> set_cnt;
    for(auto s : state2set){
        set_cnt[s] = 1;
    }
    int last = set_cnt.size();

    while(true){
        bool flag = false;
        for(auto one : set_cnt){
            set<int> currenr_set = one.first;
            for(auto c : dfa.character){
                map<set<int>,vector<int> > next2state;
                set<int> empty_states;
                bool empty = false;
                for(auto state : currenr_set){
                    if(dfa.transition[state].count(c) == 0){
                        empty = true;
                        empty_states.insert(state);
                    }
                    else{
                        int next = dfa.transition[state][c];
                        next2state[state2set[next]].push_back(state);
                    }
                }
                if(next2state.size() >1 || (empty && next2state.size()==1)){
                    for(auto next_states: next2state){
                        set<int> new_set;
                        for(auto new_set_state : next_states.second){
                            new_set.insert(new_set_state);
                        }
                        for(auto new_set_state : next_states.second){
                            state2set[new_set_state] = new_set;
                        }
                    }
                    if(empty){
                        for(auto s:empty_states){
                            state2set[s] = empty_states;
                        }
                    }
                    flag = true;
                    break;
                }
                if(flag) break;
            }
            if(flag) break;
        }
        // ! 统计集合的数量, 和上一次进行比较
        set_cnt.clear();            // 清空, 重新统计.
        for (auto s : state2set) {  // 统计split之后集合个数
            set_cnt[s] = 1;
        }
        if (last == set_cnt.size()) break;  // 集合没有变化了, 说明不可再划分
        last = set_cnt.size();
    }

    //合并旧状态为新状态
    DFA min_dfa;
    int new_state_id = 0;
    map<set<int>,int> set2id;
    for(auto Set : set_cnt){
        set2id[Set.first] = new_state_id++;
    }
    vector<map<char,int> > new_transition(new_state_id);
    for(int from = 0;from<dfa.state_count;++from){
        for(auto m : dfa.transition[from]){
            new_transition[set2id[state2set[from]]][m.first] = set2id[state2set[m.second]];
        }
    }
    min_dfa.transition = new_transition;
    min_dfa.char_count = dfa.char_count;
    min_dfa.state_count = new_state_id;
    min_dfa.start_state = 0;
    set<int> end_states_set;
    for(auto one_end_state : dfa.end_states){
        end_states_set.insert(set2id[state2set[one_end_state]]);
    }
    for(auto s : end_states_set){
        min_dfa.end_states.push_back(s);
    }
    min_dfa.end_state_count = min_dfa.end_states.size();
    min_dfa.character = dfa.character;
    for(int i=0;i<new_state_id;i++){
        min_dfa.states.push_back(i);
    }

    //成功最小化, 查看各个状态所属的集合
    for (int i = 0; i < dfa.state_count; ++i) {
        cout << i << ": ";
        for (auto s : state2set[i]) {
            cout << s << ' ';
        }
        cout << endl;
    }
    return min_dfa;

}

string parse_range(string str) {
    /**
     * ! 范围解析的函数
     * ! 可以解析出如A-Z, a-zA-Z0-9_- 这一类范围定义的字符
     * 以字符串形式返回
     */
    if (str.size() == 1) return str;
    string range;
    for (size_t i = 0; i < str.size(); ++i) {
        if (i + 1 < str.size() and str[i + 1] == '-') {  // 识别到一个范围
            for (auto x = str[i]; x <= str[i + 2]; ++x) {
                range += x;
            }
            i += 2;
        } else {
            range += str[i];
        }
    }
    return range;
}

void get_closure(NFA nfa, vector<set<int> > &closures, int state, vector<bool> &visted) {
    /**
     * ! 获取nfa某状态闭包的函数. 存储在closures中
     * !  参数解释: 
     * NFA nfa: 要求闭包的nfa
     * vector<set<int>> &closures: 闭包存储的数据结构
     * int state: 当前要求闭包的状态. 由于dfa, 先求出它可以扩展的状态, 再回来求它
     * vector<bool> &visted: 回溯的标记, 先标记为true, 回溯之后标记为false
     */
    if (closures[state].size()) return;
    for (auto x : nfa.transition[state]) {                                                 // 当前状态的map集
        if (x.first == '~') {                                                        // 当边为 空 时, 可以滑动求闭包
            for (auto y : x.second) {                                                // 遍历下一状态
                if (visted[y] == false) {                                            // 当前递归路径没有被访问过
                    visted[y] = true;                                                // 标记访问
                    get_closure(nfa, closures, y, visted);                           // 递归得到下一状态闭包
                    closures[state].insert(closures[y].begin(), closures[y].end());  // 更新当前状态闭包
                    visted[y] = false;                                               // 撤销标记
                }
            }
        }
    }
    closures[state].insert(state);  // ! ...插入自己......
}

Graph parse_re(string rexp, int &state) {
    // cout << "exp = " << rexp << endl;
    if (rexp.size() == 1) {  // ! 当只有一个字符时, 构造基本的转移函数, 然后返回. 这是这个函数的递归基例
        Graph base;
        base.start = state++;
        base.end   = state++;
        Edge edge(base.start, rexp[0], base.end);
        base.edges.push_back(edge);
        return base;
    }
    vector<Graph> graphes;  // 这个rexp可以解析出来的所有graph, 用vector存储, 方便合并

    // 一种特殊情况 (ac)*|b, 要和 (ac | b*)) 这种区分开来.
    // ! 也就是说如果存在不在括号中的 | , 但括号再rexp中存在的情况, 要先处理 |
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
                // cout << "2 - " << sub_rexp << endl;
                bra.pop();
                if (bra.size() != 0) sub_rexp.push_back(')');
                if (bra.size() == 0) {  // 最外层括号被弹出, 将括号包裹的部分进行解析
                    // cout << "bar = 0: " << sub_rexp << endl;
                    // 增加对括号闭包的操作
                    if (i + 1 < rexp.size() && (rexp[i + 1] == '*' || rexp[i + 1] == '+')) {  // * 对 * 和 + 的解析
                        if (rexp[i + 1] == '+')
                            graphes.push_back(parse_re(sub_rexp, state));
                        int start = state++;
                        graphes.push_back(parse_re(sub_rexp, state));
                        int end = state++;
                        graphes.back().edges.push_back(Edge(start, '~', graphes.back().start));
                        graphes.back().edges.push_back(Edge(graphes.back().end, '~', graphes.back().start));
                        graphes.back().edges.push_back(Edge(graphes.back().end, '~', end));
                        graphes.back().edges.push_back(Edge(start, '~', end));
                        graphes.back().start = start;
                        graphes.back().end   = end;
                        i++;
                    } else {
                        graphes.push_back(parse_re(sub_rexp, state));
                    }
                    sub_rexp.clear();
                }

                // cout << "1 - " << sub_rexp << endl;
            } else {
                sub_rexp += c;
            }
        }
        // cout << "sub_rexp = " << sub_rexp << endl;
        if (sub_rexp.size()) {
            graphes.push_back(parse_re(sub_rexp, state));
            sub_rexp.clear();
        }
    } else if (count(rexp.begin(), rexp.end(), '|')) {  // ! 解析或, 没有括号的存在
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
            merge.edges.push_back(Edge(merge.start, '~', graph.start));
            merge.edges.insert(merge.edges.end(), graph.edges.begin(), graph.edges.end());
            merge.edges.push_back(Edge(graph.end, '~', merge.end));
        }
        return merge;  // ! 处理或的直接返回, 因为和处理简单的并或者括号不一样
    } else {           // 处理普通的没有 | , 也没有括号的情况
        // cout << "rexp = " << rexp << endl;
        for (int i = 0; i < rexp.size(); ++i) {
            string next_rexp;
            next_rexp += rexp[i];
            if (i + 1 < rexp.size() && (rexp[i + 1] == '*' || rexp[i + 1] == '+')) {  // * 对 * 和 + 的解析
                if (rexp[i + 1] == '+')
                    graphes.push_back(parse_re(next_rexp, state));
                int start = state++;
                graphes.push_back(parse_re(next_rexp, state));
                int end = state++;
                graphes.back().edges.push_back(Edge(start, '~', graphes.back().start));
                graphes.back().edges.push_back(Edge(graphes.back().end, '~', graphes.back().start));
                graphes.back().edges.push_back(Edge(graphes.back().end, '~', end));
                graphes.back().edges.push_back(Edge(start, '~', end));
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
        merge.edges.push_back(Edge(graphes[i - 1].end, '~', graphes[i].start));
        merge.edges.insert(merge.edges.end(), graphes[i].edges.begin(), graphes[i].edges.end());
    }
    // for (auto edge: merge.edges) {
    //     cout << edge.from << ' ' << edge.cond << ' ' << edge.to << endl;
    // }
    return merge;
}


void writeNfaData(NFA nfa, string filename) {
    /**
     * 将dfa数据写入到filename文件中.
     * 按照输入的格式, 相当于将输入反了一遍. 
     */
    ofstream write;
    write.open(filename, ios::out | ios::trunc);  // ? 是否设置成没有则创建
    write << nfa.character.size() << endl;
    for (auto c : nfa.character) {
        write << c << ' ';
    }
    write << endl
          << nfa.start_state << endl;
    for (auto c : nfa.states) {
        write << c << ' ';
    }
    write << endl
          << nfa.start_state << endl
          << nfa.end_state_count << endl;
    for (auto c : nfa.end_states) {
        write << c << ' ';
    }
    write << endl;
    // 转换条件的写入
    vector<string> jumps;
    for (auto s : nfa.states) {
        for (auto m : nfa.transition[s]) {
            for (auto v : m.second) {
                jumps.push_back(to_string(s) + " " + m.first + " " + to_string(v) + "\n");
            }
        }
    }
    write << jumps.size() << endl;
    for (auto s : jumps) {
        write << s;
    }
    cout << "NFA write over!" << endl;
}


void writeDfaData(DFA dfa, string filename) {
    /**
     * 将dfa数据写入到filename文件中.
     * 按照输入的格式, 相当于将输入反了一遍.
     * 和输入有一些差异的是, 由于我在保存dfa的时候, 将起始状态变成了0, 所以这个输出更正规
     */
    ofstream write;
    write.open(filename, ios::out | ios::trunc);  // ? 是否设置成没有则创建
    write << dfa.character.size() << endl;
    for (auto c : dfa.character) {
        write << c << ' ';
    }
    write << endl
          << dfa.state_count << endl;
    for (auto c : dfa.states) {
        write << c << ' ';
    }
    write << endl
          << dfa.start_state << '\n'
          << dfa.end_state_count << endl;
    for (auto c : dfa.end_states) {
        write << c << ' ';
    }
    write << endl;
    // todo: 添加转换条件的写入
    vector<string> jumps;
    for (auto s : dfa.states) {
        for (auto iter : dfa.transition[s]) {
            jumps.push_back(to_string(s) + " " + iter.first + " " + to_string(iter.second) + "\n");
        }
    }
    write << jumps.size() << endl;
    for (auto s : jumps) {
        write << s;
    }
    cout << "DFA write over!" << endl;
}