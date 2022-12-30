/**
 * @author: Abdulfatah M. Alturshani
 * @cretid: to vivonomicon blog
 *          https://vivonomicon.com/2019/03/30/getting-started-with-bare-metal-esp32-programming/
 *          
 *          aslo to  Sergey Lyubka
 *          https://github.com/cpq/mdk 
*/


/* esp32_technical_reference_manual_en.pdf 1.3.2 */
MEMORY {
  drom   (rw)   : ORIGIN = 0X3ff90000, LENGTH = 64k
  irom   (rwx)  : ORIGIN = 0x40000000, LENGTH = 384k

  cache0 (rwx)  : ORIGIN = 0x40070000, LENGTH = 32k
  cache1 (rwx)  : ORIGIN = 0x40078000, LENGTH = 32k
  iram   (rwx)  : ORIGIN = 0x40080400, LENGTH = 127k  /* First 1k is vectors */
  dram   (rw)   : ORIGIN = 0x3ffb0000, LENGTH = 320k

  dflash (rw)   : ORIGIN = 0X3f400000, LENGTH = 1024k
  psram  (rw)   : ORIGIN = 0X3f800000, LENGTH = 1024k
  iflash (rwx)  : ORIGIN = 0X400c2000, LENGTH = 11512k
}

ENTRY(_reset)

SECTIONS {
  /* The program code and other data goes into Instruction RAM */
  text :
  {
    . = ALIGN(16);
    KEEP(*(.entry.text))
    *(.text)
    *(.text*)
    KEEP (*(.init))
    KEEP (*(.fini))
    *(.rodata)
    *(.rodata*)

    . = ALIGN(4);
    _etext = .;
  } >iram

  /* Initialized data goes into Data RAM */
  _sidata = .;
  .data : AT(_sidata)
  {
    . = ALIGN(4);
    _sdata = .;
    *(.data)
    *(.data*)

    . = ALIGN(4);
    _edata = .;
  } >dram

  /* Uninitialized data also goes into Data RAM */
  .bss :
  {
    . = ALIGN(4);
    _sbss = .;
    *(.bss)
    *(.bss*)
    *(COMMON)

    . = ALIGN(4);
    _ebss = .;
  } >dram

  . = ALIGN(4);
  PROVIDE ( end = . );
  PROVIDE ( _end = . );
}