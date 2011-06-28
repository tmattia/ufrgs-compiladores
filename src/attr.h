#ifndef _ATTR_H_
#define _ATTR_H_

#define int_type 1
#define float_type 2
#define double_type 3
#define char_type 4


struct _attr {
    char* local;
    struct node_tac** code;
    int type;
} _attr;

#endif
