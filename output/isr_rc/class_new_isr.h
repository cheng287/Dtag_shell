#include <string>
#include <vector>

class class_new_isr
{

  public:


   double ECM_threshold = 3.773;    // = 3.773; 
   double GAM_ee        = 0.31e-6;    // e^+e^- Width(GeV)
   double GAM_tot       = 95.e-3;     // Total Width (GeV)
   double M_e           = 0.0005110034;
   double PI            = 3.14159265;
   double Alpha         = 1./137.035982;
   double CC            = 0.389379338E9; // Converion Constant (hbar*c)**2 GeV^2pbarn   
  
   bool   IfBW = 0;
   
   double ECM = 4. ;  
   double MV   = ECM; // Mass
   double ECM2 = ECM*ECM;  // Ecm*Ecm
   double L    = log(ECM2/M_e/M_e);
   double BETA = 2.*Alpha/PI*(L-1);


    double Cross(double S);
    double GEX_tf(double *x,double *par);
    double HARD_tf( double *x,double *par);
    double sigma(double EL, double EU);
    double sigma()
    {   
        double SMU = ECM2;
	      double SML = ECM_threshold*ECM_threshold;
	      
        double UPU = 1.0 - SML/ECM2;
	      double UPL = 1.0 - SMU/ECM2;

        double YUPL = pow(UPL,BETA );
	      double YUPU = pow(UPU,BETA );

	      TF1* func_gex = new TF1("func_gex", this, &class_new_isr::GEX_tf, YUPL, YUPU,0);
	      TF1* func_hard = new TF1("func_hard", this, &class_new_isr::HARD_tf, UPL, UPU,0);
	
	      gROOT->ProcessLine( "gErrorIgnoreLevel = 6001;");
	      gROOT->ProcessLine( "gPrintViaErrorHandler = kTRUE;");
	      double GEX  = func_gex->Integral(YUPL,YUPU);

	      gROOT->ProcessLine( "gErrorIgnoreLevel = 6001;");
	      gROOT->ProcessLine( "gPrintViaErrorHandler = kTRUE;");
	      double HARD = func_hard->Integral(UPL,UPU);

	
        //---------------------------------------
        // constant of soft photon part of F(X,S)
        //---------------------------------------
        //double DELTA = 1 + Alpha/PI*(PI*PI/3.-0.5) + 3./4.*BETA - BETA**2/24.*(L/3.+2*PI*PI-37./4.);
        // double DELTA = 1 + Alpha/PI*(PI*PI/3.-0.5) + 3./4.*BETA + BETA**2*(9./32.-PI*PI/12); // considering production of the real e^+e^- pairs

        double DELTA = 1 + Alpha/PI*(PI*PI/3.-0.5) + 3./4.*BETA + BETA*BETA*(9./32.-PI*PI/12); // considering production of the real e^+e^- pairs


        delete func_gex;
        delete func_hard;

        return GEX*DELTA + HARD;

    }
  


    void updateECMValues() 
    {
        MV   = ECM; // Mass
        ECM2 = ECM*ECM;  // Ecm*Ecm
        L    = log(ECM2/M_e/M_e);
        BETA = 2.*Alpha/PI*(L-1);
    }

   


        
    // double Rc_initial(double s);
    // double Rad2(double s, double x);
    // double interg_cross_section(double s, double min, double step);



  private:

    // double GEX_tf(double *x,double *par);
    // double HARD_tf( double *x,double *par);
   

};


