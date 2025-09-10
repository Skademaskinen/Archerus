#pragma once

#include <algorithm>
#include <string>
#include <vector>

namespace utils {
    template<typename T, typename F>
    const T& find_element(const std::vector<T>& elements, F find_function);

    template<typename T, typename F>
    std::vector<T> order_elements(const std::vector<T>& elements, F comparator);
    template<typename T, typename F>
    std::string concat_elements(const std::vector<T>& elements, F to_string_func);
}
