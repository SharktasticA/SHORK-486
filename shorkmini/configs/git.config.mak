NO_EXPAT = YesPlease
NO_GETTEXT = YesPlease
NO_TCLTK = YesPlease

USE_CURL = YesPlease
USE_OPENSSL = YesPlease
NO_CURL = 
NO_OPENSSL =

CURLDIR = $(PREFIX)/i486-linux-musl
OPENSSLDIR = $(PREFIX)/i486-linux-musl

EXTLIBS += -lcurl -lssl -lcrypto -lz -latomic -lpthread
LIBS += -lcurl -lssl -lcrypto -lz -latomic -lpthread

