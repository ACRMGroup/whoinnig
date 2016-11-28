INCLUDES  = menu.tt header.tt footer.tt \
            generated_latest.tt generated_previous.tt  
CATDOC    = GenerateFASTA/share/bin/catdoc


all : index.html $(CATDOC)

index.html : index.tt $(INCLUDES)
	tpage $< > $@


$(CATDOC) : 
	./GenerateFASTA/buildcatdoc.sh

clean :
	\rm -f  index.html
	\rm -rf GenerateFASTA/packages/catdoc-[%catdocVersion%]
	\rm -rf GenerateFASTA/share
