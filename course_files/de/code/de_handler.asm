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
  pushq %rbp
  movq %rsp, %rbp
  call  my_get_interrupts_counter # counter++
  movl %eax,%edi # first param to what_to_do is conter
  call what_to_do # call what_to_do
  movq %rax, %rcx # save output of what_to_do in rcx
  cmp $0,%rax # if what_to_do output is zero
  jne our_handler # if not zero
  leave
  jmp old_de_handler # if zero jump to old handler
our_handler:
  movq %rcx, %rax # move what_to_do output to rax
  movq $-1, %rdx # move -1 to the remeinder
  xor %r8, %r8
  xor %rcx, %rcx
  movq 8(%rbp),%r8 # move rip to r8
  # movq (%rsp), %r8 # move rip to r8
  while_f6_or_f7:
  movb (%r8), %cl # cl=rbp first byte
  cmp $0xf6, %cl # check if f6==cl
  je advance_rip
  cmp $0xf7, %cl # check if f7==cl
  je advance_rip
  inc %r8 # r8+=1 (byte)
  jmp while_f6_or_f7

  advance_rip:
  xor %rax,%rax # reset rax
  add $2, %r8 # rip += 2 bytes
  movq %rax, 8(%rbp) # saves new rip in stack
  leave
  # movq %r8, (%rsp) # saves new rip in stack
  iretq


my_get_interrupts_counter:
  #TODO: implement :)
  pushq %rbp
  movq %rsp, %rbp
  xor %eax, %eax
  movl counter, %eax # eax=counter
  inc %eax # eax++
  movl %eax, counter # counter++
  leave
  ret
