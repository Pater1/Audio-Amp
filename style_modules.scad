///////////////////////////////////////////////////////////////////////////////OpenSCAD/////////////////
/*//////////////////////////////////////////////////

date started:	6/13/2013
date finished:
modeler:			Patrick Conner
copyright:		N/A

*/


//////////////////////////////////////////////////////////////////////////////perameters////////////////////////////////////////////////////////////////////

include<Audio-amp-case.scad>

slot = 1;

checker_size 		= 5; 	// half distance from tip to tip at largest width of checker.  4, 5, 10 Look good so far
checker_max_depth 	= 0.5; 	// thickness of thinnest point in lid due to checkering

lattice_width = 3;
lattice_length = 7;

//////////////////////////////////////////////////////////////////////////////renders///////////////////////////////////////////////////////////////////////





//////////////////////////////////////////////////////////////////////////////modules///////////////////////////////////////////////////////////////////////

module checker(width,length,slot){
	xmax = floor((length-wall_thickness)/(checker_size*2));
	ymax = floor((width-(wall_thickness/2))/(checker_size*2));
	//checker_size = floor(amp_length/xmax/2);
	if(debug) echo(xmax, ymax, checker_size*2);
	intersection(){
		translate([0,0,0])
			difference(){
				cube([amp_length+wall_thickness,width,20]);
				if(slot){
					translate([10,width/2,0])
						slot_cut();
				}
			}
		translate([(amp_length+wall_thickness)-xmax*checker_size*2,(amp_width-wall_thickness)-checker_size*2*ymax,checker_max_depth])
			for (x=[0:xmax]){
				translate([x*checker_size*2-checker_size,0,0])
					for (y=[0:ymax]){
						translate([0,y*checker_size*2,0])	
							rotate(a=[0,0,0])
								cylinder(r1=0,r2=checker_size,h=wall_thickness-checker_max_depth+.01,center = false,$fn=4);
				}
		}
	}
}



module lattice(width,length,slot){
	offset=sqrt(lattice_length/2)+lattice_width/2;
	point_line_up=sqrt(lattice_length/2)+sqrt(lattice_width/2)+lattice_width+1;
	pattern_width=(offset+point_line_up)*1.25;
	xmax=floor(length/pattern_width);
	ymax=floor(width/pattern_width);

	translate([1,0,3])
		intersection(){
			for(x=[0:xmax]){
				for(y=[0:ymax]){
					translate([offset+pattern_width*x,offset+pattern_width*y,0])
						rotate([0,0,45])
							cube([lattice_width,lattice_length,wall_thickness],center=true);
					translate([offset+pattern_width*x,offset+point_line_up+pattern_width*y,0])
						rotate([0,0,45+90])
							cube([lattice_width,lattice_length,wall_thickness],center=true);
					translate([offset+point_line_up+pattern_width*x,offset+pattern_width*y,0])
						rotate([0,0,45+90])
							cube([lattice_width,lattice_length,wall_thickness],center=true);
					translate([offset+point_line_up+pattern_width*x,offset+point_line_up+pattern_width*y,0])
						rotate([0,0,45])
							cube([lattice_width,lattice_length,wall_thickness],center=true);
				}
			}
			difference(){
				translate([0,0,0])
					cube([length+wall_thickness-1,width,10]);
				if(slot){
					translate([11,width/2,-10])
						slot_cut();
				}
			}
		}


	echo("xmax:",xmax, "ymax:",ymax, "offset:", offset, "point_line_up:", point_line_up);
			
}

module square_loop(width,length,slot){
	offset=sqrt(square_loop_length/2)+square_loop_width/2;
	point_line_up=sqrt(square_loop_length/2)+sqrt(square_loop_width/2)+square_loop_width;
	pattern_width=(offset+point_line_up);
	xmax=floor(length/pattern_width);
	ymax=floor(width/pattern_width);

	translate([1,0,3])
		intersection(){
			translate([0,-3,0])
				for(x=[0:xmax]){
					for(y=[0:ymax]){
						translate([offset+pattern_width*x,offset+pattern_width*y,0])
							rotate([0,0,45])
								cube([square_loop_width,square_loop_length,wall_thickness],center=true);
						translate([offset+pattern_width*x,offset+point_line_up+pattern_width*y,0])
							rotate([0,0,45+90])
								cube([square_loop_width,square_loop_length,wall_thickness],center=true);
						translate([offset+point_line_up+pattern_width*x,offset+pattern_width*y,0])
							rotate([0,0,45+90])
								cube([square_loop_width,square_loop_length,wall_thickness],center=true);
						translate([offset+point_line_up+pattern_width*x,offset+point_line_up+pattern_width*y,0])
							rotate([0,0,45])
								cube([square_loop_width,square_loop_length,wall_thickness],center=true);
				}
		}
			difference(){
				translate([0,0,0])
					cube([length+wall_thickness-1,width,10]);
				if(slot){
					translate([11,width/2,-10])
						slot_cut();
				}
			}
	}


	echo("xmax:",xmax, "ymax:",ymax, "offset:", offset, "point_line_up:", point_line_up);
			
}

module slot_cut(){
	hull(){
		translate([0,10,0])
			cylinder(20,wall_thickness,wall_thickness);
		translate([0,-10,0])
			cylinder(20,wall_thickness,wall_thickness);					
		translate([-12,-15,0])
			cube([10,30,20]);
	}
}