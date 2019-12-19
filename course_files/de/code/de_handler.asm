.global my_de_handler, my_get_interrupts_counter
.extern what_to_do, old_de_handler #TODO: fill externals

.data
#TODO: define your own variables
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
  call  my_get_interrupts_counter # counter++
  movl %eax,%edi # first param to what_to_do is conter
  call what_to_do # call what_to_do
  movq %rax, %rcx # save output of what_to_do in rcx
  cmp $0,%rax # if what_to_do output is zero
  jne our_handler # if not zero
  jmp old_de_handler # if zero jump t old handler
our_handler:
  movq %rcx, %rax # move what_to_do output to rax
  movq $-1, %rdx # move -1 to the remeinder
  movq 8(%rbp),%r8 #
  iretq


my_get_interrupts_counter:
  #TODO: implement :)
  xor %eax, %eax
  movl counter, %eax # eax=counter
  inc %eax # eax++
  movl %eax, counter # counter++
  ret
