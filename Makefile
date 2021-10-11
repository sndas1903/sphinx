SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = sphinx
SOURCEDIR     = .
BUILDDIR      = _build
BREATHEBUILD  = breathe-apidoc
DOXYGENBUILD  = doxygen

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

clean:
	rm -rf $(SOURCEDIR)/doxygen/
	rm -rf $(SOURCEDIR)/_breathe/
	@$(SPHINXBUILD) -M clean "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)


# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
#	@$(DOXYGENBUILD) $(SOURCEDIR)/design/longitudinal_emergency.dox
#	@$(BREATHEBUILD) -o "$(SOURCEDIR)/_breathe" -f -g class -m -p longitudinal_emergency "$(SOURCEDIR)/_doxygen/xml/"
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" '-W' '--keep-going' $(SPHINXOPTS) $(O)
