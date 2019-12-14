#include <asm/desc.h>

void my_store_idt(struct desc_ptr *idtr) {
	//TODO: store current IDTR in memory adress idtr
}

void my_load_idt(struct desc_ptr *idtr) {
	//TODO: load data in memory address idtr to IDTR
}

void my_set_gate_offset(gate_desc *gate, unsigned long addr) {
	//TODO: set gate address to addr
	//      gate layout can be found here: https://wiki.osdev.org/Interrupt_Descriptor_Table
}

unsigned long my_get_gate_offset(gate_desc *gate) {
	//TODO: get gate address
	return 0;
}
