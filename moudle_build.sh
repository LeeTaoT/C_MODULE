#!/bin/bash
ALL_C_SOURCE=$(find *.c);
# echo $ALL_C_SOURCE;
# DEF_MODULE="#define[[:space:]]*MODULE[(][[:space:]]*[a-zA-Z_]\+[a-zA-Z_0-9]*[[:space:]]*[)]";
DEF_MODULE="#define[ ]*MODULE[(].*[)]";
#MAIN_DEFINE="[[:alnum:]]*[[:space:]]*main[(][...]*[)]";
MAIN_DEFINE="[a-zA-Z_]\+[a-zA-Z_0-9]*[ ]*main[(].*[)]";
MAIN_MODULE_SOURCE="";
MODULE_CFG_FILE="module_cfg.c";
MODULE_TEMPLE="#define[ ]*MODULE_TEMPLE"
MODULE_CFG_DECLARE="module cfg declare"
MODULE_CFG_ARRAY="module cfg array"

function MODULE_CODE()
{


  echo "#include \"base_type.h\" " >  $MODULE_CFG_FILE
  echo "#define  MODULE_TEMPLE "     >> $MODULE_CFG_FILE
  echo                               >> $MODULE_CFG_FILE
  echo                               >> $MODULE_CFG_FILE
  echo "//extern stask g_XXXstask ;"   >> $MODULE_CFG_FILE
  echo "//$MODULE_CFG_DECLARE"            >> $MODULE_CFG_FILE
  echo                               >> $MODULE_CFG_FILE
  echo "stModuleCfg g_ModuleCfg[] = { " >> $MODULE_CFG_FILE
  echo                                                          >> $MODULE_CFG_FILE
  echo "//  { .pstask = &g_XXXstask , .bNeedRun = BOOL_TRUE },"   >> $MODULE_CFG_FILE
  echo "//  $MODULE_CFG_ARRAY" >> $MODULE_CFG_FILE
  echo  >> $MODULE_CFG_FILE
  echo  >> $MODULE_CFG_FILE
  echo "};" >> $MODULE_CFG_FILE
  echo  >> $MODULE_CFG_FILE
  echo  >> $MODULE_CFG_FILE
  echo  "Uint32 gModuleCfgNum = sizeof(g_ModuleCfg)/sizeof(stModuleCfg);" >> $MODULE_CFG_FILE
  echo  >> $MODULE_CFG_FILE
  echo  >> $MODULE_CFG_FILE

}

function INSERT_MODULE_CODE()
{

  if [ ! -f $MODULE_CFG_FILE ]; then
    touch $MODULE_CFG_FILE;
  fi

  if [ -n  "$(grep "$MODULE_TEMPLE" $MODULE_CFG_FILE)" ]; then
    echo "temple exist";
  else
    echo "genrate temple";
    MODULE_CODE;
  fi

  VAR=$(echo "$2"   | sed 's/#define[ ]*MODULE[(]\(.*\)[)]/\1/');
  VAR=$(echo "$VAR" | sed 's/[[:space:]]//g');

  APPEND_ARRAY="    { .pstask = &$VAR , .bNeedRun = BOOL_TRUE },"; 

  APPEND_DECLARE="extern stask $VAR ;" ;

  VAR_EXIST=$(grep -w  "$APPEND_DECLARE" $MODULE_CFG_FILE);

  if  [ -z "$VAR_EXIST" ] ; then
    
    echo "inster $VAR into $MODULE_CFG_FILE";
    
    sed -i "/$MODULE_CFG_DECLARE/a\\$APPEND_DECLARE" $MODULE_CFG_FILE;
    
    sed -i "/$MODULE_CFG_ARRAY/a\\$APPEND_ARRAY" $MODULE_CFG_FILE;

  else

    echo "$VAR exist";

  fi



}

for C_SOURCE in $ALL_C_SOURCE ; do

 # MAIN_MODULE=$(cat $C_SOURCE | grep "$MAIN_DEFINE");

 if [ -n "$(cat $C_SOURCE | grep "$MAIN_DEFINE")" ]; then
  MAIN_MODULE_SOURCE="$C_SOURCE";
  echo "main module in $MAIN_MODULE_SOURCE";
 fi


 MODULE=$(cat $C_SOURCE | grep "$DEF_MODULE");

 if [ -n "$MODULE" ] ; then
  # echo $C_SOURCE;
  # echo $MODULE;
  INSERT_MODULE_CODE "${C_SOURCE}" "${MODULE}";
 fi

 #echo $C_SOURCE;

done

