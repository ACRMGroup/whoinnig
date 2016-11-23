INCLUDES  = menu.tt header.tt footer.tt \
            generated_latest.tt generated_previous.tt  

all : index.html 

index.html : index.tt $(INCLUDES)
	tpage $< > $@

clean :
	\rm -f  index.html
