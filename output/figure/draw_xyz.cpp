// #include "/besfs5/users/liucheng/analysis/bes3plotstyle.C"
#include "/besfs5/groups/psip/psipgroup/user/liucheng/bes3plotstyle.C"
#include "/besfs5/groups/psip/psipgroup/user/liucheng/myplotstyle.C"
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

void draw_xyz()
{
   

    char filename[200] = "/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/new_low_xyz/output/figure/v1_new_add_obs_cross_section.txt";
    // int row = coutline(filename) - 1;
     int row = coutline(filename);
    int column = 2 ;
    cout<< "row = "<< row <<endl;

    double energy_point[row];
    double cross_section[row];
    double cross_section_error[row];
    
    double ex[row];
    double ey[row];
    memset(ex, 0, sizeof(ex));
    memset(ey, 0, sizeof(ey));

    ifstream input_file1("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/new_low_xyz/output/figure/xyz_add_obs_cross_section.txt");
    // input_file1.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    for(int j = 0; j <row ; j++)
    {
        if(!input_file1.good())
            continue;
        input_file1>>energy_point[j]>>cross_section[j]>>cross_section_error[j];
        cout<<energy_point[j]<<"  "<<cross_section[j]<<"  "<<cross_section_error[j]<<endl;
    }


    //////////////////////////////////
    // double energy_point2[row];
    // double cross_section2[row];
    // double cross_section_error2[row];
    double energy_point2[117];
    double cross_section2[117];
    double cross_section_error2[117];
    ifstream input_file2("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/add_obs_cross_section.txt");
    // input_file2.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    // for(int j = 0; j <row ; j++)
    for(int j = 0; j <117 ; j++)
    {
        if(!input_file2.good())
            continue;
        input_file2>>energy_point2[j]>>cross_section2[j]>>cross_section_error2[j];
        cout<<energy_point2[j]<<"  "<<cross_section2[j]<<"  "<<cross_section_error2[j]<<endl;
    }
    // TGraphErrors section_xx_old(row, energy_point2, cross_section2, ex, cross_section_error2);
    TGraphErrors *section_xx_old = new TGraphErrors(row, energy_point2, cross_section2, ex, cross_section_error2);

    ////////////////////////////////////



    //  //////////////////////////////////
    // // double energy_point3[row];
    // // double cross_section3[row];
    // // double cross_section_error3[row];
    // double energy_point3[117];
    // double cross_section3[117];
    // double cross_section_error3[117];
    // ifstream input_file3("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/new_cross2.txt");
    // // input_file3.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    // // for(int j = 0; j <row ; j++)
    // for(int j = 0; j <117 ; j++)
    // {
    //     if(!input_file3.good())
    //         continue;
    //     input_file3>>energy_point3[j]>>cross_section3[j]>>cross_section_error3[j];
    //     cout<<energy_point3[j]<<"  "<<cross_section3[j]<<"  "<<cross_section_error3[j]<<endl;
    //     cout<<"33333333333333"<<endl;
    // }
    // // TGraphErrors section_xx_old(row, energy_point3, cross_section3, ex, cross_section_error3);
    // TGraphErrors *section_xx_old3 = new TGraphErrors(row, energy_point3, cross_section3, ex, cross_section_error3);

    ////////////////////////////////////


    // TGraphErrors section_xx(row, energy_point, cross_section, ex, cross_section_error);  //- - - -  - -
    TGraphErrors *section_xx = new TGraphErrors(row, energy_point, cross_section, ex, cross_section_error);  

    // TH2F *h_mode = new TH2F("h_mode"," ",100,4.6,5.0,100,4000,6000);
    // TH2F *h_mode = new TH2F("h_mode"," ",100,4.6,5.0,100,3500,6000);
    TH2F *h_mode = new TH2F("h_mode"," ",200,3.7,5.0,1000,0,16000);


    
    TCanvas *c1 = new TCanvas("c1","Graph Draw Options",200,10,1000,800);
    // NameAxes(h_mode, (char*)" #sqrt{s} (GeV) ",(char*)" #sigma_{D^{0}} (pb)");
    // NameAxes(h_mode, (char*)" energy point (GeV) ",(char*)" #sigma_{D^{+}}(pb)");
    // NameAxes(h_mode, (char*)" energy point (GeV) ",(char*)" #sigma_{D^{+}_{s}}(pb)");
    // #font[52]{#sqrt{s}}
    // NameAxes(h_mode, (char*)"#font[12]{#sqrt{s}} (GeV) ",(char*)" #sigma_{D^{0}} + #sigma_{D^{+}} + #sigma_{D^{+}_{s}} (pb)");
    NameAxes(h_mode, (char*)"#sqrt{#font[12]{s}} (GeV) ",(char*)" #sigma(e^{+}e^{-}#rightarrow D^{0}X + D^{+}X + D^{+}_{s}X) (pb)");
    //  NameAxes(h_mode, (char*)"#sqrt{#font[12]{s}} (GeV) ",(char*)" #sigma(e^{+}e^{-}#rightarrow D^{0}D^{+}D^{+}_{s}X) (pb)");

    // h_mode->SetMinimum(0);
    // h_mode->SetMaximum(8000);

    SetStyle();
    h_mode->GetYaxis()->SetNdivisions(505);
    // h_mode->GetXaxis()->SetNdivisions(505);
    h_mode->GetYaxis()->SetTitleOffset(1.5);
    h_mode->GetXaxis()->SetTitleOffset(1.2);
    h_mode->GetXaxis()->SetTitleSize(0.05);
    h_mode->GetYaxis()->SetTitleSize(0.05);
    h_mode->GetYaxis()->SetLabelSize(0.04);
    h_mode->GetXaxis()->SetLabelSize(0.04);




    h_mode->Draw();




    section_xx->SetMarkerColor(4);
    section_xx->SetLineColor(4);
    // section_xx->SetMarkerSize(1.);
    section_xx->SetMarkerSize(0.5);
    section_xx->SetMarkerStyle(8);
    // section_xx.SetLineWidth(2);
    // section_xx.SetLineColor(1);

    section_xx->Draw("P");
    // section_xx.Draw("LCPsame");

    section_xx_old->SetMarkerColor(2);
    section_xx_old->SetLineColor(2);
    // section_xx_old->SetMarkerSize(1.);
    section_xx_old->SetMarkerSize(0.5);
    section_xx_old->SetMarkerStyle(8);
    section_xx_old->Draw("P");

    // section_xx_old3->SetMarkerColor(3);
    // section_xx_old3->SetLineColor(3);
    // // section_xx_old3->SetMarkerSize(1.);
    // section_xx_old3->SetMarkerSize(0.5);
    // section_xx_old3->SetMarkerStyle(8);
    // // section_xx_old3->Draw("P");





    auto legend = new TLegend(0.7,0.65,0.8,0.86,NULL,"brNDC");
	Set_TLegend(legend);
	legend->SetFillStyle(0);
	// legend->SetHeader("The Legend Title","C"); // option "C" allows to center the header
	legend->AddEntry(section_xx,"new_xyz","ep");
	legend->AddEntry(section_xx_old,"old","ep");
    // legend->AddEntry(section_xx_old3,"dressed4","ep");
    legend->Draw();



    c1->SetGridx();
    c1->SetGridy();
    c1->SetTickx();
    c1->SetTicky();

    c1->SetLeftMargin(0.18); 
    c1->SetBottomMargin(0.16);
    //c1->SetRightMargin(0.05);
    // c1->SetTopMargin(0.15);	
    c1->SaveAs("draw_xyz.png");
    // c1->SaveAs("draw_xyz.root");



}
