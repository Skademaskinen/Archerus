#include <map>
#include <string>
#include <utility>
#include <vector>

#define l(name, ...) [&](const auto& name) { return __VA_ARGS__; }

/* ***** General monad utilities ***** */

template<int start, int end>
const auto range() {
    std::vector<int> result;
    for (auto i = start; i < end; ++i) {
        result.push_back(i);
    }
    return result;
}

auto apply(const auto& x, auto f) {
    return f(x);
}

template<typename T>
const auto split(const std::vector<T>& xs, T v) {
    std::vector<T> first, second;
    bool found = false;
    for (const auto& x : xs) {
        if (!found && x == v) {
            found = true;
            continue;
        }
        if (found) {
            second.push_back(x);
        } else {
            first.push_back(x);
        }
    }
    return std::pair{ first, second };
}

/* ***** Vector monad implementations ***** */

template<typename T, typename F>
auto map(const std::vector<T>& xs, F f) {
    using R = decltype(f(std::declval<T>));
    std::vector<R> result;
    result.reserve(xs.size());
    for (const auto& x : xs) {
        result.push_back(f(x));
    }
    return result;
}

template<typename T, typename F>
std::string concat(const std::vector<T>& xs, F f) {
    std::string result;
    for(const auto& item : xs) {
        result += f(item);
    }
    return result;
}



template<typename T, typename F>
auto bind(const std::vector<T>& xs, F f) {
    using Inner = decltype(f(std::declval<T>));
    using R = typename Inner::value_type;
    std::vector<R> result;
    for (const auto& x : xs) {
        auto inner = f(x);
        result.insert(result.end(), inner.begin(), inner.end());
    }
    return result;
}

/* ***** Map monad implementations ***** */


template<typename K, typename V, typename F>
auto map(const std::map<K, V>& m, F f) {
    using pair_t = std::invoke_result_t<F, const K&, const V&>;
    using K2 = std::decay_t<decltype(std::get<0>(std::declval<pair_t>()))>;
    using V2 = std::decay_t<decltype(std::get<1>(std::declval<pair_t>()))>;

    std::map<K2, V2> result;
    for (const auto& [key, value] : m) {
        auto [key1, value1] = f(key, value);
        result[key1] = value1;
    }
    return result;
}

template<typename K, typename V, typename F>
std::string concat(const std::map<K, V>& m, F f) {
    std::string result;
    for(const auto& [key, value] : m) {
        result.push_back(f(key, value));
    }
    return result;
}

template<typename K, typename V, typename F>
auto bind(const std::map<K, V>& m, F f) {
    using pair_t = std::invoke_result_t<F, const K&, const V&>;
    using K2 = std::decay_t<decltype(std::get<0>(std::declval<pair_t>()))>;
    using V2 = std::decay_t<decltype(std::get<1>(std::declval<pair_t>()))>;
    std::map<K2, V2> result;
    for (const auto& [key, value] : m) {
        auto inner = f(key, value);
        result.insert(result.end(), inner.begin(), inner.end());
    }
    return result;
}



/* ***** Monad operators ***** */

template<typename T, typename F>
auto operator>(const std::vector<T>& xs, F f) {
    return map(xs, f);
}

template<typename K, typename V, typename F>
auto operator>(const std::map<K, V>& xs, F f) {
    return map(xs, f);
}

template<typename T, typename F>
std::string operator<(const T& xs, F f) {
    return concat(xs, f);
}

template<typename T>
auto operator|(const std::vector<T>& xs, T v) {
    return split(xs, v);
}

template<typename T, typename F>
auto operator|(const T& x, F f) {
    return apply(x, f);
}


template<typename T, typename F>
auto operator>>=(const T& xs, F f) {
    return bind(xs, f);
}
