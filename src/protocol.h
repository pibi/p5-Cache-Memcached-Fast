#ifndef PROTOCOL_H
#define PROTOCOL_H 1

#include <stddef.h>


enum {
  MEMCACHED_CLOSED,
  MEMCACHED_UNKNOWN,
  MEMCACHED_ERROR,
  MEMCACHED_FAILED,
  MEMCACHED_SUCCESS
};


extern
int
client_set(int fd, const char *key, size_t key_len,
           unsigned int flags, unsigned int exptime, size_t val_size,
           const void *val);


#endif /* ! PROTOCOL_H */
