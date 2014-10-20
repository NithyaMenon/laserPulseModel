/* Include files */

#include "opticalComponentLibrary_sfun.h"
#include "opticalComponentLibrary_sfun_debug_macros.h"
#include "c1_opticalComponentLibrary.h"
#include "c3_opticalComponentLibrary.h"
#include "c5_opticalComponentLibrary.h"
#include "c7_opticalComponentLibrary.h"
#include "c8_opticalComponentLibrary.h"

/* Type Definitions */

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */
uint32_T _opticalComponentLibraryMachineNumber_;

/* Function Declarations */

/* Function Definitions */
void opticalComponentLibrary_initializer(void)
{
}

void opticalComponentLibrary_terminator(void)
{
}

/* SFunction Glue Code */
unsigned int sf_opticalComponentLibrary_method_dispatcher(SimStruct
  *simstructPtr, unsigned int chartFileNumber, const char* specsCksum, int_T
  method, void *data)
{
  if (chartFileNumber==1) {
    c1_opticalComponentLibrary_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==3) {
    c3_opticalComponentLibrary_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==5) {
    c5_opticalComponentLibrary_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==7) {
    c7_opticalComponentLibrary_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  if (chartFileNumber==8) {
    c8_opticalComponentLibrary_method_dispatcher(simstructPtr, method, data);
    return 1;
  }

  return 0;
}

unsigned int sf_opticalComponentLibrary_process_check_sum_call( int nlhs,
  mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[20];
  if (nrhs<1 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the checksum */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"sf_get_check_sum"))
    return 0;
  plhs[0] = mxCreateDoubleMatrix( 1,4,mxREAL);
  if (nrhs>2 && mxIsChar(prhs[1])) {
    mxGetString(prhs[1], commandName,sizeof(commandName)/sizeof(char));
    commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
    if (!strcmp(commandName,"library")) {
      char machineName[100];
      mxGetString(prhs[2], machineName,sizeof(machineName)/sizeof(char));
      machineName[(sizeof(machineName)/sizeof(char)-1)] = '\0';
      if (!strcmp(machineName,"opticalComponentLibrary")) {
        if (nrhs==3) {
          ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(3458651141U);
          ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(3708967860U);
          ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(3126564441U);
          ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(2260057577U);
        } else if (nrhs==4) {
          unsigned int chartFileNumber;
          chartFileNumber = (unsigned int)mxGetScalar(prhs[3]);
          switch (chartFileNumber) {
           case 1:
            {
              extern void sf_c1_opticalComponentLibrary_get_check_sum(mxArray
                *plhs[]);
              sf_c1_opticalComponentLibrary_get_check_sum(plhs);
              break;
            }

           case 3:
            {
              extern void sf_c3_opticalComponentLibrary_get_check_sum(mxArray
                *plhs[]);
              sf_c3_opticalComponentLibrary_get_check_sum(plhs);
              break;
            }

           case 5:
            {
              extern void sf_c5_opticalComponentLibrary_get_check_sum(mxArray
                *plhs[]);
              sf_c5_opticalComponentLibrary_get_check_sum(plhs);
              break;
            }

           case 7:
            {
              extern void sf_c7_opticalComponentLibrary_get_check_sum(mxArray
                *plhs[]);
              sf_c7_opticalComponentLibrary_get_check_sum(plhs);
              break;
            }

           case 8:
            {
              extern void sf_c8_opticalComponentLibrary_get_check_sum(mxArray
                *plhs[]);
              sf_c8_opticalComponentLibrary_get_check_sum(plhs);
              break;
            }

           default:
            ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(0.0);
            ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(0.0);
            ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(0.0);
            ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(0.0);
          }
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  } else {
    return 0;
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_opticalComponentLibrary_autoinheritance_info( int nlhs, mxArray *
  plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[32];
  char aiChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]) )
    return 0;

  /* Possible call to get the autoinheritance_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_autoinheritance_info"))
    return 0;
  mxGetString(prhs[2], aiChksum,sizeof(aiChksum)/sizeof(char));
  aiChksum[(sizeof(aiChksum)/sizeof(char)-1)] = '\0';

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(aiChksum, "ALifbusUqQEEelpUXmzYOG") == 0) {
          extern mxArray *sf_c1_opticalComponentLibrary_get_autoinheritance_info
            (void);
          plhs[0] = sf_c1_opticalComponentLibrary_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 3:
      {
        if (strcmp(aiChksum, "roMHhYbZAl227MZqeURkV") == 0) {
          extern mxArray *sf_c3_opticalComponentLibrary_get_autoinheritance_info
            (void);
          plhs[0] = sf_c3_opticalComponentLibrary_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 5:
      {
        if (strcmp(aiChksum, "wUAZ3s9VS3HFVwNVUSgk3E") == 0) {
          extern mxArray *sf_c5_opticalComponentLibrary_get_autoinheritance_info
            (void);
          plhs[0] = sf_c5_opticalComponentLibrary_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 7:
      {
        if (strcmp(aiChksum, "N86IHGnheZjXFGh4eUq6v") == 0) {
          extern mxArray *sf_c7_opticalComponentLibrary_get_autoinheritance_info
            (void);
          plhs[0] = sf_c7_opticalComponentLibrary_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     case 8:
      {
        if (strcmp(aiChksum, "TcWruCYG8JoVvzFPjAuDCB") == 0) {
          extern mxArray *sf_c8_opticalComponentLibrary_get_autoinheritance_info
            (void);
          plhs[0] = sf_c8_opticalComponentLibrary_get_autoinheritance_info();
          break;
        }

        plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_opticalComponentLibrary_get_eml_resolved_functions_info( int
  nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{

#ifdef MATLAB_MEX_FILE

  char commandName[64];
  if (nrhs<2 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the get_eml_resolved_functions_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_eml_resolved_functions_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        extern const mxArray
          *sf_c1_opticalComponentLibrary_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c1_opticalComponentLibrary_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 3:
      {
        extern const mxArray
          *sf_c3_opticalComponentLibrary_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c3_opticalComponentLibrary_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 5:
      {
        extern const mxArray
          *sf_c5_opticalComponentLibrary_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c5_opticalComponentLibrary_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 7:
      {
        extern const mxArray
          *sf_c7_opticalComponentLibrary_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c7_opticalComponentLibrary_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     case 8:
      {
        extern const mxArray
          *sf_c8_opticalComponentLibrary_get_eml_resolved_functions_info(void);
        mxArray *persistentMxArray = (mxArray *)
          sf_c8_opticalComponentLibrary_get_eml_resolved_functions_info();
        plhs[0] = mxDuplicateArray(persistentMxArray);
        mxDestroyArray(persistentMxArray);
        break;
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;

#else

  return 0;

#endif

}

unsigned int sf_opticalComponentLibrary_third_party_uses_info( int nlhs, mxArray
  * plhs[], int nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the third_party_uses_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_third_party_uses_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(tpChksum, "au0K0aftPXmuxcmVDXBavE") == 0) {
          extern mxArray *sf_c1_opticalComponentLibrary_third_party_uses_info
            (void);
          plhs[0] = sf_c1_opticalComponentLibrary_third_party_uses_info();
          break;
        }
      }

     case 3:
      {
        if (strcmp(tpChksum, "e5z4mbXMvwvpyprXawpJFH") == 0) {
          extern mxArray *sf_c3_opticalComponentLibrary_third_party_uses_info
            (void);
          plhs[0] = sf_c3_opticalComponentLibrary_third_party_uses_info();
          break;
        }
      }

     case 5:
      {
        if (strcmp(tpChksum, "cm2q8ymBdM5VmxvbfmlHf") == 0) {
          extern mxArray *sf_c5_opticalComponentLibrary_third_party_uses_info
            (void);
          plhs[0] = sf_c5_opticalComponentLibrary_third_party_uses_info();
          break;
        }
      }

     case 7:
      {
        if (strcmp(tpChksum, "KgzfgnEYKDWOodhS3v8KOH") == 0) {
          extern mxArray *sf_c7_opticalComponentLibrary_third_party_uses_info
            (void);
          plhs[0] = sf_c7_opticalComponentLibrary_third_party_uses_info();
          break;
        }
      }

     case 8:
      {
        if (strcmp(tpChksum, "8cfcCod3cp2PTyVZBFFGnC") == 0) {
          extern mxArray *sf_c8_opticalComponentLibrary_third_party_uses_info
            (void);
          plhs[0] = sf_c8_opticalComponentLibrary_third_party_uses_info();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

unsigned int sf_opticalComponentLibrary_updateBuildInfo_args_info( int nlhs,
  mxArray * plhs[], int nrhs, const mxArray * prhs[] )
{
  char commandName[64];
  char tpChksum[64];
  if (nrhs<3 || !mxIsChar(prhs[0]))
    return 0;

  /* Possible call to get the updateBuildInfo_args_info */
  mxGetString(prhs[0], commandName,sizeof(commandName)/sizeof(char));
  commandName[(sizeof(commandName)/sizeof(char)-1)] = '\0';
  mxGetString(prhs[2], tpChksum,sizeof(tpChksum)/sizeof(char));
  tpChksum[(sizeof(tpChksum)/sizeof(char)-1)] = '\0';
  if (strcmp(commandName,"get_updateBuildInfo_args_info"))
    return 0;

  {
    unsigned int chartFileNumber;
    chartFileNumber = (unsigned int)mxGetScalar(prhs[1]);
    switch (chartFileNumber) {
     case 1:
      {
        if (strcmp(tpChksum, "au0K0aftPXmuxcmVDXBavE") == 0) {
          extern mxArray
            *sf_c1_opticalComponentLibrary_updateBuildInfo_args_info(void);
          plhs[0] = sf_c1_opticalComponentLibrary_updateBuildInfo_args_info();
          break;
        }
      }

     case 3:
      {
        if (strcmp(tpChksum, "e5z4mbXMvwvpyprXawpJFH") == 0) {
          extern mxArray
            *sf_c3_opticalComponentLibrary_updateBuildInfo_args_info(void);
          plhs[0] = sf_c3_opticalComponentLibrary_updateBuildInfo_args_info();
          break;
        }
      }

     case 5:
      {
        if (strcmp(tpChksum, "cm2q8ymBdM5VmxvbfmlHf") == 0) {
          extern mxArray
            *sf_c5_opticalComponentLibrary_updateBuildInfo_args_info(void);
          plhs[0] = sf_c5_opticalComponentLibrary_updateBuildInfo_args_info();
          break;
        }
      }

     case 7:
      {
        if (strcmp(tpChksum, "KgzfgnEYKDWOodhS3v8KOH") == 0) {
          extern mxArray
            *sf_c7_opticalComponentLibrary_updateBuildInfo_args_info(void);
          plhs[0] = sf_c7_opticalComponentLibrary_updateBuildInfo_args_info();
          break;
        }
      }

     case 8:
      {
        if (strcmp(tpChksum, "8cfcCod3cp2PTyVZBFFGnC") == 0) {
          extern mxArray
            *sf_c8_opticalComponentLibrary_updateBuildInfo_args_info(void);
          plhs[0] = sf_c8_opticalComponentLibrary_updateBuildInfo_args_info();
          break;
        }
      }

     default:
      plhs[0] = mxCreateDoubleMatrix(0,0,mxREAL);
    }
  }

  return 1;
}

void opticalComponentLibrary_debug_initialize(struct SfDebugInstanceStruct*
  debugInstance)
{
  _opticalComponentLibraryMachineNumber_ = sf_debug_initialize_machine
    (debugInstance,"opticalComponentLibrary","sfun",1,5,0,0,0);
  sf_debug_set_machine_event_thresholds(debugInstance,
    _opticalComponentLibraryMachineNumber_,0,0);
  sf_debug_set_machine_data_thresholds(debugInstance,
    _opticalComponentLibraryMachineNumber_,0);
}

void opticalComponentLibrary_register_exported_symbols(SimStruct* S)
{
}

static mxArray* sRtwOptimizationInfoStruct= NULL;
mxArray* load_opticalComponentLibrary_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct==NULL) {
    sRtwOptimizationInfoStruct = sf_load_rtw_optimization_info(
      "opticalComponentLibrary", "testNetwork");
    mexMakeArrayPersistent(sRtwOptimizationInfoStruct);
  }

  return(sRtwOptimizationInfoStruct);
}

void unload_opticalComponentLibrary_optimization_info(void)
{
  if (sRtwOptimizationInfoStruct!=NULL) {
    mxDestroyArray(sRtwOptimizationInfoStruct);
    sRtwOptimizationInfoStruct = NULL;
  }
}
