.global _start 

.section .data
junkbuffer: .space 1
inputbuffer: .space 8
outputbuffer: .space 9
read_descroptor: .quad 0
write_descroptor: .quad 0

.bss
.lcomm Arr, 4000000

.text
_start:
	# Initially - argc and argv are loaded to the top of the stack
	# look at libc's _start for more information
	# https://code.woboq.org/userspace/glibc/sysdeps/x86_64/start.S.html
	movq (%rsp), %rax	# save argc in rax
	lea 8(%rsp), %rbx	# save argv in rbx = char**
	
	# Good Luck!
	# Don't forget to exit(0)

movq $Arr, %rdi # int* arr to file_to_array - arg1
movq 8(%rbx), %rsi # argv[1] - input.txt path - arg2
call file_to_array
movq %rax, %r12 # temp = array_length


movq $Arr, %rdi # int* arr to quick_sort - arg1
movq %r12, %rsi #  array_length to quick_sort - arg2
call quick_sort


movq $Arr, %rdi # int* arr to file_to_array - arg1
movq 16(%rbx), %rsi # argv[1] - input.txt path - arg2
movq %r12, %rdx # length of array - arg3
call array_to_file

exit:
mov $60, %rax # sys_exit
xor %rdi, %rdi 
syscall


# int file_to_array(int* array, char* path)
file_to_array:
    pushq %rbp # save old %rbp
    movq %rsp, %rbp # change %rbp
    pushq %rbx # calee save register
    pushq %r12 # calee save register
    pushq %r13 # calee save register
    pushq %r14 # calee save register
    movq %rdi, %r12 # %r12 = int* array
    movq %rsi, %r13 # %r13 = char* path
    
    open_file:
    movq $2, %rax # sys_open
    movq %r13, %rdi # argv[1] - input.txt path
    movq $0, %rsi # open file to read only
    syscall
    
    movq %rax, read_descroptor # save input_descroptor
    
    movq $0, %r14 # i=0
    
    read_file_number:
    movq $0, %rax # sys_read
    movq read_descroptor, %rdi # input_descroptor to read_file
    movq $inputbuffer, %rsi # output of read_file
    movq $8, %rdx # num of bytes to read
    syscall
    
    cmp $8, %rax # checks if number of bytes read is less then 8 
    jl end_file_to_array 
    
    read_file_end_line:
    movq $0, %rax # sys_read
    movq read_descroptor, %rdi # input_descroptor to read_file
    movq $junkbuffer, %rsi # output of read_file
    movq $1, %rdx # num of bytes to read
    syscall
    
    movq $inputbuffer, %rdi # char* to atoi_hex
    call atoi_hex
    
    movl %eax, (%r12,%r14,4) # ARRAY[i]= atoi_hex of line 1
    inc %r14
    jmp read_file_number
    
    end_file_to_array:
    close_input_file:
    movq $3, %rax # sys_close
    movq (read_descroptor), %rdi # input_descroptor to close
    syscall
    
    movq %r14,%rax # return length of Arr
    movq -32(%rbp), %r14 # restore %r14 from stack
    movq -24(%rbp), %r13 # restore %r13 from stack
    movq -16(%rbp), %r12 # restore %r12 from stack
    movq -8(%rbp), %rbx # restore %rbx from stack
    leave # restore %rsp and %rbp
    ret
    
# void file_to_array(int* array, char* path, int length)
array_to_file:
    pushq %rbp # save old %rbp
    movq %rsp, %rbp # change %rbp
    pushq %rbx # calee save register
    pushq %r12 # calee save register
    pushq %r13 # calee save register
    pushq %r14 # calee save register
    pushq %r15 # calee save register
    movq %rdi, %r12 # %r12 = int* array
    movq %rsi, %r13 # %r13 = char* path
    movq %rdx, %r15 # %r15 = length of array

    movq $0,%r14 # i=0
    
    creat_to_write_file:
    movq $85, %rax # sys_creat
    movq %r13, %rdi # argv[2] - output.txt path
    movq $0777, %rsi # read/write/execute flag
    syscall
    
    movq %rax, write_descroptor # save output_descroptor
    
    start_loop:
    movl (%r12,%r14,4), %edi # Arr[i] to itoa_hex
    call itoa_hex
    movq %rax, outputbuffer # outputbuffer= itoa_hex of ARRAY[i]
    
    write_file:
    movq $1, %rax # sys_write
    movq write_descroptor, %rdi # input_descroptor to write_file
    movq outputbuffer, %rsi # string path to write to file
    movq $9, %rdx # num of byte to write
    syscall
    inc %r14 # i++
    cmp %r14, %r15
    jle end_array_to_file
    jmp start_loop
    
    end_array_to_file:
    close_output_file:
    movq $3, %rax # sys_close
    movq (write_descroptor), %rdi # input_descroptor to close
    syscall
    
    movq -40(%rbp), %r15 # restore %r15 from stack
    movq -32(%rbp), %r14 # restore %r14 from stack
    movq -24(%rbp), %r13 # restore %r13 from stack
    movq -16(%rbp), %r12 # restore %r12 from stack
    movq -8(%rbp), %rbx # restore %rbx from stack
    leave # restore %rsp and %rbp
    ret







# void quick_sort(int* array, int length)
quick_sort:
    pushq %rbp # save old %rbp
    movq %rsp, %rbp # change %rbp
    pushq %rbx # calee save register - p
    pushq %r12 # calee save register - array[]
    pushq %r13 # calee save register - array_length
    pushq %r14 # calee save register - b
    pushq %r15 # calee save register - t
    movq %rdi, %r12 # %r12 = int* array
    movq %rsi, %r13 # %r13 = length of array
    
    quick_sort_loop:
    movq $1, %r14 # b=1
    movq %r13, %r15 # t=n
    dec %r15 # t=n-1
    cmp $2, %rsi # check if(n<2)
    jl quick_sort_return # return
    
    xor %rcx, %rcx # rcx=0
    leaq (%r12,%rcx,4), %rdi # &array[0] - swap arg1
    movq %r13, %rax # rax=array_length
    movq $2, %rcx # rcx=2
    xor %rdx, %rdx # rdx=0
    div %rcx # rax=n/2
    leaq (%r12,%rax,4), %rsi # &array[n/2] - swap arg2
    call swap
    xor %rdx, %rdx # rdx=0
    movl (%r12,%rdx,4), %ebx # ebx=array[0]
    
    while: # b<=t
        cmp %r14, %r15 # check if(b<=t)
        jl end_while
        while_t: # t>=b && a[t]>=p
        cmp %r14, %r15 # check if(b<=t)
        jl end_while_t
        movl (%r12,%r15,4), %ecx # ecx = a[t]
        cmp %ebx, %ecx # check if(a[t]>=p)
        jl end_while_t
        dec %r15 # t--
        jmp while_t
        
        end_while_t: 
        while_b:
        cmp %r14, %r15 # check if(b<=t)
        jl end_while_b
        movl (%r12,%r14,4), %ecx # ecx = a[b]
        cmp %ebx, %ecx # check if(a[b]<p)
        jge end_while_b
        inc %r14 # b++
        jmp while_b
        
        end_while_b:
        cmp %r14, %r15 # check if(b<t)
        jle while
        # swap(&a[b++], &a[t--]);
        movq %r14, %rcx # rcx=b
        leaq (%r12,%rcx,4), %rdi # &array[b++] - swap arg1
        movq %r15, %rcx # rcx=t
        leaq (%r12,%rcx,4), %rsi # &array[t--] - swap arg2
        call swap
        inc %r14 # b++
        dec %r15 # t--
        jmp while
        
        
    end_while:
        # swap(&a[0], &a[t]);
        xor %rcx, %rcx # rcx=0
        leaq (%r12,%rcx,4), %rdi # &array[0] - swap arg1
        movq %r15, %rcx # rcx=t
        leaq (%r12,%rcx,4), %rsi # &array[t] - swap arg2
        call swap
    
    # quick_sort(a, t);
    movq %r12, %rdi # int* arr to file_to_array - arg1
    movq %r15, %rsi #  length of array - arg2
    call quick_sort
    
    
    # quick_sort(a + t + 1, n  t - 1);
    leaq 4(%r12,%r15,4), %rdi # a[t+1] to quick_sort - arg1
    xor %rax, %rax # rax = 0
    sub %r15, %rax # rax =-t
    dec %rax # rax = -t-1
    add %r13, %rax # rax = n-t-1
    movq %rax, %rsi #  n-t-1 to quick_sort - arg2
    call quick_sort
    
    
   
    quick_sort_return:
    movq -40(%rbp), %r15 # restore %r15 from stack
    movq -32(%rbp), %r14 # restore %r14 from stack
    movq -24(%rbp), %r13 # restore %r13 from stack
    movq -16(%rbp), %r12 # restore %r12 from stack
    movq -8(%rbp), %rbx # restore %rbx from stack
    leave # restore %rsp and %rbp
    ret
    
    
    
    
    # void swap(int* a, int* b) 
swap:
    pushq %rbp # save old %rbp
    movq %rsp, %rbp # change %rbp
    
    # edi = *a, esi = *b
    
    movl (%edi), %r8d # temp1 = a*
    movl (%esi), %r9d # temp2 = b*
    movl %r8d, (%esi) # b* = temp1
    movl %r9d, (%edi) # a* = temp2
    
    leave
    ret
      
    
    
    
    
    
#
# ***** <DO NOT MODIFY> *****
#
# int atoi_hex(char* c)
atoi_hex:
	push %rbx
	xor %eax, %eax
	movq (%rdi), %rbx
	movzbl %bl, %edi
	orb __atoi_table(%edi), %al
	shr $8, %rbx
	shl $4, %eax
	movzbl %bl, %edi
	orb __atoi_table(%edi), %al
	shr $8, %rbx
	shl $4, %eax
	movzbl %bl, %edi
	orb __atoi_table(%edi), %al
	shr $8, %rbx
	shl $4, %eax
	movzbl %bl, %edi
	orb __atoi_table(%edi), %al
	shr $8, %rbx
	shl $4, %eax
	movzbl %bl, %edi
	orb __atoi_table(%edi), %al
	shr $8, %rbx
	shl $4, %eax
	movzbl %bl, %edi
	orb __atoi_table(%edi), %al
	shr $8, %rbx
	shl $4, %eax
	movzbl %bl, %edi
	orb __atoi_table(%edi), %al
	shr $8, %rbx
	shl $4, %eax
	movzbl %bl, %edi
	orb __atoi_table(%edi), %al
	pop %rbx
	ret

# char* itoa_hex(int i)
itoa_hex:
	push %rbx
	mov %rdi, %rbx
	xor %rax, %rax
	movzbl %bl, %edi
	movw __itoa_table(,%edi,2), %ax
	shr $8, %ebx
	shl $16, %rax
	movzbl %bl, %edi
	movw __itoa_table(,%edi,2), %ax
	shr $8, %ebx
	shl $16, %rax
	movzbl %bl, %edi
	movw __itoa_table(,%edi,2), %ax
	shr $8, %ebx
	shl $16, %rax
	movzbl %bl, %edi
	movw __itoa_table(,%edi,2), %ax
	movq %rax, (__itoa_res)
	movq $__itoa_res, %rax
	pop %rbx
	ret

.data
__atoi_table: .byte -1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,1,2,3,4,5,6,7,8,9,-1,-1,-1,-1,-1,-1,-1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,10,11,12,13,14,15,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
__itoa_table: .ascii "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f404142434445464748494a4b4c4d4e4f505152535455565758595a5b5c5d5e5f606162636465666768696a6b6c6d6e6f707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e8f909192939495969798999a9b9c9d9e9fa0a1a2a3a4a5a6a7a8a9aaabacadaeafb0b1b2b3b4b5b6b7b8b9babbbcbdbebfc0c1c2c3c4c5c6c7c8c9cacbcccdcecfd0d1d2d3d4d5d6d7d8d9dadbdcdddedfe0e1e2e3e4e5e6e7e8e9eaebecedeeeff0f1f2f3f4f5f6f7f8f9fafbfcfdfeff"
__itoa_res: .ascii "00000000\n"
#
# ***** </DO NOT MODIFY> *****
#
