/* Boolfuck (reference implementation) */

/*
   10th anniversary edition
   by Sam Hughes (the evil American one)
   boof@samuelhughes.com
   http://samuelhughes.com/boof/
*/

/* Copyright (c) 2015 Sam Hughes

   This software is provided 'as-is', without any express or implied
   warranty. In no event will the authors be held liable for any
   damages arising from the use of this software.

   Permission is granted to anyone to use this software for any
   purpose, including commercial applications, and to alter it and
   redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you
    must not claim that you wrote the original software. If you use
    this software in a product, an acknowledgment in the product
    documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and
    must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source
    distribution.
*/

#include <bitset>
#include <cstdint>
#include <deque>
#include <stdexcept>
#include <fstream>
#include <iostream>
#include <limits>
#include <stack>
#include <string>
#include <vector>

void run(const std::string& program, std::istream& in, std::ostream& out);

int main(int argc, char **argv) {
  if (argc != 2) {
    std::cerr << "Use one argument.  Not wimping out, are you?\n";
    return 1;
  }

  std::ifstream fin(argv[1]);
  if (!fin) {
    std::cerr << "Error opening file.  Did you even make a file?\n";
    return 1;
  }

  std::string program((std::istreambuf_iterator<char>(fin)), std::istreambuf_iterator<char>());
  run(program, std::cin, std::cout);
  return 0;
}

struct bracket_info {
  size_t p_span;
  size_t b_span;
};

bool simplify(const std::string& program, std::vector<bracket_info> *b_out, std::string *p_out) {
  std::vector<bracket_info> b;
  std::stack<std::pair<size_t, size_t> > st;
  std::string p;
  for (char c : program) {
    if (c == '[') {
      st.push({p.size(), b.size()});
      b.push_back({0, 0});
      p.push_back(c);
    } else if (c == ']') {
      if (st.empty()) {
        return false;
      }
      size_t p_span = p.size() - st.top().first;
      size_t b_span = b.size() - st.top().second;
      b[st.top().second] = {p_span, b_span};
      b.push_back({p_span, b_span});
      st.pop();
      p.push_back(c);
    } else if (c == '<' || c == '>' || c == '+' || c == ',' || c == ';') {
      p.push_back(c);
    }
  }
  if (!st.empty()) {
    return false;
  }
  *b_out = std::move(b);
  *p_out = std::move(p);
  return true;
}

void run(const std::string& program, std::istream& in, std::ostream& out) {
  // memory[cursor / 32] always has a value.
  std::deque<std::bitset<32> > memory = { 0 };
  size_t cursor = 0;

  std::vector<bracket_info> b_tmp;
  std::string p_tmp;
  if (!simplify(program, &b_tmp, &p_tmp)) {
    std::cerr << "You have unbalanced braces, skxawng!\n";
    return;
  }

  const std::string p = std::move(p_tmp);
  const std::vector<bracket_info> b = std::move(b_tmp);

  uint8_t input_buf = 0;
  size_t input_buf_size = 0;
  uint8_t output_buf = 0;
  size_t output_buf_size = 0;
  bool input_failed = false;


  size_t ip = 0;
  size_t bp = 0;
  while (ip < p.size()) {
    switch (p[ip]) {
    case '<': {
      if (cursor == 0) {
        memory.push_front(0);
        cursor = 31;
      } else {
        cursor--;
      }
      ip++;
    } break;
    case '>': {
      if (cursor == std::numeric_limits<size_t>::max()) {
        throw std::runtime_error("out of memory");
      }
      cursor++;
      if (cursor == memory.size() * 32) {
        memory.push_back(0);
      }
      ip++;
    } break;
    case '+': {
      memory[cursor / 32].flip(cursor % 32);
      ip++;
    } break;
    case '[': {
      if (memory[cursor / 32][cursor % 32]) {
        ip++;
        bp++;
      } else {
        ip += b[bp].p_span + 1;
        bp += b[bp].b_span + 1;
      }
    } break;
    case ']': {
      ip -= b[bp].p_span;
      bp -= b[bp].b_span;
    } break;
    case ',': {
      if (input_buf_size == 0) {
        if (!input_failed) {
          char tmp;
          if (!in.get(tmp)) {
            input_failed = true;
          } else {
            input_buf = tmp;
          }
        }
        // input_buf is intentially left zero after input fails.
        input_buf_size = 8;
      }
      uint32_t bit = (input_buf & 1);
      input_buf >>= 1;
      input_buf_size--;
      memory[cursor / 32].set(cursor % 32, bit == 1);
      ip++;
    } break;
    case ';': {
      uint8_t bit = memory[cursor / 32][cursor % 32];
      output_buf |= (bit << output_buf_size);
      output_buf_size++;
      if (output_buf_size == 8) {
        out.put(output_buf);
        output_buf = 0;
        output_buf_size = 0;
      }
      ip++;
    } break;
    }
  }

  if (output_buf_size != 0) {
    out.put(output_buf);
  }
}
