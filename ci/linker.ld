/* Minimal CI linker script for TM4C123GH6PM-like memory layout */

ENTRY(ResetISR)

MEMORY
{
  FLASH (rx)  : ORIGIN = 0x00000000, LENGTH = 256K
  SRAM  (rwx) : ORIGIN = 0x20000000, LENGTH = 32K
}

SECTIONS
{
  .text :
  {
    KEEP(*(.isr_vector))
    KEEP(*(.intvecs))
    *(.text*)
    *(.rodata*)
    KEEP(*(.init))
    KEEP(*(.fini))
  } > FLASH

  .ARM.exidx :
  {
    *(.ARM.exidx*)
  } > FLASH

  .data : AT (ADDR(.text) + SIZEOF(.text))
  {
    *(.data*)
  } > SRAM

  .bss :
  {
    *(.bss*)
    *(COMMON)
  } > SRAM
}
