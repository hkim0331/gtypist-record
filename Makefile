VERSION = gtypist-2.9.3


install: gtypist
#	cd ${VERSION} && make install	
	
gtypist:
	cd ${VERSION} && make

clean:
	cd ${VERSION} && make clean
	${RM} *~

realclean:
	${RM} -rf ${VERSION}
