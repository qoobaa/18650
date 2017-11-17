cell_length = 65.75;
cell_width = 18.75;
height = 13;
thickness = 1;

module spring(radius, cell_width, height, thickness, $fn = 12) {
     for (sx = [1, -1]) {
          scale([sx, 1, 1]) {
               cube([thickness + cell_width / 2 - 2 * radius + thickness, thickness, height + thickness]);
               translate([cell_width / 2 - radius + thickness, 0, 0]) {
                    difference() {
                         cylinder(height + thickness, radius, radius, $fn = $fn);
                         cylinder(height + thickness, radius - thickness, radius - thickness, $fn = $fn);
                         translate([-(cell_width / 2), -radius, 0])
                              cube([cell_width + thickness, radius, height + thickness]);
                    }
               }
          }
     }
}

module contact(width, size) {
     hull() {
          for (sx = [-1, 1]) {
               translate([sx * width, 0, 0])
                    sphere(size, $fn = 10);
          }
     }
}

module holder(cell_width, cell_length, height, thickness, hole_size = 1, contact_size = 1) {
     length = cell_length + contact_size;
     difference() {
          union() {
               difference() {
                    // body
                    cube([cell_width + 2 * thickness, length + 2 * thickness, height + thickness]);

                    // cell cavity
                    translate([thickness, thickness, thickness])
                         cube([cell_width, length, height]);

                    // spring spacer
                    translate([thickness, length, 0])
                         cube([cell_width, thickness, thickness]);

                    // spring wall removal
                    translate([0, length + thickness, 0])
                         cube([cell_width + 2 * thickness, thickness * 2, thickness + height]);
               }

               difference () {
                    // spring
                    translate([thickness + cell_width / 2, thickness + length, 0])
                         spring(radius = cell_width / 8, cell_width = cell_width, height = height, thickness = thickness);
               }
          }

          for (sz = [2, -2]) {
               translate([cell_width / 2 + thickness - hole_size / 2, 0, thickness + cell_width / 2 - hole_size / 2 + sz])
                    cube([hole_size, length + thickness * 2, hole_size]);
          }
     }

     for (y = [0, length]) {
          translate([cell_width / 2 + thickness, thickness + y, thickness + cell_width / 2])
               contact(width = cell_width / 8, size = contact_size);
     }
}

union() {
     for (i = [0 : 1]) {
          for (j = [0, 0]) {
               translate([i * (cell_width + thickness) + j * (cell_width + thickness * 2), j * thickness, 0]) rotate(j * 180)

                    difference() {
                    holder(cell_width = cell_width, cell_length = cell_length, height = height, thickness = thickness, hole_size = 1);

                    hull() {
                         translate([0, height + thickness, thickness])
                              rotate([45, 0, 0])
                              cube([cell_width + 2 * thickness, height * sqrt(2), height * sqrt(2)]);
                         translate([0, cell_length - height + thickness * 2, thickness])
                              rotate([45, 0, 0])
                              cube([cell_width + 2 * thickness, height * sqrt(2), height * sqrt(2)]);
                    }
               }
          }
     }
}
