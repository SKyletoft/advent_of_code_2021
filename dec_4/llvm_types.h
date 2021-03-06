#pragma once

#define complex _Complex
#define loop    for (;;)

#ifndef __cplusplus
#include <stdbool.h>
#endif

#ifdef __cplusplus
#include <functional>
#define fn std::function
#endif

#include <stdint.h>
typedef int8_t i8;
typedef int16_t i16;
typedef int32_t i32;
typedef int64_t i64;

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;

typedef u8 byte;

typedef void (*VoidFunction)(void);

typedef size_t usize;
