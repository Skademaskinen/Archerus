#pragma once

#include <algorithm>
#include <string>
#include <vector>

namespace utils {
    template<typename T, typename F>
    const T& find_element(const std::vector<T>& elements, F find_function) {
        for(const auto& element : elements) {
            if (find_function(element)) {
                return element;
            }
        }
        throw std::exception();
    }

    template<typename T, typename F>
    std::vector<T> order_elements(const std::vector<T>& elements, F comparator) {
        std::vector<T> ordered = elements;
        std::sort(ordered.begin(), ordered.end(), comparator);
        return ordered;
    }
    template<typename T, typename F>
    std::string concat_elements(const std::vector<T>& elements, F to_string_func) {
        std::string result;
        for (const auto& element : elements) {
            result += to_string_func(element);
        }
        return result;
    }
}
