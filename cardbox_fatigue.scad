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
WALL_THICKNESS = 1.2;
// units: mm
CARD_W = 60;
// units: mm
CARD_H = 95;

// box height to card height ratio
BOX_HEIGHT_RATIO = 0.675;
// units: mm
CUTOUT_DIAMETER = CARD_W * 1;
// units: mm
CUTOUT_OFFSET = CARD_W * 1/8;

// units: mm
FATIGUE_THICKNESS = 24;
// units: mm
CYCLIST_THICKNESS = 16;
// units: mm
OTHERS_THICKNESS = 8;

// units: mm
HEX_RADIUS = 6;
// units: mm
HEX_SPACING = 1.2;

DECK_ARRAY_THICKNESS = 
  WALL_THICKNESS * 1
  + FATIGUE_THICKNESS * 2;

echo("DECK_ARRAY_THICKNESS", DECK_ARRAY_THICKNESS);

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
  
  translate([0, offset_dist( 0, 0, 0, 0), 0]) deck(FATIGUE_THICKNESS);
  translate([0, offset_dist( 1, 1, 0, 0), 0]) deck(FATIGUE_THICKNESS);
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
  // render()
  difference() {
    translate([0, DECK_ARRAY_THICKNESS * 1.5, 0])
      rotate([90])
      linear_extrude(DECK_ARRAY_THICKNESS * 2)
      honeycomb_alt(CARD_H, CARD_W * BOX_HEIGHT_RATIO - WALL_THICKNESS, HEX_RADIUS, HEX_SPACING);
    grip_cutouts(CUTOUT_DIAMETER+(WALL_THICKNESS*2));
  }
}

module box_sides_bottom() {
  intersection() {
    translate([-CARD_H/5, 0, -CARD_W/5])
      scale([1.25, 1, 1.25])
      deck_array();
    plain_box();
  }
}

module xcomb() {
  // render()
  translate([-CARD_H/2, 0, 0])
  scale([2, 1, 1])
  intersection() {
    translate([CARD_H+WALL_THICKNESS, 0, 0])
      rotate([0, -90, 0])
      linear_extrude(CARD_H + 2*WALL_THICKNESS)
      honeycomb_alt(CARD_W, DECK_ARRAY_THICKNESS, HEX_RADIUS, HEX_SPACING);
    deck_array();
    translate([0, 0, -WALL_THICKNESS]) 
      hull()
      plain_box();
  }
}

module zcomb() {
  // render()
  translate([0, 0, 5])
  scale([1, 1, 10])
  intersection() {
    translate([0, 0, -WALL_THICKNESS])
      linear_extrude(WALL_THICKNESS)
      honeycomb_alt(CARD_H, DECK_ARRAY_THICKNESS, HEX_RADIUS, HEX_SPACING);
    box_sides_bottom();
  }
}


difference() {
  plain_box();
  xcomb();
  ycomb();
  zcomb();
}
