// card size:
//   95mm x 60mm
// deck heights:
//   2x 24mm
//   6x 16mm
//   2x 6mm
//   1x 8mm
// max box height:
//   65mm

// units: mm
WALL_THICKNESS = 2;
CARD_W = 60;
CARD_H = 95;

BOX_HEIGHT_RATIO = 0.675;
CUTOUT_DIAMETER = CARD_W * 1;
CUTOUT_OFFSET = CARD_W * 1/8;

FATIGUE_THICKNESS = 24;
CYCLIST_THICKNESS = 16;
// BOT_THICKNESS = 6;
// HELPER_THICKNESS = 6;
// MAP_THICKNESS = 8;
OTHERS_THICKNESS = 8;

DECK_ARRAY_THICKNESS = 
  WALL_THICKNESS * 10
  + FATIGUE_THICKNESS * 2
  + CYCLIST_THICKNESS * 6
  + OTHERS_THICKNESS * 3;

// echo("DECK_ARRAY_THICKNESS", DECK_ARRAY_THICKNESS);

SHOW_DECKS = false;
SHOW_SIDE_DECK = false;

module deck(thickness) {
  cube([CARD_H, thickness, CARD_W]);
}

module deck_array(sep=WALL_THICKNESS) {
  function offset_dist(sep_count=0, fatigue_count=0, cyclist_count=0, others_count=0) =
    sep * sep_count
    + FATIGUE_THICKNESS * fatigue_count 
    + CYCLIST_THICKNESS * cyclist_count 
    + OTHERS_THICKNESS * others_count;
  
  translate([0, offset_dist( 0, 0, 0, 0), 0]) deck(CYCLIST_THICKNESS);
  translate([0, offset_dist( 1, 0, 1, 0), 0]) deck(CYCLIST_THICKNESS);
  translate([0, offset_dist( 2, 0, 2, 0), 0]) deck(CYCLIST_THICKNESS);
  translate([0, offset_dist( 3, 0, 3, 0), 0]) deck(CYCLIST_THICKNESS);
  translate([0, offset_dist( 4, 0, 4, 0), 0]) deck(CYCLIST_THICKNESS);
  translate([0, offset_dist( 5, 0, 5, 0), 0]) deck(CYCLIST_THICKNESS);
  
  translate([0, offset_dist( 6, 0, 6, 0), 0]) deck(FATIGUE_THICKNESS);
  translate([0, offset_dist( 7, 1, 6, 0), 0]) deck(FATIGUE_THICKNESS);
  
  translate([0, offset_dist( 8, 2, 6, 0), 0]) deck(OTHERS_THICKNESS);
  translate([0, offset_dist( 9, 2, 6, 1), 0]) deck(OTHERS_THICKNESS);
  translate([0, offset_dist(10, 2, 6, 2), 0]) deck(OTHERS_THICKNESS);
}

module outer_box() {
  translate([-WALL_THICKNESS, -WALL_THICKNESS, -WALL_THICKNESS])
    cube([CARD_H + WALL_THICKNESS * 2,
          DECK_ARRAY_THICKNESS + WALL_THICKNESS * 2,
          CARD_W * BOX_HEIGHT_RATIO + WALL_THICKNESS * 1]);
}

module grip_cutouts(d=CUTOUT_DIAMETER) {
translate([CARD_H/2, -DECK_ARRAY_THICKNESS/2, CARD_W*BOX_HEIGHT_RATIO + CUTOUT_OFFSET])
rotate([-90]) cylinder(DECK_ARRAY_THICKNESS*2, d=d);
}

module plain_box() {
  // card box model
  difference() {
    outer_box();
    deck_array();
    grip_cutouts();
  }
}

// debug decks
if (SHOW_DECKS) {
 color("Blue") deck_array();
}

if (SHOW_SIDE_DECK) {
 translate([100, 0, 0]) color("Blue") deck(CYCLIST_THICKNESS);
}


include <honeycomb.scad>
module ycomb() {
  difference() {
    translate([0, DECK_ARRAY_THICKNESS * 1.5, 0])
      rotate([90])
      linear_extrude(DECK_ARRAY_THICKNESS * 2)
      honeycomb_alt(CARD_H, CARD_W * BOX_HEIGHT_RATIO - WALL_THICKNESS, 5, 1);
    grip_cutouts(CUTOUT_DIAMETER+(WALL_THICKNESS*2));
  }
}

difference() {
  plain_box();
  ycomb();
}
