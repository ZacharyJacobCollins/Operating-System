##################################################
# Makefile of os423V0x.asm (x=[1,2,3,4,5])
# #
# # Update: 08/08/2016
# # Make sure NO TAB char at the beginning of if then else
# # Make sure TAB char at the beginning of each build rule
# ##################################################
 VER			= V01
 ASM			= nasm
 ASMFLAGS		= -f bin
 IMG			= a.img

 MBR			=  os423V.asm
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

 compile: 
	nasm -f bin zacOS.asm -o zacOS.bin
	nasm -f bin timeOS.asm -o timeOS.bin
	dd if=zacOS.bin of=zacOS.img conv=notrunc
	dd if=timeOS.bin of=zacOS.img bs=512 count=1 seek=37 conv=notrunc
		
