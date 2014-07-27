/* missing micro perl defines */

#ifdef PERL_MICRO

#include <sys/cdefs.h>

extern int execl(const char *name, const char *arg, ...);
extern __noreturn void _exit(int);

#endif
