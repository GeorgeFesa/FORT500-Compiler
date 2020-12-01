#include "util.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <ctype.h>

extern char* yytext;
extern struct string_buffer buff;

int str_to_int(char *str) {
  if (!isdigit(str[1])) {
    str[1] = tolower(str[1]);
  }

  if (strncmp(str, "0b", 2) == 0) {
    return (int) strtoll(&str[2], NULL, 2);
  } else if (strncmp(str, "0h", 2) == 0) {
    return (int) strtoll(&str[2], NULL, 16);
  } else {
    return (int) strtoll(str, NULL, 10);
  }
}

void str_tolower(char* str)
{
  for (char* p = str; *p; ++p)
    *p = tolower(*p);
}

int str_check_type(char* str)
{
  str_tolower(str);

  // decimal point
  if (str[0] == '.')
    return decimal_point;

  // normal
  bool is_normal = true;
  for (char* p = str; *p; ++p) {
    if (!isdigit(*p) && *p != '.')
      is_normal = false;
  }
  if (is_normal)
    return normal;

  // hex
  if (strncmp(str, "0h", 2) == 0)
    return hex;

  // bin
  if (strncmp(str, "0b", 2) == 0)
    return bin;

  // exponent
  for (char* p = str; *p; ++p) {
    if (*p == 'e')
      return exponent;
  }

  return error;
}

int char_to_dec(char c, int base)
{
  if ('0' <= c && c <= '9')
    return c - '0';
  else if ('A' <= c && c <= 'F')
    return c - 55;
  else if ('a' <= c && c <= 'f')
    return c - 87;
  else
    return -1;
}

double str_base_to_double(char* str, double base)
{
  double result = 0.0;
  int i = 2;

  for ( ; str[i] != '.'; ++i)
    ;

  int decimal_pos = i;
  // int power = 0;
  double current_base = 1.0;
  --i;
  while (i > 1) {
    int digit = char_to_dec(str[i], base);
    result += digit * current_base; // pow(base, power);
    // ++power;
    current_base *= base;
    --i;
  }

  // int power = -1;
  current_base = 1.0 / base;
  i = decimal_pos + 1;
  while (str[i]) {
    int digit = char_to_dec(str[i], base);
    result += digit * current_base;
    // --power;
    current_base /= base;
    ++i;
  }

  return result;
}

double str_to_double(char* str) 
{
  str_tolower(str);

  int type = str_check_type(str);
  double result = 0.0;

  switch (type) {
  case normal:
    result = atof(str);
    break;
      
  case decimal_point: {
    char* buffer = (char*)malloc((strlen(str) + 1) * sizeof(char));
    buffer[0] = '0';
    strcpy(buffer + 1, str);
    result = atof(buffer);
    free(buffer);
    break;
  }

  case exponent: {
    char* buffer = (char*)malloc(strlen(str) * sizeof(char));

    int i = 0;
    while (str[i] != 'e') {
      buffer[i] = str[i];
      ++i;
    }
    ++i;
    buffer[i] = '\0';

    result += strtod(buffer, NULL);

    int j = 0;
    while (str[i]) {
      buffer[j] = str[i];
      ++i;
      ++j;
    }
    buffer[j] = '\0';

    int exponent = atoi(buffer);
    result *= pow(10, exponent);

    free(buffer);
    break;
  }

  case hex: {
    result = str_base_to_double(str, 16);
    break;
  }

  case bin:
    result = str_base_to_double(str, 2);
    break;

  case error:
    result = -1;
    break;
      
  default:
    return -1;
  }
  
  return result;
}

int fix_special_chars_in_buff() {

  int new_length = strlen(buff.string) + 1 + strlen(yytext);
  if (new_length >= buff.allocated_size) {
    buff.string = (char*)realloc(buff.string, (buff.allocated_size + BLOCK_SIZE) * sizeof(char));
    CHECK_ERROR(buff.string, "Allocating less memory.");
  } else if (new_length < buff.allocated_size / 2) {
    buff.string = (char*)realloc(buff.string, (buff.allocated_size / 2) * sizeof(char));
    CHECK_ERROR(buff.string, "Allocating less memory.");
  }

  if (yytext[0] == '\\') {

    switch (yytext[1]) {
    case 'n':
      strcat(buff.string, "\n");
      break;
    case 't':
      strcat(buff.string, "\t");
      break;
    case 'r':
      strcat(buff.string, "\r");
      break;
    case 'f':
      strcat(buff.string, "\f");
      break;
    case 'b':
      strcat(buff.string, "\b");
      break;
    case 'v':
      strcat(buff.string, "\v");
      break;
    default:
      strcat(buff.string, yytext);
      break;
    }

  } else {
    strcat(buff.string, yytext);
  }

  return 1;
}
