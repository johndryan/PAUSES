class RfidTag {
  String id, name, type;
  String[] phrases;
  boolean thing;
  RfidTag(String type, String id, boolean thing, String name, String[] phrases) {
    this.type = type;
    this.id = id;
    this.thing = thing;
    this.name = name;
    this.phrases = phrases;
  }
}  
