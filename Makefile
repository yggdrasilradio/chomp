all: chomp

chomp: chomp.bas
	#lwdecbpp < chomp.bas > /tmp/chomp.bas
	decbpp < chomp.bas > /tmp/chomp.bas
	#sed -i 's/STEP/ STEP/g' /tmp/chomp.bas
ifneq ("$(wildcard /media/share1/COCO/drive3.dsk)", "")
	decb copy -tr /tmp/chomp.bas /media/share1/COCO/drive3.dsk,CHOMP.BAS
endif
	cat /tmp/chomp.bas
	rm -f /tmp/chomp.bas
