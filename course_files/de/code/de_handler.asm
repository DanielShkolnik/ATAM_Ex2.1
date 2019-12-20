.global my_de_handler, my_get_interrupts_counter
.extern what_to_do, old_de_handler, print #TODO: fill externals

.data
counter: .space 8
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
  addq $2, %r8 # rip += 2 bytes
  movq %r8, 8(%rbp) # saves new rip in stack
  movl $-1, %edx # move -1 to the remeinder
  xorq %rax, %rax
  leave
  iretq

old_handler:
  leave
  jmp *old_de_handler

my_get_interrupts_counter:
  xorq %rax, %rax
  movq counter, %rax
  ret
