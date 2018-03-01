class Fiducial {
  int id;
  MapCellModel model;
  String text;
  float x;
  float y;
  
  Fiducial(int _id, MapCellModel _model, String _text, float _x, float _y) {
    id = _id;
    model = _model;
    text = _text;
    x = _x;
    y = _y;
  }

  int getId() { return id; }
  MapCellModel getModel() { return model; }
  void setModel(MapCellModel _model) { model = _model; }
  String getText() { return text; }
  void setText(String _text) { text = _text; }
  float getX() { return x; }
  void setX(float _x) { x = _x; }
  float getY() { return y; }
  void setY(float _y) { y = _y; }
}