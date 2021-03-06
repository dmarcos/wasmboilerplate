#if !defined(TYPES_H)

#include <stdint.h>

#define global_variable static
#define internal static

typedef uint8_t uint8;
typedef uint16_t uint16;

typedef uint32_t uint32;
typedef uint64_t uint64;

typedef uint8 u8;
typedef uint8 u08;
typedef uint16 u16;
typedef uint32 u32;
typedef uint64 u64;

#ifdef _MSC_VER
typedef size_t memory_index;
#endif

typedef float real32;
typedef double real64;

typedef int8_t int8;
typedef int16_t int16;
typedef int32_t int32;
typedef int64_t int64;
typedef int32 bool32;

typedef int8 s8;
typedef int8 s08;
typedef int16 s16;
typedef int32 s32;
typedef int64 s64;
typedef bool32 b32;

typedef real32 r32;
typedef real64 r64;

typedef uintptr_t umm;
typedef intptr_t smm;

#define TYPES_H
#endif
