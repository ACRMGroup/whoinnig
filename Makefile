INCLUDES  = menu.tt header.tt footer.tt lastupdated.tt

all : index.html 

index.html : index.tt $(INCLUDES)
	tpage $< > $@


clean :
	\rm -f  index.html
