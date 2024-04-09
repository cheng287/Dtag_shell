#include "/besfs5/users/liucheng/analysis/bes3plotstyle.C"
#include <iostream>
#include <fstream>
#include <iomanip>
#include <vector> 
using namespace std;

//- - - - - - This one ignores blank lines.
int coutline(char *filename)
{
    int line = 0;
    ifstream infile;
    infile.open(filename); 
    
    if(!infile.is_open())
        return 0;
    
    std::string strLine;
    while(getline(infile,strLine))
    {
        if(strLine.empty())
            continue;
        line++;

    }

    infile.close();  
    return line;

}

void draw_mode()
{
   

    char filename[200] = "./obs_cross_section_mode200.txt";
    int row = coutline(filename) - 1;
    int column = 2 ;
    cout<< "row = "<< row <<endl;

    double energy_point[row];
    double cross_section[row];
    double cross_section_error[row];
    
    double ex[row];
    double ey[row];
    memset(ex, 0, sizeof(ex));
    memset(ey, 0, sizeof(ey));

    ifstream input_file1("./obs_cross_section_mode200.txt");
    input_file1.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    for(int j = 0; j <row ; j++)
    {
        if(!input_file1.good())
            continue;
        input_file1>>energy_point[j]>>cross_section[j]>>cross_section_error[j];
        cout<<energy_point[j]<<"  "<<cross_section[j]<<"  "<<cross_section_error[j]<<endl;
    }


    TGraphErrors section_xx(row, energy_point, cross_section, ex, cross_section_error);  //- - - -  - -
    // TSpline3 section_xx(" ", energy_point, cross_section,row,"ble1",0,0);

    TH2F *h_mode = new TH2F("h_mode"," ",100,4.6,5.0,100,800,1500);
    
    TCanvas *c1 = new TCanvas("c1","Graph Draw Options",200,10,1000,800);
    // NameAxes(h_mode, (char*)"#sqrt{s} (GeV)",(char*)" #sigma_{D^{0}} (pb)");
    NameAxes(h_mode, (char*)"#sqrt{s} (GeV)",(char*)"#sigma_{D^{+}} (pb)");
    // NameAxes(h_mode, (char*)" energy point (GeV) ",(char*)" #sigma_{D^{+}_{s}}(pb)");

    // h_mode->SetMinimum(0);
    // h_mode->SetMaximum(8000);

    SetStyle();
    h_mode->GetYaxis()->SetNdivisions(505);
    // h_mode->GetXaxis()->SetNdivisions(505);
    h_mode->GetYaxis()->SetTitleOffset(1.2);
    h_mode->GetXaxis()->SetTitleOffset(1.2);
    h_mode->GetXaxis()->SetTitleSize(0.06);
    h_mode->GetYaxis()->SetTitleSize(0.06);
    h_mode->GetYaxis()->SetLabelSize(0.05);
    h_mode->GetXaxis()->SetLabelSize(0.05);
    h_mode->Draw();




    section_xx.SetMarkerColor(4);
    section_xx->SetLineColor(4);
    section_xx.SetMarkerSize(1.);
    section_xx.SetMarkerStyle(8);
    // section_xx.SetLineWidth(2);
    // section_xx.SetLineColor(1);

    section_xx.Draw("P");
    // section_xx.Draw("LCPsame");

    c1->SetGridx();
    c1->SetGridy();
    c1->SetTickx();
    c1->SetTicky();

    c1->SetLeftMargin(0.15); 
    c1->SetBottomMargin(0.15);
    //c1->SetRightMargin(0.05);
    // c1->SetTopMargin(0.15);	
    c1->SaveAs("mode200.png");



}
