#include<stdio.h>
#include<time.h>
#include<stdlib.h>
#include<string.h>

double get_double(char *str)
{
double value;
    /* First skip non-digit characters */
    /* Special case to handle negative numbers and the `+` sign */
    while (*str && !(isdigit(*str) || ((*str == '-' || *str == '+') && isdigit(*(str + 1)))))
        str++;

    /* The parse to a double */
    return strtod(str, NULL);
 
}
main()

{

int i,j,k,r,u,ct;
char str[80],ext[4],d[2];
char str1[80],ext1[4],d1[2];
char str2[80],ext2[4],d2[2];

char * line = NULL,*s;
char * line1 = NULL,*s1;
char * line2 = NULL,*s2;
    size_t len = 0;
    ssize_t read;
FILE *f,*g1,*g2,*g4,*g3;
double val,val1;

int deg=2;
int mob=2;

for(r=3;r<=12;r++)
{

 sprintf(str,"area_lp");
 sprintf(ext,".txt");
 sprintf(d,"%02d",r);
 strcat(str,d);
 strcat(str,ext);
 //puts(str);
 
 
 
 g1=fopen(str,"rb");
 
 ct=0;
  
  while ((read = getline(&line, &len, g1)) != -1) {
        if(ct==27)
        {
          
            s=line; 
            //puts(s);
            
            val=get_double(s); 
               
            printf("  & %d & %0.3f & ", r, val/196.608);
        }
     
       ct++;
    }
 
 
    fclose(g1);
 
 
 sprintf(str1,"timing_lp");
 sprintf(ext1,".txt");
 sprintf(d1,"%02d",r);
 strcat(str1,d1);
 strcat(str1,ext1);
 //puts(str1);
 
 
 
 g2=fopen(str1,"rb");
 
 ct=0;
  
  while ((read = getline(&line1, &len, g2)) != -1) {
  
        if(strncmp(line1,"  data arrival time",19)==0)
        {
            s1=line1;
            //puts(s);
            
            val=get_double(s1); 
 
               
            printf(" %0.2f & %0.2f & ",val,val*( (1<<(20-r))+(1<<(20-r)) ) /1000);
            break;
        }
        
        
           ct++;
    }
 
 fclose(g2);
 
 
 sprintf(str2,"powercong_lp");
 sprintf(ext2,".txt");
 sprintf(d2,"%02d",r);
 strcat(str2,d2);
 strcat(str2,ext2);
// puts(str);
 
 
 
 g3=fopen(str2,"rb");
 
 ct=0;
  
  while ((read = getline(&line2, &len, g3)) != -1) {
  
        if(strncmp(line2,"Total Dynamic Power",19)==0)
        {
          
            s2=line2;
            //puts(s);
            
            val=get_double(s2); 
            if (line2[34]=='m') val=1000*val;
               
          //  printf("dpower=%f\n",val);
            
        }
     
             if(strncmp(line2,"Cell Leakage Power",18)==0)
        {
          
            s2=line2;
            //puts(s);
            
            val1=get_double(s2); 
            if (line2[34]=='m') val1=1000*val1;   
           // printf("spower=%f\n",val1);
        }
     
     

       ct++;
    }
 
                  printf("  %0.3f & %0.4f \n",(val1+val)/1000 , (val1+val)* ( (1<<(20-r))+(1<<(20-r)) )/1000000000);
                                   // printf("----------------------\n");
    fclose(g3);
 
    //power in mW -- en in uJ--lat in ps --- tot time in ns
}
}
