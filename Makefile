##################################################
# Makefile of zacOS.asm (x=[1,2,3,4,5])
#
# Update: 08/08/2016
# Make sure NO TAB char at the beginning of if then else
# Make sure TAB char at the beginning of each build rule
##################################################

VER			= V01
ASM			= nasm
ASMFLAGS		= -f bin
IMG			= zacOS.img

MBR			=  zacOS.asm
MBR_SRC		= $(subst V,$(VER),$(MBR))
MBR_BIN		= $(subst .asm,.bin,$(MBR_SRC))

.PHONY : everything

everything : $(MBR_BIN)
 ifneq ($(wildcard $(IMG)), )
 else
		dd if=/dev/zero of=$(IMG) bs=512 count=2880
 endif

		dd if=$(MBR_BIN) of=$(IMG) bs=512 count=1 conv=notrunc

$(MBR_BIN) : $(MBR_SRC)
#	nasm -f bin $< -o $@
	$(ASM) $(ASMFLAGS) $< -o $@

clean :
	rm -f $(MBR_BIN)

reset:
	rm -f $(MBR_BIN) $(IMG)

blankimg:
	dd if=/dev/zero of=$(IMG) bs=512 count=2880

all: zacOS.asm time.asm
	nasm zacOS.asm -o boot.bin -f bin
	nasm time.asm -o boot2.bin -f bin
	dd if=/dev/zero of=zacOS.img bs=512 count=2880
	dd if=boot.bin of=zacOS.img conv=notrunc
	dd if=boot2.bin of=zacOS.img bs=512 count=1 seek=37 conv=notrunc

fancy: zacOS.asm time.asm
	nasm zacOS.asm -o boot.bin -f bin
	nasm time.asm -o boot2.bin -f bin
	dd if=/dev/zero of=zacOS.img bs=1024 count=2880
	dd if=boot.bin of=zacOS.img conv=notrunc
	dd if=boot2.bin of=zacOS.img bs=512 seek=1 conv=notrunc
other: $(IN)
	nasm -f bin $(IN) -o zacOS.bin
	dd if=/dev/zero of=zacOS.img bs=512 count=2880
	dd if=zacOS.bin of=zacOS.img bs=512 count=1 conv=notrunc
	rm zacOS.bin

