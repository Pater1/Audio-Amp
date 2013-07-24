/////////////////////////////////////////////////////////////////////////////////////pocket amp/////////
/*//////////////////////////////////////////////////

started:		5/2/13
finished:		5/3/13
desighner:	Patrick R. Conner
copyright:	N/A


max print size: 180
*/


/////////////////////////////////////////////////////////////////////////////////////perameters/////////
////////////////////////////////////////////////////

include<style_modules.scad>

debug = 1;

width = 0;

amp_slot = 35;
batt_slot = 27.5;

amp_length = 70;
amp_width = 50;
amp_height = 30;

speaker_box_size = 130;

wall_thickness = 5;

batt_width = 35;

audio_in_place = [-1,amp_width/4*3.5,amp_height/1.5-3];
audio_out_place = [amp_length+wall_thickness*2+1,amp_width/2+wall_thickness,amp_height/1.5-3];

pot_place = [-1,(amp_width/4*3.5)/2,amp_height/1.5-3];

male_port_place = [amp_length-wall_thickness*4,0,amp_height/3];

female_port_place = [amp_length-wall_thickness*4,0,amp_height/3];

nub_place = [10,0,amp_height/2];

nub_hole_place = [10-.5,0,amp_height/2-1];
nub_hole_scale = 1.2;

switch_place = [-2,batt_width-4,amp_height/4];


light_place_Y = batt_width-(batt_width/10);
light_place_Z = amp_height-(amp_height/3);

$fn = 20;

slot = 1;

lid_surface = "checker"; // checker, lattice

checker_size 		= 5; 	// half distance from tip to tip at largest width of checker.  4, 5, 10 Look good so far
checker_max_depth 	= 0.5; 	// thickness of thinnest point in lid due to checkering

lattice_width = 3;
lattice_length = 7;

square_loop_width = 2;
square_loop_length = 7;

///////////////////////////////////////////////////////////////////////////////////module_notes/////////
/*//////////////////////////////////////////////////
rendered{
	pocket{
		square_lid(width, slot)
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
////////////////////////////////////////////////////
////////////////////////////renders/////////////////////////////////////////////////////////////////////

//box

box(amp_length,amp_width,amp_height);//makes box, input width value


//lid
translate([-85,0,0])
		square_lid(amp_width,amp_length,1,lid_surface = "lattice"); //makes lid, input width value and slot value




translate([0,-60,0]){
	box(amp_length,batt_width,amp_height);//makes box, input width value
	translate([-85,0,0])
			square_lid(batt_width,amp_length,1,lid_surface="square_loop");
}

	*speaker_box();

/////////////////////////////////////////////////////////////////////////////////////modules////////////////////////////////////////////////////////////////

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

module box(length,width,height){
	union(){
		difference(){
			cube([length+wall_thickness*2,width+wall_thickness*2,height+wall_thickness]);
			union(){
				translate([wall_thickness,wall_thickness,wall_thickness])
					cube([length,width,height+5]);
				translate(female_port_place)
					male_port();
				translate([male_port_place[0],width+wall_thickness,male_port_place[2]])
					female_port();
				translate(nub_hole_place)
					scale(nub_hole_scale)
						nub();
			}//union
			if(width == batt_width){
				batt_ports();
				scale([1.01,1.01,1.02])
					translate([0,wall_thickness,amp_height])
						square_lid(batt_width,amp_length,batt_slot, lid_texture = "");
			}
			if(width == amp_width){
				amp_ports();
				scale([1.01,1.01,1.02])
					translate([0,wall_thickness,amp_height])
						square_lid(amp_width,amp_length,batt_slot, lid_texture = "");
			}
		}
		translate([nub_place[0],width+wall_thickness*2,nub_place[2]])
			nub();
		if(width == amp_width){
			translate([13+wall_thickness,wall_thickness*2,0])
				perf_board_pins();
		}
	}
}

module square_lid(width, length, slot, lid_surface){
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
		if(slot){
			translate([10,width/2,wall_thickness/2+.5])
				hull(){
					translate([0,10,0])
						cylinder(wall_thickness/2,wall_thickness/2,wall_thickness/2);
					translate([0,-10,0])
						cylinder(wall_thickness/2,wall_thickness/2,wall_thickness/2);
				}		
		}	
		if(lid_surface == "checker") checker(width,length,slot);
		if(lid_surface == "lattice") lattice(width,length,slot);
		if(lid_surface == "square_loop") square_loop(width,length,slot);//not finished
	}
}

module speaker_box(){
	difference(){
		union(){
			difference(){
				cube([speaker_box_size+wall_thickness*2,speaker_box_size+wall_thickness*2,speaker_box_size/2+wall_thickness]);
				translate([wall_thickness,wall_thickness,wall_thickness])
					cube([speaker_box_size,speaker_box_size,speaker_box_size]);
			}
			cube([amp_length+wall_thickness,amp_width+batt_width+wall_thickness,amp_height+wall_thickness]);
		}
		cube([amp_length,amp_width+batt_width,amp_height]);
	}
}


module audio_in_port(){
	rotate([0,90,0])
		cylinder(13,3.25,3.25);
}

module pot(){
	rotate([0,90,0]){
		cylinder(13,4,4);
		cylinder(3.5,6,6);
	}
	rotate([90,0,0])
		translate([0,3.5,-1.5])
			cube([10,2,3]);
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
		translate([0,0,wall_thickness*2])
			cube([wall_thickness,wall_thickness*1.5,.5]);
		translate([0,0,-wall_thickness/2])
			cube([wall_thickness,1,wall_thickness]);
		}
	}
}

module switch(){
	cube([10,5,16]);
	*translate([0,0,(16-24)/2])
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
			cylinder(30,3,3);
		}
	}
}

module perf_board_pins(){
	translate([2,2,0])
		cylinder(wall_thickness*2,2,2);
	translate([2,2+30+4,0])
		cylinder(wall_thickness*2,2,2);
	translate([2+30+4,2,0])
		cylinder(wall_thickness*2,2,2);
	translate([2+30+4,2+30+4,0])
		cylinder(wall_thickness*2,2,2);
}

module debug(){
	echo("amp_length: ", amp_length);
	
}