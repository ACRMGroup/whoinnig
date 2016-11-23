INCLUDES  = menu.tt header.tt footer.tt lastupdated.tt
SABCMD    = share/bin/sabcmd
IDABCHAIN = GenerateXML/share/bin/idabchain
KABATSEQ  = GenerateXML/share/bin/kabatseq
GETRESOL  = GenerateXML/share/bin/getresol

all : index.html $(SABCMD) $(IDABCHAIN) $(KABATSEQ) $(GETRESOL)

index.html : index.tt $(INCLUDES)
	tpage $< > $@

$(SABCMD) :
	./buildsab.sh

$(IDABCHAIN) :
	./buildidabchain.sh

$(KABATSEQ) :
	./buildkabatseq.sh

$(GETRESOL) :
	./buildgetresol.sh

clean :
	\rm -f  index.html
	\rm -rf share GenerateXML/share
	\rm -rf packages/idabchain_V2.5/ packages/Sablot-1.0.3/ \
		packages/kabatseq_V1.9/ packages/getresol_V0.1/
	\rm -f  sacsdetail.cgi sacssummary.cgi
	\rm -f  GenerateXML/buildantibodyxml.pl  GenerateXML/redosacs.sh \
		GenerateXML/Makefile GenerateXML/antibody.pl
