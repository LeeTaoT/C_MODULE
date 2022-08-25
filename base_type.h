#ifndef BASE_TYPE_H
#define BASE_TYPE_H



typedef void*             Ptr;
typedef int             Int32;
typedef unsigned int   Uint32;
typedef unsigned char  BOOL_T;

#define SUCCESS      (0)
#define FAIL         (-1)
#define BOOL_TRUE    (1)
#define BOOL_FALSE   (0)
#define VOID      (void)

typedef struct {

  Int32 (*taskInit)();

  Int32 (*taskRun)();

  Int32 (*taskDeInit)();

  BOOL_T isRunning;
  

}stask;


typedef struct {

  stask *pstask;
     
  BOOL_T bNeedRun;

}stModuleCfg;


#endif /* BASE_TYPE_H */
