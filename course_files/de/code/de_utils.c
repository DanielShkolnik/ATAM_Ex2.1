#include <asm/desc.h>
void my_store_idt(struct desc_ptr *idtr) {
	//TODO: store current IDTR in memory adress idtr
	asm volatile("sidt (%0)"
	:
	:"r"(idtr) // input
	);
}

void my_load_idt(struct desc_ptr *idtr) {
	//TODO: load data in memory address idtr to IDTR
	asm volatile("lidt (%0);"
			:
			:"r"(idtr) // input
		);

}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
	//TODO: set gate address to addr
	//      gate layout can be found here: https://wiki.osdev.org/Interrupt_Descriptor_Table
	asm volatile("mov %%bx, (%0);"
			"shr $16, %%rbx;"
			"mov %%bx, 6(%0);"
			"shr $16, %%rbx;"
			"movl %%ebx, 8(%0);"
			:
			:"r"(gate), "b"(addr) // input
		);
}

unsigned long my_get_gate_offset(gate_desc *gate) {
	//TODO: get gate address
	unsigned long addr = 0;
	asm volatile("xor %%rbx,%%rbx;"
			 "movl 8(%1), %%ebx;"
			 "sal $16, %%rbx;"
			 "mov 6(%1), %%bx;"
			 "sal $16, %%rbx;"
			 "mov (%1), %%bx;"
			:"=b"(addr) // input
			:"r"(gate) // input
		);
	return addr;
}
