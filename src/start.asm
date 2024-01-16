; TCSc-8000 BIOS

; Pages for Memory-mapped HW
PAGE_TERM = 0x00
PAGE_KEYB = 0x01
PAGE_RCLK = 0x02
PAGE_GPU  = 0x03
PAGE_SPU  = 0x04 ; Pages 0x05 - 0x7F are reserved for future builtin HW
PAGE_EX0  = 0x80 ; PAGE_EX0 - PAGE_EX3 are for generic hardware connected to expansion ports.
PAGE_EX1  = 0x81
PAGE_EX2  = 0x82
PAGE_EX3  = 0x83
                 ; Pages 0x84 - 0xFF are reserved for either additional expansion ports or additional builtin HW (usually user mods)

#bank MEMMAP
mem_mapper: #d8 PAGE_TERM

#bank BIOS_CODE
bios_start: ; We start execution of the system here.
  call bios_term_start
  call bios_show_splash
  .bios_loop: jmp .bios_loop

bios_term_start:
  sto [mem_mapper], PAGE_TERM
  push [r0]
  push [r1]
  sto r0, ' '
  sto r1, 0b11100000
  call bios_term_clscrn
  sto r0, 0b11100000
  call bios_term_sdattr
  sto r0, ' '
  call bios_term_sdchar
  pop r1
  pop r0
  ret

bios_show_splash:
  sto [mem_mapper], PAGE_TERM
  push [r0]
  sto r0, .msg
  call bios_term_print_str
  pop r0
  ret
#bank BIOS_RODATA
.msg: #d "TCSc-8000 BIOS\n"
#bank BIOS_CODE
