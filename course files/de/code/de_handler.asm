.global my_de_handler, my_get_interrupts_counter
.extern #TODO: fill externals

.data
#TODO: define your own variables

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
<<<<<<< HEAD

  iretq

=======
  
  iretq
  
>>>>>>> ccb1b6ea961d7b2c77f99e96e7aa9640470cd471
my_get_interrupts_counter:
  #TODO: implement :)
  xor %eax, %eax
  ret

