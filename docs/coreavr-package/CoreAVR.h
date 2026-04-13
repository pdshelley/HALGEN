#define cpuFrequency F_CPU

#include <stdint.h>

static inline uint8_t _volatileRegisterReadUInt8(uintptr_t address) {
  volatile uint8_t *ptr = (volatile uint8_t *)address;
  return *ptr;
}

static inline void _volatileRegisterWriteUInt8(uintptr_t address, uint8_t value) {
  volatile uint8_t *ptr = (volatile uint8_t *)address;
  *ptr = value;
}

static inline uint16_t _volatileRegisterReadUInt16(uintptr_t address) {
  volatile uint16_t *ptr = (volatile uint16_t *)address;
  return *ptr;
}

static inline void _volatileRegisterWriteUInt16(uintptr_t address, uint16_t value) {
  volatile uint16_t *ptr = (volatile uint16_t *)address;
  *ptr = value;
}

static inline void _noOpperation() {
    asm volatile("nop");
}

static inline void _sei() {
    asm volatile("sei");
}

static inline void _cli() {
    asm volatile("cli");
}
