/////////////////////////////////////////////////////////////////////////////////////pocket amp/////////////////////
/*////////////////////////////////////////////////////////

started:		5/2/13
finished:	5/3/13
desighner:	Patrick R. Conner
copyright:	N/A


max print size: 180
*/

/////////////////////////////////////////////////////////////////////////////////////perameters/////////////////////
//////////////////////////////////////////////////////////
debug = 1;

width = 0;

amp_slot = 35;
batt_slot = 27.5;

amp_length = 70;
amp_width = 50;
amp_height = 30;

speaker_box_size = 125;

wall_thickness = 5;

batt_width = 35;

audio_in_place = [-1,amp_width/4*3.5,amp_height/1.5-3];
audio_out_place = [amp_length+wall_thickness*2+1,amp_width/2+wall_thickness,amp_height/1.5-3];

pot_place = [-1,(amp_width/4*3.5)/2,amp_height/1.5-3];

male_port_place_X = amp_length-wall_thickness*4;
male_port_place_Z = amp_height/3;
female_port_place = [amp_length-wall_thickness*4,0,amp_height/3];

nub_place = [10,width+wall_thickness*2,amp_height/2];
nub_place_X = 10;
nub_place_Z = amp_height/2;
nub_hole_place = [10-.5,0,amp_height/2-1];
nub_hole_scale = 1.2;

switch_place = [-2,batt_width-4,amp_height/4];
switch_place_Y = batt_width-4;
switch_place_Z = amp_height/4;
switch_place_X = -4;

light_place_Y = batt_width-(batt_width/10);
light_place_Z = amp_height-(amp_height/3);

$fn = 10;

lid_surface = "checker"; // checker, lattice

checker_size 		= 5; 	// half distance from tip to tip at largest width of checker.  4, 5, 10 Look good so far
checker_max_depth 	= 0.5; 	// thickness of thinnest point in lid due to checkering

lattice_width = 3;
lattice_length = 7;

///////////////////////////////////////////////////////////////////////////////////module_notes/////////////////////
/*////////////////////////////////////////////////////////
rendered{
	pocket{
		lid(width, slot)
		box_base(width)
	}
	mobile{
		speaker_box
	}
	home{
	}
	etc.{
	}
}

style difference{ //difference from rendered module, optional
	checker(width, slot)
	lattice(width, slot)
}

functional difference{ //difference from rendered module, required
	audio_in_port
	audio_out_port
	pot
	male_port
	female_port
	switch
	nub
	light
}
*/
//////////////////////////////////////////////////////////
////////////////////////////renders/////////////////////////////////////////////////////////////////////////////////

//box

box(amp_length,amp_width,amp_height);//makes box, input width value


//lid
translate([-85,0,0])
		lid(amp_width,amp_length,amp_slot,lid_surface); //makes lid, input width value and slot value



if(debug) debug();
translate([0,-60,0]){
	box(amp_length,batt_width,amp_height);//makes box, input width value
	translate([-85,0,0])
			lid(batt_width,amp_length,batt_slot,lid_surface="lattice");
}

*lattice(batt_width,amp_length);

/////////////////////////////////////////////////////////////////////////////////////modules//////////////////////////////////////////////////////////////////////////////////

module batt_ports(){
	translate(switch_place)
		rotate([90,0,0])
			switch();
		translate([0,light_place_Y,light_place_Z])
			light();
}

module amp_ports(){
	translate(audio_in_place)
		audio_in_port();
	translate(audio_out_place)
		audio_out_port();
	translate(pot_place)
		pot();
}

module box(length,width,Height){
	union(){
		difference(){
			cube([length+wall_thickness*2,width+wall_thickness*2,Height+wall_thickness]);
			union(){
				translate([wall_thickness,wall_thickness,wall_thickness])
					cube([length,width,Height+5]);
				translate(female_port_place)
					male_port();
				translate([male_port_place_X,width+wall_thickness,male_port_place_Z])
					female_port();
				translate(nub_hole_place)
					scale(nub_hole_scale)
						nub();
			}//union
			if(width == batt_width){
				batt_ports();
				scale([1.01,1.01,1.02])
					translate([0,wall_thickness,amp_height])
						lid(batt_width,amp_length,batt_slot, lid_texture = "");
			}
			if(width == amp_width){
				amp_ports();
				scale([1.01,1.01,1.02])
					translate([0,wall_thickness,amp_height])
						lid(amp_width,amp_length,batt_slot, lid_texture = "");
			}
		}
		translate([nub_place_X,width+wall_thickness*2,nub_place_Z])
			nub();
	}
}

module lid(width, length, slot, lid_surface){
	difference(){
		hull(){
			cube([amp_length+wall_thickness,width,wall_thickness]);
			translate([0,-wall_thickness/4,0])
				cube([amp_length+wall_thickness,wall_thickness/4,wall_thickness/4]);
			translate([0,width,0])
				cube([amp_length+wall_thickness,wall_thickness/4,wall_thickness/4]);
			translate([amp_length+wall_thickness,-wall_thickness/4,0])
				cube([wall_thickness/4,width+wall_thickness/2,wall_thickness/4]);
		}
		hull(){
			translate([10,slot,(wall_thickness/2)+1]){
				cylinder(wall_thickness/2,wall_thickness/2,wall_thickness/2);
				translate([0,-20,0])
					cylinder(wall_thickness/2,wall_thickness/2,wall_thickness/2);
		
			}
		}	
		if(lid_surface == "checker") checker(width,length);
		if(lid_surface == "lattice") lattice(width,length);
		if(lid_surface == "square_loop") square_loop(width,length);//not finished
	}
}

module speaker_box(){
	difference(){
		union(){
			difference(){
				hull(){
					sphere(wall_thickness*2);
					translate([speaker_box_size,0,0])
						sphere(wall_thickness*2);
					translate([0,speaker_box_size,0])
						sphere(wall_thickness*2);
					translate([0,0,speaker_box_size/2])
						sphere(wall_thickness*2);
					translate([speaker_box_size,speaker_box_size,0])
						sphere(wall_thickness*2);
					translate([0,speaker_box_size,speaker_box_size/2])
						sphere(wall_thickness*2);
					translate([speaker_box_size,0,speaker_box_size/2])
						sphere(wall_thickness*2);
					translate([speaker_box_size,speaker_box_size,speaker_box_size/2])
						sphere(wall_thickness*2);
				}
			cube([speaker_box_size,speaker_box_size,speaker_box_size+wall_thickness+1]);
			}//difference
			cube([amp_length+wall_thickness*2,amp_width+batt_width+wall_thickness*4,amp_height+wall_thickness*2]);
		}
		translate([-wall_thickness*2,-wall_thickness*2,-wall_thickness*2])
			cube([amp_length+wall_thickness*2,amp_width+batt_width+wall_thickness*4,amp_height+wall_thickness*2]);
		translate([male_place_X-wall_thickness*2,amp_width+batt_width+wall_thickness*2,male_place_Z-wall_thickness*2])
			male_port();
		translate([nub_hole_place_X-wall_thickness*2,amp_width+batt_width+wall_thickness*2,nub_hole_place_Z-wall_thickness*2])
			scale(nub_hole_scale)
				nub();
	}
}


module audio_in_port(){
	rotate([0,90,0])
		cylinder(13,3.25,3.25);
}

module pot(){
	rotate([0,90,0])
		cylinder(13,3.5,3.5);
}

module audio_out_port(){
	rotate([0,90,0]){
		translate([0,0,-2-5])
			cylinder(wall_thickness+2,3.25,3.25);
		translate([0,0,-wall_thickness])
			cylinder(5,5,8);
	}
}

module male_port(){
	translate([.5,-1,0])
		cube([19,30,10]);
	*translate([-(31-20)/2,0,-(13-10)/2])
		cube([31,1,13]);
	translate([-3,wall_thickness+1,5])
		rotate([90,0,0])
			cylinder(wall_thickness+2,1.5,3);
	translate([21+1.5,wall_thickness+1,5])
		rotate([90,0,0])
			cylinder(wall_thickness+2,1.5,3);
}

module female_port(){
	translate([0,-1,0])
		cube([20,30,10]);
	translate([-(31-20)/2,wall_thickness-1,-(13-10)/2])
		cube([31,1,13]);
	translate([-3,30,5])
		rotate([90,0,0])
			cylinder(40,1.5,1.5);
	translate([21+1.5,30,5])
		rotate([90,0,0])
			cylinder(40,1.5,1.5);
}


module nub(){
	translate([0,-1,0]){
		hull(){
		#translate([0,0,wall_thickness*2])
			cube([wall_thickness,wall_thickness*1.5,.5]);
		translate([0,0,-wall_thickness/2])
			cube([wall_thickness,1,wall_thickness]);
		}
	}
}

module switch(){
	cube([10,5,16]);
	translate([0,0,(16-24)/2])
		cube([5,5,24]);
	translate([0,2.5,18])
		rotate([0,90,0])
			cylinder(40,1.5,1.5);
	translate([0,2.5,-2])
		rotate([0,90,0])
			cylinder(40,1.5,1.5);
}

module light(){
	translate([-5,0,0]){
		rotate([0,90,0]){
			scale([2.5,2.5,15]){
				cylinder([30,5,5]);
			}
		}
	}
}

module checker(width,length){
	xmax = floor((length-wall_thickness)/(checker_size*2));
	ymax = floor((width-(wall_thickness/2))/(checker_size*2));
	//checker_size = floor(amp_length/xmax/2);
	if(debug) echo(xmax, ymax, checker_size*2);
	intersection(){
		translate([0,0,0])
			difference(){
				cube([amp_length+wall_thickness,width,20]);
				translate([10,width/2,0])
					slot_cut();
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



module lattice(width,length){
	offset=sqrt(lattice_length/2)+lattice_width/2;
	point_line_up=sqrt(lattice_length/2)+sqrt(lattice_width/2)+lattice_width+1;
	pattern_width=(offset+point_line_up)*1.25;
	xmax=floor(length/pattern_width);
	ymax=floor(width/pattern_width);

	translate([0,0,3])
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
				translate([11,width/2,-10])
					slot_cut();
			}
		}


	echo("xmax:",xmax, "ymax:",ymax, "offset:", offset, "point_line_up:", point_line_up);
			
}

module square_loop(width,length,slot){
	offset=sqrt(lattice_length/2)+lattice_width/2;
	point_line_up=sqrt(lattice_length/2)+sqrt(lattice_width/2)+lattice_width;
	pattern_width=(offset+point_line_up);
	xmax=floor(length/pattern_width);
	ymax=floor(width/pattern_width);

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

module debug(){
	echo("amp_length: ", amp_length);
	
}