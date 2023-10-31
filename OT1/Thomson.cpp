#include <iostream>
#include <stack>
#include <vector>

struct State {
    bool is_accept;
    State* next1;
    State* next2;
    State(bool accept = false) : is_accept(accept), next1(nullptr), next2(nullptr) {}
};

struct Fragment {
    State* start;
    State* end;
    Fragment(State* s, State* e) : start(s), end(e) {}
};

Fragment ThompsonConstruct(char c) {
    State* s1 = new State();
    State* s2 = new State(true);

    if (c == '.') {  // 仅处理点（连接）操作符作为示例
        s1->next1 = s2;
    } else {  // 处理基本字符
        s1->is_accept = true;
        s1->next1 = s2;
    }

    return Fragment(s1, s2);
}

int main() {
    std::string regex;
    std::cout << "Enter regular expression (only supports '.' and basic characters): ";
    std::cin >> regex;

    std::stack<Fragment> fragments;

    for (char c : regex) {
        fragments.push(ThompsonConstruct(c));
    }

    Fragment nfa = fragments.top();

    // 示例输出
    std::cout << "NFA Start State: " << nfa.start << std::endl;
    std::cout << "NFA End State: " << nfa.end << std::endl;

    return 0;
}
