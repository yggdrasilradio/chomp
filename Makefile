all: chomp

chomp: chomp.bas
	#lwdecbpp < chomp.bas > /tmp/chomp.bas
	decbpp < chomp.bas > CHOMP.BAS
	#sed -i 's/STEP/ STEP/g' /tmp/chomp.bas
ifneq ("$(wildcard /media/share1/COCO/drive3.dsk)", "")
	decb copy -tr CHOMP.BAS /media/share1/COCO/drive3.dsk,CHOMP.BAS
endif
	cat CHOMP.BAS
