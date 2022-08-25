#include <stdio.h>
#include "base_type.h"

extern stModuleCfg g_ModuleCfg[];
extern Uint32 gModuleCfgNum;

Int32 taskStart(stask *pstask)
{

  Int32 status = SUCCESS;

  if ( NULL != pstask->taskInit )
  {

    status =  pstask->taskInit();
 
    printf("taskInit over return %d\n",status);

   }  

  if ( NULL == pstask->taskRun)
  {
    printf("your need task to run \n");

    return FAIL;
  }

  status = pstask->taskRun();

  printf("taskRun over return %d\n",status);

  if ( NULL != pstask->taskDeInit)
  {
    status = pstask->taskDeInit();

    printf("taskDeInit over return %d\n",status);

  }

  return status;

}

int main()
{
  Int32 status;
  stModuleCfg *pCfg = g_ModuleCfg;

  Uint32 taskNum = gModuleCfgNum; 

  for (Uint32  i = 0 ; i < taskNum ; i++)
  {
    if( BOOL_TRUE == pCfg[i].bNeedRun  )
    {
      
      status =  taskStart(pCfg[i].pstask);

      printf("task[%d] do over return %d \n",i,status);
  
    }
  }

  return 0;
}
