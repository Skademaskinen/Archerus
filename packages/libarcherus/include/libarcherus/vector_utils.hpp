#pragma once

#include <algorithm>
#include <string>
#include <vector>

namespace utils {
    template<typename T, typename F>
    const T& findElement(const std::vector<T> &elements, F findFunction) {
        for(const auto& element : elements) {
            if (findFunction(element)) {
                return element;
            }
        }
        throw std::exception();
    }
    
    template<typename T, typename F>
    std::vector<T> orderElements(const std::vector<T> &elements, F comparator) {
        std::vector<T> ordered = elements;
        std::sort(ordered.begin(), ordered.end(), comparator);
        return ordered;
    }
    
    template<typename T, typename F>
    std::string concatElements(const std::vector<T> &elements, F toStringFunc) {
        std::string result;
        for (const auto& element : elements) {
            result += toStringFunc(element);
        }
        return result;
    }

    template<typename T>
    std::pair<std::vector<T>, std::vector<T>> split(const std::vector<T>& values, T arg) {
        std::vector<T> first;
        std::vector<T> second;
        bool found = false;
        for(const auto& value : values) {
            if (found) {
                second.push_back(value);
            } else if (value == arg) {
                found = true;
            } else {
                first.push_back(value);
            }
        }
        return { first, second };
    };


}

template<typename T, typename F>
const T& operator*(const std::vector<T>& elements, F findFunction) {
    return utils::findElement(elements, findFunction);
}

template<typename T, typename F>
std::vector<T> operator/(const std::vector<T>& elements, F comparator) {
    return utils::orderElements(elements, comparator);
}

template<typename T, typename F>
std::string operator+(const std::vector<T>& elements, F toStringFunc) {
    return utils::concatElements(elements, toStringFunc);
}

template<typename T = std::string>
std::pair<std::vector<T>, std::vector<T>> operator|(const std::vector<T>& values, T arg) {
    return utils::split(values, arg);
}
