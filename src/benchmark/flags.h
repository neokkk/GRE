// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

#include <iostream>
#include <map>
#include <sstream>
#include <string>
#include <vector>

std::map<std::string, std::string> parse_flags(int argc, char **argv) {
  std::map<std::string, std::string> flags;
  for (int i = 1; i < argc; i++) {
    std::string arg(argv[i]);
    size_t equals = arg.find("=");
    size_t dash = arg.find("--");

    if (dash != 0) {
      std::cout << "Bad flag '" << argv[i] << "'. Expected --key=value"
                << std::endl;
      continue;
    }

    std::string key = arg.substr(2, equals - 2);
    std::string val;

    if (equals == std::string::npos) {
      val = "";
    } else {
      val = arg.substr(equals + 1);
    }
    flags[key] = val;
  }
  return flags;
}

std::string get_with_default(const std::map<std::string, std::string> &m,
                             const std::string &key,
                             const std::string &defval) {
  auto it = m.find(key);
  if (it == m.end()) {
    std::cout << key << " = " << defval << std::endl;
    return defval;
  }
  std::cout << key << " = " << it->second << std::endl;
  return it->second;
}

std::string get_required(const std::map<std::string, std::string> &m,
                         const std::string &key) {
  auto it = m.find(key);
  if (it == m.end()) {
    std::cout << "Required flag --" << key << " was not found" << std::endl;
  }
  std::cout << key << " = " << it->second << std::endl;
  return it->second;
}

bool get_boolean_flag(const std::map<std::string, std::string> &m,
                      const std::string &key) {
  auto res = m.find(key) != m.end();
  std::cout << key << " = " << res << std::endl;
  return res;
}

std::vector<std::string> get_comma_separated(
    std::map<std::string, std::string> &m, const std::string &key) {
  std::vector<std::string> vals;
  
  auto it = m.find(key);
  if (it == m.end()) {
    return vals;
  }

  std::istringstream s(m[key]);
  std::string val;
  std::cout << key << " = " << it->second << std::endl;
  
  while (std::getline(s, val, ',')) {
    vals.push_back(val);
  }
  return vals;
}

std::vector<std::pair<std::string, std::string>> get_pair_comma_separated(
    std::map<std::string, std::string> &m, const std::string &key) {
  std::vector<std::pair<std::string, std::string>> vals;

  auto it = m.find(key);
  if (it == m.end()) {
    return vals;
  }

  std::istringstream s(m[key]);
  std::string val;
  std::cout << key << " = " << it->second << std::endl;
  
  while (std::getline(s, val, ',')) {
    std::pair<std::string, std::string> pair;
    std::istringstream ss(val);
    std::string ab;

    std::getline(ss, ab, ':');
    pair.first = ab;
    std::getline(ss, ab, ':');
    pair.second = ab;

    vals.push_back(pair);
  }
  return vals;
}
