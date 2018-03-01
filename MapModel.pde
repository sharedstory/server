// Constants

// MapModel is responsible for maintaining state for the whole map. 
class MapModel {
  MapCellModel[][] cell_models;
  int rows, cols, hospitals_allowed;
  
  // Constructor
  MapModel(int[][] terrain, int _hospitals_allowed) {
    rows = terrain.length;
    cols = terrain[0].length;
    hospitals_allowed = _hospitals_allowed;
    cell_models = new MapCellModel[rows][cols];
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        cell_models[j][i] = new MapCellModel(i, j, terrain[j][i]);
      }
    }
  }
  
  // Counts the hospitals on the board 
  int num_hospitals() {
    int count = 0;
    for (MapCellModel[] cell_model_row : cell_models) {
       for (MapCellModel cell_model : cell_model_row) {
         if (cell_model.has_hospital) {
           count += 1;
         }
       }
    }
    return count;
  }
  
}