.global my_de_handler, my_get_interrupts_counter
.extern what_to_do, old_de_handler #TODO: fill externals

.data
  counter: .long 0
.text
.align 8, 0x90
my_de_handler:
  #TODO: implement your own divide error handler
  # When calling an interrupt handler, Intel pushes the following to the stack:
  # * SS
  # * RSP
  # * RFLAGS
  # * CS
  # * RIP
  # * (errorcode for several interrupts, but not for divide error)

  pushq %rbp
  movq %rsp, %rbp

  incq (counter)
  movq (counter), %rdi
  call what_to_do # call what_to_do
  movq %rax, %r9 # saves what_to_do return value t r9
  cmp $0, %rax
  je old_handler
  movq 8(%rbp),%r8 # move rip to r8
  # checks rip and inc accordingly to its first byte
  cmpb $0xf7, (%r8)
  je add_2
  cmpb $0xf6, (%r8)
  je add_2
  add_3:
  addq $3, %r8
  jmp end_handler
  add_2:
  addq $2, %r8 # rip += 2 bytes

  end_handler:
  movq %r8, 8(%rbp) # saves new rip in stack
  movl $-1, %edx # move -1 to the remeinder
  movq %r9, %rax # puts quotient to what_to_do output
  leave
  iretq

old_handler:
  leave
  jmp *old_de_handler

my_get_interrupts_counter:
  xorq %rax, %rax
  movq counter, %rax
  ret
