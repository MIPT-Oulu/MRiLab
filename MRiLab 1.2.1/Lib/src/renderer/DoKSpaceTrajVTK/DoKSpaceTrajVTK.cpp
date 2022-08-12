/*                                               _______
* _________________________________________     / _____ \      
*     .  .     |---- (OO)|       ___   |       | |     | |     
*    /\  /\    |__ |  || |      /   \  |___    |_|     |_|     
*   /  \/  \   |  \   || |      \___/  |   \   |S|     |N|     
*  /   ||   \  |   \_ || |____|     \  |___/  MRI Simulator    
* _________________________________________                  
* Numerical MRI Simulation Package
* Version 1.2  - https://sourceforge.net/projects/mrilab/
*
* The MRiLab is a numerical MRI simulation package. It has been developed to 
* simulate factors that affect MR signal formation, acquisition and image 
* reconstruction. The simulation package features highly interactive graphic 
* user interface for various simulation purposes. MRiLab provides several 
* toolboxes for MR researchers to analyze RF pulse, design MR sequence, 
* configure multiple transmitting and receiving coils, investigate B0 
* in-homogeneity and object motion sensitivity et.al. The main simulation 
* platform combined with these toolboxes can be applied for customizing 
* various virtual MR experiments which can serve as a prior stage for 
* prototyping and testing new MR technique and application.
*
* Author:
*   Fang Liu <leoliuf@gmail.com>
*   University of Wisconsin-Madison
*   April-6-2014
* _________________________________________________________________________
* Copyright (c) 2011-2014, Fang Liu <leoliuf@gmail.com>
* All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without 
* modification, are permitted provided that the following conditions are 
* met:
* 
*     * Redistributions of source code must retain the above copyright 
*       notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above copyright 
*       notice, this list of conditions and the following disclaimer in 
*       the documentation and/or other materials provided with the distribution
*       
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
* ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
* LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
* SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
* INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
* CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
* ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
* POSSIBILITY OF SUCH DAMAGE.
* _______________________________________________________________________*/

/* Do K-Space Traj */

#include <mex.h>

#include <vtkPoints.h>
#include <vtkCellArray.h>
#include <vtkDoubleArray.h>
#include <vtkPolyData.h>
#include <vtkPointData.h>

#include <vtkCell.h>
#include <vtkCellData.h>
#include <vtkDataSet.h>
#include <vtkDataSetAttributes.h>
#include <vtkProperty.h>
#include <vtkSmartPointer.h>
#include <vtkTubeFilter.h>
#include <vtkSphereSource.h>
#include <vtkGlyph3D.h>

#include <vtkDataSetMapper.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkRenderer.h>
#include <vtkRenderWindow.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkCamera.h>
#include <vtkOrientationMarkerWidget.h>
#include <vtkAxesActor.h>
#include <vtkInteractorStyleTrackballCamera.h>

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
  
  /*****************Get points from input***********************/
  double*          point         = (double*) mxGetData( prhs[0] );
  double*          radius        = (double*) mxGetData( prhs[1] );
  double*          nodeflag      = (double*) mxGetData( prhs[2] );
  int              numofpoints   = (int)(mxGetNumberOfElements( prhs[0] )/3);
 
  unsigned int i;
  vtkSmartPointer<vtkPoints> points = vtkSmartPointer<vtkPoints>::New();
  for(i = 0; i < numofpoints; i++)
    {
    // Storing point coordinates
    points->InsertPoint(i, point[i*3] , point[i*3+1], point[i*3+2]);
    }
 
  vtkSmartPointer<vtkCellArray> lines = vtkSmartPointer<vtkCellArray>::New();
  lines->InsertNextCell(numofpoints);
  for (i = 0; i < numofpoints; i++)
    {
    // Storing line
    lines->InsertCellPoint(i);
    }
 
  vtkSmartPointer<vtkPolyData> polyData = vtkSmartPointer<vtkPolyData>::New();
  polyData->SetPoints(points);
  polyData->SetLines(lines);
   
  // Varying tube radius
  vtkSmartPointer<vtkDoubleArray> tubeRadius = vtkSmartPointer<vtkDoubleArray>::New();
  tubeRadius->SetName("TubeRadius");
  tubeRadius->SetNumberOfTuples(numofpoints);
  for (i=0 ;i < numofpoints ; i++)
    {
    tubeRadius->SetTuple1(i, radius[i]);
    }
  polyData->GetPointData()->AddArray(tubeRadius);
  polyData->GetPointData()->SetActiveScalars("TubeRadius");
 
  // Varying from green to red
  vtkSmartPointer<vtkUnsignedCharArray> colors = vtkSmartPointer<vtkUnsignedCharArray>::New();
  colors->SetName("Colors");
  colors->SetNumberOfComponents(3);
  colors->SetNumberOfTuples(numofpoints);
  for (i = 0; i < numofpoints ;i++)
    {
    colors->InsertTuple3(i,
                       int(255 * i/ (numofpoints - 1)),
                       int(255 * (numofpoints - 1 - i)/(numofpoints - 1)),
                       0 );
    }
  polyData->GetPointData()->AddArray(colors);
  
  // Add tube
  vtkSmartPointer<vtkTubeFilter> tube = vtkSmartPointer<vtkTubeFilter>::New();
  tube->SetInput(polyData);
  tube->SetNumberOfSides(8);
  tube->SetVaryRadiusToVaryRadiusByAbsoluteScalar();
 
  vtkSmartPointer<vtkPolyDataMapper> tubemapper = vtkSmartPointer<vtkPolyDataMapper>::New();
  tubemapper->SetInputConnection(tube->GetOutputPort());
  tubemapper->ScalarVisibilityOn();
  tubemapper->SetScalarModeToUsePointFieldData();
  tubemapper->SelectColorArray("Colors");
  
  // Add actor & renderer
  vtkSmartPointer<vtkActor> tubeactor = vtkSmartPointer<vtkActor>::New();
  tubeactor->SetMapper(tubemapper);
 
  vtkSmartPointer<vtkRenderer> renderer = vtkSmartPointer<vtkRenderer>::New();
  renderer->AddActor(tubeactor);
  renderer->SetBackground(.2, .3, .4);
  
  // Add sphere source
  if ((*nodeflag) == 1)
  {
      vtkSmartPointer<vtkSphereSource> sphere = vtkSmartPointer<vtkSphereSource>::New();
      sphere->SetCenter(0, 0, 0);
      sphere->SetRadius(1.4);
      sphere->SetThetaResolution(5);
      sphere->SetPhiResolution(5);
      
      vtkSmartPointer<vtkGlyph3D> glyph = vtkSmartPointer<vtkGlyph3D>::New();
      glyph->SetInput(polyData);
      glyph->SetSource(sphere->GetOutput());
      glyph->ClampingOff();
      glyph->SetScaleModeToScaleByScalar();
      glyph->SetScaleFactor(1.0);
      
      vtkSmartPointer<vtkPolyDataMapper> nodemapper = vtkSmartPointer<vtkPolyDataMapper>::New();
      nodemapper->SetInputConnection(glyph->GetOutputPort());
      nodemapper->ImmediateModeRenderingOn();
      nodemapper->UseLookupTableScalarRangeOff();
      nodemapper->ScalarVisibilityOn();
      
      vtkSmartPointer<vtkActor> nodeactor = vtkSmartPointer<vtkActor>::New();
      nodeactor->SetMapper(nodemapper);
      
      renderer->AddActor(nodeactor);
  }

  // Make an oblique view
  renderer->GetActiveCamera()->Azimuth(30);
  renderer->GetActiveCamera()->Elevation(30);
  renderer->ResetCamera();
 
  vtkSmartPointer<vtkRenderWindow> renWin = vtkSmartPointer<vtkRenderWindow>::New();
  vtkSmartPointer<vtkRenderWindowInteractor> iren = vtkSmartPointer<vtkRenderWindowInteractor>::New();
 
  iren->SetRenderWindow(renWin);
  renWin->AddRenderer(renderer);
  renWin->SetSize(500, 500);
  renWin->Render();
  
  vtkSmartPointer<vtkAxesActor> axes = vtkSmartPointer<vtkAxesActor>::New();
  axes->SetXAxisLabelText("Kx");
  axes->SetYAxisLabelText("Ky");
  axes->SetZAxisLabelText("Kz");
  
  vtkSmartPointer<vtkOrientationMarkerWidget> widget = vtkSmartPointer<vtkOrientationMarkerWidget>::New();
  widget->SetOutlineColor( 0.9300, 0.5700, 0.1300 );
  widget->SetOrientationMarker( axes );
  widget->SetInteractor( iren );
  widget->SetViewport( 0.0, 0.0, 0.3, 0.3 );
  widget->SetEnabled(1);
  widget->InteractiveOn();
 
  vtkSmartPointer<vtkInteractorStyleTrackballCamera> style = vtkSmartPointer<vtkInteractorStyleTrackballCamera>::New();
  iren->SetInteractorStyle(style);
  iren->Start();
  
  return;
}