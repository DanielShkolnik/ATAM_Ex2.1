.global _start 

.bss
.lcomm ARRAY, 4000000

.data
inputbuffer: .space 8
outputbuffer: .space 8
read_descroptor: .quad 0
write_descroptor: .quad 0


.text
_start:
	# Initially - argc and argv are loaded to the top of the stack
	# look at libc's _start for more information
	# https://code.woboq.org/userspace/glibc/sysdeps/x86_64/start.S.html
	movq (%rsp), %rax	# save argc in rax
	lea 8(%rsp), %rbx	# save argv in rbx
	
	# Good Luck!
	# Don't forget to exit(0)

open_file:
movq $2, %rax # sys_open
movq 8(%rbx), %rdi # argv[1] - input.txt path
movq O_RDONLY, %rsi # open file to read only
syscall

movq %rax, read_descroptor # save input_descroptor

read_file:
movq $0, %rax # sys_read
movq $read_descroptor, %rdi # input_descroptor to read_file
movq $inputbuffer, %rsi # output of read_file
movq $8, %rdx # num of bytes to read


movq ($inputbuffer), %rdi # char* to atoi_hex
call atoi_hex
movl %eax, ($ARRAY,0,8) # ARRAY[0]= atoi_hex of line 1


movq ($ARRAY,0,8), %rdi # int to itoa_hex
call itoa_hex
movq %rax, ($outputbuffer) # outputbuffer= itoa_hex of ARRAY[0]


creat_to_write_file:
movq $85, %rax # sys_creat
movq 16(%rbx), %rdi # # argv[2] - output.txt path
movq $0777, %rsi # read/write/execute flag
syscall

movq %rax, ($write_descroptor) # save output_descroptor

write_file:
movq $1, %rax # sys_write
movq (write_descroptor), %rdi # input_descroptor to write_file
movq $outputbuffer, %rsi # string path to write to file
movq $8, %rdx # num of byte to write
syscall

close_input_file:
movq $3, %rax # sys_close
movq (read_descroptor), %rdi # input_descroptor to close
syscall


close_output_file:
movq $3, %rax # sys_close
movq (write_descroptor), %rdi # input_descroptor to close
syscall

exit:
mov $60, %rax # sys_exit
xor %rdi, %rdi 
syscall




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
