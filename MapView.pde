// MapView is responsible for rendering the whole map and managing interaction
// with the map.
class MapView {
  int cols, rows, x, y, map_width, map_height, cell_width, cell_height;
  MapCellView[][] cell_views;
  PImage[] tiles;
  PImage base_map;
  PImage timeline;
  MapCellModel active_cell_model;
  
  // Constructor
  MapView(int _cols, int _rows, int _x, int _y, int _map_width, int _map_height) {
    cols = _cols;
    rows = _rows;
    map_width = _map_width;
    map_height = _map_height;
    x = _x;
    y = _y;
    cell_width = map_width / cols;
    cell_height = map_height / rows;
    cell_views = new MapCellView[rows][cols];

    base_map = loadImage("sf-map.png");
    timeline = loadImage("timeline.png");
    
    // We can look up the filename for the tile image of a piece of terrain. Note that
    // this lives in the view, not the model, because it's more related to the 
    // presentation than to the data itself. 
    tiles = new PImage[] {
      loadImage("tiles/blank.png"),
      loadImage("tiles/hospital.png")
    };

    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        cell_views[j][i] = new MapCellView(
          x + i * cell_width, 
          y + j * cell_height, 
          cell_width, 
          cell_height, 
          tiles
        );
      }
    }
  }
  
  // Render kicks off the whole process of rendering the view. Most of the
  // work is delegated to the individual MapCellViews, but we do also show
  // the score and instructions text. 
  void render(MapModel model) {
    background(0);
    image(base_map, 0, 
          0,
          map_width,
          base_map.height * map_width / base_map.width);
    image(timeline, 0,
          map_height - timeline.height,
          map_width,
          timeline.height * map_width / timeline.width);
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        if (model.cell_models[j][i].has_hospital) {
          cell_views[j][i].render(model.cell_models[j][i]);
        }
      }
    }
    fill(0);
    text("Place markers on your home", x+map_width - 180, y+20);
    text("and other significant places", x+map_width - 180, y+32);
  }
  
  // Handles a mouse press event. 
  // When the mouse is pressed over a cell, select the existing hospital or
  // place a new one, if possible. 
  void handle_press(MapModel model) {
    int[] ix = get_mouse_cell_index();
    println("PRESS", ix[0], ix[1]);
    MapCellModel cell_model = model.cell_models[ix[1]][ix[0]];
    if (cell_model.is_free() && model.num_hospitals() < model.hospitals_allowed) {
        cell_model.has_hospital = true;
        active_cell_model = cell_model;
    }
    else if (cell_model.has_hospital) {
      active_cell_model = cell_model;
    }
    else {
      active_cell_model = null; 
    }
  }
  
  // Handles a mouse drag event (when the mouse moves while pressed).
  // If a hospital is selected, keep moving it wherever the mouse goes.
  void handle_drag(MapModel model) {
    if (mouse_over_map()) {
      int[] ix = get_mouse_cell_index();
      println("DRAG", ix[0], ix[1]);
      MapCellModel cell_model = model.cell_models[ix[1]][ix[0]];
      if (active_cell_model != null && cell_model != active_cell_model && cell_model.is_free()) {
       active_cell_model.has_hospital = false;
       cell_model.has_hospital = true;
       active_cell_model = cell_model;
      }
    }
  }
  
  // Handles a mouse release event. 
  // Deselect any active cell model.
  void handle_release() {
    println("RELEASE");
    active_cell_model = null; 
  }
  
  // Converts absolute mouse coordinates into the [i, j] coordinates of 
  // the cell it's currently over.
  int[] get_mouse_cell_index() {
    int i = (mouseX - x) / cell_width;
    int j = (mouseY - y) / cell_height;
    int[] cell = new int[] {max(0, min(cols-1, i)), max(0, min(rows-1, j))};
    return cell;
  }
  
  // Tells whether the mouse is over the map.
  boolean mouse_over_map() {
    return (x <= mouseX && mouseX < x+map_width && y <= mouseY && mouseY < y+map_height);
  }
}