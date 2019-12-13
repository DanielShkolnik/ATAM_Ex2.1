
# void swap(int* a, int* b) 
swap:
    pushq %rbp # save old %rbp
    movq %rsp, %rbp # change %rbp
    
    # edi = *a, esi = *b
    
    movq (%edi), %r8d # temp1 = a*
    movq (%esi), %r9d # temp2 = b*
    movq %r8d, (%esi) # b* = temp1
    movq %r9d, (%edi) # a* = temp2
    
    leave
    ret
      