#ifndef UTIL_H
#define UTIL_H

#include <stddef.h>

#define BLOCK_SIZE 256

#define CHECK_ERROR(BUFF, MSG) \
          if (BUFF == NULL) { \
            perror(MSG); \
            return EXIT_FAILURE; \
          }

enum rconst_type {
  normal,
  decimal_point,
  exponent,
  hex,
  bin,
  error
};

static const char* type_to_str[] = {
  "normal",
  "decimal_point",
  "exponent",
  "hex",
  "bin",
  "error"
};

int str_to_int(char *str);
void str_tolower(char* str);
int str_check_type(char* str);
int char_to_dec(char c, int base);
double str_base_to_double(char* str, double base);
double str_to_double(char* str);
void print_token(int token);

struct string_buffer {
  char* string;
  size_t allocated_size;
};

void print_error(const char* error_msg);
int fix_special_chars_in_buff();


#endif // UTIL_H