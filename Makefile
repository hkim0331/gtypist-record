VERSION = gtypist-2.9.2

install: gtypist
	install -m 0755 gtypist.sh /edu/bin/gtypist
	install -m 0755 ${VERSION}/src/gtypist /edu/bin/gtypist.raw
	install -m 0755 gtypist_swing.rb /edu/bin/gtypist_swing.rb

gtypist:
	cd ${VERSION} && make

clean:
	cd ${VERSION} && make clean
	${RM} *~ *.bak

realclean:
	${RM} -rf ${VERSION}
