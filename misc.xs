/* A set of general purpose routines to do stuff that doesn't fit anyplace */
/* else. */

#ifdef __cplusplus
extern "C" {
#endif
#include <starlet.h>
#include <descrip.h>
#include <time.h>
  
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif

MODULE = VMS::Misc		PACKAGE = VMS::Misc		
PROTOTYPES: ENABLE

SV *
byte_to_iv(DataConv)
     SV *DataConv;
   PPCODE:
     char *PVPointer;
     char DataToConvert;
     
     PVPointer = SvPV(DataConv, na);
     DataToConvert = PVPointer[0];
     
     XPUSHs(sv_2mortal(newSViv((I32) DataToConvert)));

SV *
word_to_iv(DataConv)
     SV *DataConv;
   PPCODE:
     short *PVPointer;
     short DataToConvert;

     PVPointer = (short *)SvPV(DataConv, na);
     DataToConvert = *PVPointer;
     
     XPUSHs(sv_2mortal(newSViv((I32) DataToConvert)));


SV *
long_to_iv(DataConv)
     SV *DataConv;
   PPCODE:
     long *PVPointer;
     long DataToConvert;

     PVPointer = (long *)SvPV(DataConv, na);
     DataToConvert = *PVPointer;
     
     XPUSHs(sv_2mortal(newSViv((I32) DataToConvert)));

SV *
quad_to_date(DataConv)
     SV *DataConv;
   PPCODE:
     char *PVPointer;
     char QuadWordBuffer[8];
     char ConvertedDate[255];
     unsigned int ConvertedDateLen = 255;     
     struct dsc$descriptor_s TimeStringDesc;
     int Status;

     PVPointer = SvPV(DataConv, na);
     Copy(PVPointer, QuadWordBuffer, 8, char);
     Zero(ConvertedDate, 255, char);
     
     /* Fill in the time string descriptor */
     TimeStringDesc.dsc$a_pointer = ConvertedDate;
     TimeStringDesc.dsc$w_length = ConvertedDateLen;
     TimeStringDesc.dsc$b_dtype = DSC$K_DTYPE_T;
     TimeStringDesc.dsc$b_class = DSC$K_CLASS_S;
     
     Status = sys$asctim(NULL, &TimeStringDesc, QuadWordBuffer, 0);
     if (Status != SS$_NORMAL) {
       croak("Bogus date!");
     }

     /* Make sure there's a leading zero */
     if (ConvertedDate[0] == ' ') {
       ConvertedDate[0] = '0';
     }
     
     XPUSHs(sv_2mortal(newSVpv(ConvertedDate, 0)));

SV *
date_to_quad(DataConv)
     SV *DataConv;
   PPCODE:
     char *PVPointer;
     char QuadWordBuffer[8];
     char StringDate[255];
     unsigned int DateLen;     
     struct dsc$descriptor_s TimeStringDesc;
     int Status;

     PVPointer = SvPV(DataConv, DateLen);
     Copy(PVPointer, StringDate, DateLen, char);
     
     /* Fill in the time string descriptor */
     TimeStringDesc.dsc$a_pointer = StringDate;
     TimeStringDesc.dsc$w_length = DateLen;
     TimeStringDesc.dsc$b_dtype = DSC$K_DTYPE_T;
     TimeStringDesc.dsc$b_class = DSC$K_CLASS_S;
     
     Status = sys$bintim(&TimeStringDesc, QuadWordBuffer);
     if (Status != SS$_NORMAL) {
       croak("Bogus date!");
     }
     
     XPUSHs(sv_2mortal(newSVpv(QuadWordBuffer, 8)));

SV *
vms_date_to_unix_epoch(DataConv)
     SV *DataConv
   PPCODE:
     char *PVPointer;
     char QuadWordBuffer[8];
     char ConvertedDate[255];
     unsigned int ConvertedDateLen = 255;     
     struct dsc$descriptor_s TimeStringDesc;
     struct tm TimeBuff;
     time_t EpochSecs;
     int Status;

     PVPointer = SvPV(DataConv, na);

     strptime(PVPointer, "%d-%B-%Y %T", &TimeBuff);
     EpochSecs = mktime(&TimeBuff);
     XPUSHs(sv_2mortal(newSViv(EpochSecs)));
