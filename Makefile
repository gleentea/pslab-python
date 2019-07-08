DESTDIR ?=
OS_FAMILY=$(uname)
ifeq ($(OS_FAMILY),Linux)
PREFIX=$(DESTDIR)/usr
else
PREFIX=$(DESTDIR)/usr/local/
endif

all:
	#make -C docs html
	#make -C docs/misc all
	# make in subdirectory PSLab-apps-master if it is there
	[ ! -d PSLab-apps-master ] || make -C PSLab-apps-master $@ DESTDIR=$(DESTDIR)
	python setup.py build

clean:
	rm -rf docs/_*
	# make in subdirectory PSLab-apps-master if it is there
	[ ! -d PSLab-apps-master ] || make -C PSLab-apps-master $@ DESTDIR=$(DESTDIR)
	rm -rf PSL.egg-info build
	find . -name "*~" -o -name "*.pyc" -o -name "__pycache__" | xargs rm -rf

IMAGEDIR=$(PREFIX)/share/doc/pslab-common/images

install:
	# make in subdirectory PSLab-apps-master if it is there
	[ ! -d PSLab-apps-master ] || make -C PSLab-apps-master $@ DESTDIR=$(DESTDIR)
	# install documents
	install -d $(PREFIX)/share/doc/pslab
	#cp -a docs/_build/html $(PREFIX)/share/doc/pslab
	#cp docs/misc/build/*.html $(PREFIX)share/doc/pslab/html
	python setup.py install \
	         --root=/ --prefix=$(PREFIX)
        ifeq (($OS_FAMILY),"Linux")
	    # rules for udev
	    mkdir -p $(DESTDIR)/lib/udev/rules.d
	    install -m 644 99-pslab.rules $(DESTDIR)/lib/udev/rules.d/99-pslab
        endif
	# fix a few permissions
	#find $(PREFIX)/usr/share/pslab/psl_res -name auto.sh -exec chmod -x {} \;
